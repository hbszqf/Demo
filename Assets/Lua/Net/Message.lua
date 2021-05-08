local Proto = import(".Proto")


local M = {}

local proto_message = Proto.getProto("MessageId")

--消息名字 和 消息Id的映射
local tmMessageId_MessageName = {}

--消息Id 和 消息名字的映射
local tmMessageName_MessageId = {}

--建立映射关系
for messageName, messageId in pairs( proto_message.enums ) do
    messageName = string.sub( messageName,  1, -4)
    tmMessageId_MessageName[messageName] = messageId
    tmMessageName_MessageId[messageId] = messageName
end

--消息id获取消息名
function M.GetMessageName(messageId)
    return tmMessageName_MessageId[messageId]
end

--消息名获取消息id
function M.GetMessageId(messageName)
    return tmMessageId_MessageName[messageName]
end

--获取请求消息名字
function M.GetReqMessageName(messageId)
    return tmMessageName_MessageId[messageId]
end

--获取响应消息名
function M.GetRspMessageName(messageId)
    local messageName = tmMessageName_MessageId[messageId]
    return messageName
end


return  M