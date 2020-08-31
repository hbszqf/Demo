
local tmProto = import(".tmProto")
--注册proto
do
    --注册pb文件
    local protobufPath = CSProxy.PbPath
    for _, name in ipairs(tmProto.__loadlist__) do
        local path = protobufPath.."/"..name
        Log.Print("注册 .pb 文件: " , name, path)
        protobuf.register_buffer(CSProxy.LoadFile(path))
    end
end


--注册每个字段的类型
for _, proto in pairs(tmProto) do
    if proto.type == "message" then
        for _, field in pairs(proto.tmField) do
            local proto = tmProto[field.type]
            if proto and proto.type == "message" and field.prefix ~= "repeated" then
                field.ismessage = true
            end
            if proto and proto.type == "enum" and field.prefix ~= "repeated" then
                field.isenum = true
            end
            if field.prefix == "repeated" then
                field.isrepeated = true
                if proto and proto.type == "message" then
                    field.isrepeatedmessage = true
                end
            end
        end  
    end
end


local M = {}
--编码
function M.Encode(protoName,data)
    local proto = M.getProto(protoName)
    local ret, msg = protobuf.encode(proto.fullName, data)
    return ret
end


--解码
function M.Decode(protoName,data)
    local proto = M.getProto(protoName)
    return protobuf.decode(proto.fullName, data)
end

function M.getProto(protoName)
    return tmProto[protoName]
end

--生成一个完整的table
function M.Build(protoName, data)
    Log.QF("build protoName=="..protoName)
    local proto = M.getProto(protoName)
    local tmField = proto.tmField
    local copy = {}

    -- local extend = M.GetExtend(protoName)
    -- if extend then
    --     setmetatable(copy, extend)
    -- end
    Log.QF:Dump(tmField)
    Log.QF:Dump(data)
    for fieldName, field in pairs(tmField) do

        local value = data[fieldName]

        --如果是message 展开之
        if value then
            if field.prefix == "repeated" then
                local temp = {}
                if field.isrepeatedmessage == true then
                    for index, item in ipairs(value) do
                        temp[index] = M.build(field.type, item)
                    end
                else
                    for index, item in ipairs(value) do
                        temp[index] = item
                    end
                end
                value = temp
            else
                if field.ismessage == true then
                    value = M.Build(field.type, value)
                end
            end
        end
        copy[fieldName] = value
    end
    return copy
end




return M