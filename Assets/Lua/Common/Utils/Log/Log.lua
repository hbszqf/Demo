
local M = class(...)

-- 调用方式 Log.QF()
setmetatable(M, {
    __index = function(table,key)
        local value = rawget(table,key)
        if not value then
            value = M.__create(key)
            rawset(table,key,value)
        end
        return value
    end,

    __call = function(...)
        M.__Print(M,...)
    end
})


function M.__create(name)
    return M.new(name)
end


function M.ctor(name)
    self.isEnabled = false
    self.color = "#23A8FF"
    self.name = name
    self.isPrintTraceback = true
    self.prefix = string.format('<color=%s><%s>: </color>', self.color, self.name)
end

--Log开启开关
function M:SetIsEnable(isEnabled)
    self.isEnabled = isEnabled
    return self
end


function M:SetName(name)
    self.name = name
    self.prefix = string.format('<color=%s><%s>: </color>', self.color, self.name)
    return self
end

function M:SetColor(color)
    self.color = color
    self.prefix = string.format('<color=%s><%s>: </color>', self.color, self.name)
    return self
end

function M:SetIsPrintTraceback(is)
    self.isPrintTraceback = is
end

function M:__Print(...)
    if self.isEnabled then
        local tl = {self.prefix, ...}
        if self.isPrintTraceback then
            tl[#tl+1] = "\n"
            tl[#tl+1] = debug.traceback()
        end
        print( unpack(tl) )
    end
end

function M.Error(...)
    local tl = {...}
    UnityEngine.Debug.LogError(table.concat( tl, " ") .. "\n" .. debug.traceback())
end

function M.Warning(str, ...)
    UnityEngine.Debug.LogWarning(str .. "\n" .. debug.traceback())
end


-- 输出值的内容--
-- @param mixed value 要输出的值
-- @param [string desciption] 输出内容前的文字描述
-- @parma [integer nesting] 输出时的嵌套层级，默认为 3
function M:Dump(value, desciption, nesting)
    if not self.isEnabled then return end

    if type(nesting) ~= "number" then
        nesting = 3
    end

    local tlMsg = {}
    local print = function(...)
        table.insertto(tlMsg, {...})
    end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = '"' .. v .. '"'
        end
        return tostring(v)
    end

    local spc
    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    values[k] = v
                end
                table.sort(
                    keys,
                    function(a, b)
                        if type(a) == "number" and type(b) == "number" then
                            return a < b
                        else
                            return tostring(a) < tostring(b)
                        end
                    end
                )
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, " ", 1)

    for i, line in ipairs(result) do
        print(line)
    end

    self:__Print(table.concat(tlMsg, "\n"))
end










return M