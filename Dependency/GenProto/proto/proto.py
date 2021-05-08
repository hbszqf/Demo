#-*- coding: UTF-8 -*-

#有空用c#版本的peg库换掉吧 唉

from __future__ import unicode_literals
from __future__ import print_function
from pypeg2 import *
from pypeg2.xmlast import thing2xml
import re, os, types, sys
import shutil 
import time

digit =  re.compile(r"\d+")
protofilename = re.compile(r"\w+.proto")


#########################
# proto的语法解析树
#########################
class FullName(list):
    grammar = word , maybe_some( ".", word )

class Package(str):
    grammar = K("package"),  attr("FullName", FullName), ";"

class Import(str):
    grammar = K("import"), '"', maybe_some( word, r'/'),  attr("name", protofilename), '";'

class ImportList(list):
    grammar = maybe_some(Import)

class FieldPrefix(Keyword):
    grammar = Enum(K("optional"),K("required"), K("repeated"))

class FieldType(Keyword):
    grammar = Enum(    K("double"),    K("float"),    K("uint64"),    K("int"),    K("int32"),    K("int64"),    K("fixed64"),    K("fixed32"),    K("bool"),    K("string"),    K("bytes"),    K("uint32"),    K("sfixed32"),    K("sfixed64"),    K("sint32"),    K("sint64"))

class Default(str):
    grammar = "[", "default", "=", word, "]" 

class Field(str):
    grammar = attr("FieldPrefix", FieldPrefix), attr("type", [FieldType, FullName]), name(), "=", attr("fieldNumber", digit), maybe_some(Default),  ";"

class Message(list):
    grammar = "message", name(), "{", maybe_some(Field), "}"

class EnumItem(str):
    grammar = name(), "=", attr("index", digit), ";"

class Enum(list):
    grammar = "enum", name(), "{", maybe_some(EnumItem), "}"

class Content(list):
    grammar = maybe_some([Message,Enum])

class Proto(list):
    grammar = attr("Package",Package), attr("ImportList",ImportList), attr("Content", Content)


##############################
# python的dict转换为lua的table
##############################

def space_str(layer):
    spaces = ""
    for i in range(0,layer):
        spaces += '\t'
    return spaces

def dic_to_lua_str(data,layer=0):

    d_type = type(data)
    if  d_type is types.StringTypes or d_type is str or d_type is types.UnicodeType:
        yield ("'" + data + "'")
    elif d_type is types.BooleanType:
        if data:
            yield ('true')
        else:
            yield ('false')
    elif d_type is types.IntType or d_type is types.LongType or d_type is types.FloatType:
        yield (str(data))
    elif d_type is types.ListType:
        yield ("{\n")
        yield (space_str(layer+1))
        for i in range(0,len(data)):
            for sub in  dic_to_lua_str(data[i],layer+1):
                yield sub
            if i < len(data)-1:
                yield (',')
        yield ('\n')
        yield (space_str(layer))
        yield ('}')
    elif d_type is types.DictType:
        yield ("\n")
        yield (space_str(layer))
        yield ("{\n")
        data_len = len(data)
        data_count = 0
        for k,v in data.items():
            data_count += 1
            yield (space_str(layer+1))
            if type(k) is types.IntType:
                yield ('[' + str(k) + ']')
            else:
                yield (k) 
            yield (' = ')
            try:
                for sub in  dic_to_lua_str(v,layer +1):
                    yield sub
                if data_count < data_len:
                    yield (',\n')

            except Exception, e:
                print('error in ',k,v)
                raise
        yield ('\n')
        yield (space_str(layer))
        yield ('}')
    else:
        raise d_type , 'is error'

def data_to_lua_str(data):
    l = []
    #bytes = ''
    for it in dic_to_lua_str(data):
        #bytes += it
        l.append(it)

    
    return "".join(l)

####################
#  protoc.exe 编译lua
####################
def compileAllProto(proto_dir, proto_out_dir):
    print(u"###############")
    print(u"编译proto文件")
    print(u"###############")
    folder = proto_out_dir
    #if os.path.exists(folder):
    #    shutil.rmtree(folder)

    #os.mkdir(folder)

    importSearchPath = os.path.join(proto_dir, "proto")

    for root, dirs, fils in os.walk(proto_dir):
        for fil in fils:
            try:
                if not fil.endswith(".proto"):
                    continue
                in_path = os.path.join(root,fil)

                out_path = os.path.join(folder, fil)

                cmd = "protoc -I %s  --descriptor_set_out %s %s"%( proto_dir, out_path, in_path )

                ret = os.system(cmd)
                print("result:%s %s"%(fil,ret) )
            except:
                pass

def getProtoList(proto_dir):
    '''
    获取排好序的Proto
    '''
    protoDict = {}

    print(u"###############")
    print(u"解析proto文件")
    print(u"###############")
    for root, dirs, fils in os.walk(proto_dir):
        for fil in fils:
            try:
                if not fil.endswith(".proto"):
                    continue

                in_path = os.path.join(root,fil)
                doc = open(in_path).read()
                doc = doc.decode("utf-8")
                print(in_path)
                proto = parse(doc, Proto, comment=[comment_cpp,comment_c])


                #储存fil
                proto.fil = fil
                proto.path = in_path
                protoDict[fil] = proto
            except:
                pass

    #根据proto的引用关系来排序
    protoList = []

    def haspoto(proto):
        for _ in protoList:
            if _.fil == proto.fil:
                return True
        return False

    while True:
        has = False
        for item in protoDict.items():
            fil, proto = item
            if haspoto(proto):
                continue

            no_ref = False
            for Import in proto.ImportList:
                ref_proto = protoDict[Import.name]
                if not haspoto(ref_proto):
                    no_ref = True
                    break
            if no_ref:
                continue

            protoList.append(proto)
            has = True
            break

        
        if not has:
            break

    
    return protoList

def enum2Lua(enum, fullName, name):
    '''
    把enum转换为Lua
    '''
    info = {}

    enums = {}

    info["type"] = "enum"

    info["enums"] = enums

    info["fullName"] = fullName

    info["name"] = name

    for enumItem in enum:
        enums[str(enumItem.name)] = int(enumItem.index)

    return info
    

def message2Lua(message, fullName, name):
    '''
    把message转换为Lua
    '''
    info = {}
    fieldInfos = {}
    fieldNames = []

    info["fullName"] = fullName

    info["tmField"] = fieldInfos

    info["type"] = "message"

    info["name"] = name

    #info["fields"] = fieldNames

    for field in message:
        
        fieldInfo = {}
        fieldInfo["prefix"] = str(field.FieldPrefix)

        typename = type(field.type).__name__
        if typename == "FullName":
            fieldInfo["type"] = str(field.type[-1])
        elif typename == "FieldType":
            fieldInfo["type"] = str(field.type)

        fieldInfo["name"] = str(field.name)

        fieldInfo["fieldNumber"] = int(field.fieldNumber)

        fieldInfos[fieldInfo["name"]] = fieldInfo

        fieldNames.append(fieldInfo["name"])
    

    return info

##################################
# 解析proto文件, 生成lua内省文件
##################################    
def parseAllProto(proto_dir, protos_path):
    '''

    '''
    protoList = getProtoList(proto_dir)

    data = {}

    #加载次序
    print(u"###############")
    print(u"生成lua映射文件")
    print(u"###############")
    loadlist = []
    data["__loadlist__"] = loadlist
    for proto in protoList:
        loadlist.append(str(proto.fil))

    for proto in protoList:
        
        package = ".".join( proto.Package.FullName )
        
        for content in proto.Content:

            operator = {
                'Message':message2Lua,
                'Enum':enum2Lua
            }

            fullName = ".".join( (package, content.name) )

            info = operator[type(content).__name__](content, fullName, str(content.name) )
    
            data[content.name] = info


    print("映射文件转为lua")
    doc = '''
local M = 
%s
return M
    '''
    doc = doc%data_to_lua_str(data)
    path = protos_path
    dirpath = os.path.dirname(path)
    if not os.path.exists(dirpath) :
        os.makedirs(dirpath)
    open(path, "w").write(doc)



if __name__ == "__main__":

    protos_path = r"/Users/qinfang/unitygame/Demo/Assets/Lua/Net/tmProto.lua"
    proto_dir = r"/Users/qinfang/unitygame/Demo/Dependency/GenProto/proto/protos"
    proto_out_dir = r"/Users/qinfang/unitygame/Demo/Assets/ResArt/DynamicArt/Protobuf"

   

    try:
        # proto_dir = sys.argv[1]
        # proto_out_dir = sys.argv[2]
        # protos_path = sys.argv[3]

        
        compileAllProto(proto_dir, proto_out_dir)
        parseAllProto(proto_dir, protos_path)
        print(u"完成")    
    except Exception, e:
        print(u"失败",e)

    









