local base = import(".base")
local M = class(..., base)



function M:OnEnter()
    if not self.tmRequest then
        self.tmRequest = {}
        self.requestCount = 0
    end
    self.timestamp = 0
end

function M:OnDisconnect()
    --如果不会自动重连
    if not self.socket.autoRecounnect then
        self.socket:SwitchTo("idle")
    else
        self.socket:SwitchTo("reconnect")
    end    
end

function M:AddNetworkRequest(request)
    self.requestCount = self.requestCount + 1
    self.tmRequest[request.index] = request
    --request:UpdateTimeStamp(self.timestamp)
    CSProxy.SendNetMessage( request:GetSendData(), self.socket.slot)
end

function M:OnReceivedMessage(data)
    local serverCmdData  = Proto.Decode("Response", data)
    self:OnReceivedMessage_Inner(serverCmdData)
end

local function _XPCALL(func, ...)
    local ret, msg = xpcall(func, tolua.traceback, ...)
    if not ret then
        Log.Error(msg)
    end
end


function M:OnReceivedMessage_Inner(serverCmdData)
    local apiId = serverCmdData.apiId
    local clientIndex = serverCmdData.clientIndex
    local serverIndex = serverCmdData.serverIndex
    local result = serverCmdData.result
    local data = serverCmdData.data

    local rspMessageName = Message.GetRspMessageName(apiId)

    self.socket.serverIndex = serverIndex
    self.socket.serverIndex_messageId = messageId

      --请求
    local request = self.tmRequest[clientIndex]
    self.tmRequest[clientIndex] = nil
    self.requestCount = self.requestCount - 1


    Log.QF("rspMessageName==",rspMessageName)
    if not result  then
        Log.Net(string.format("响应 %s 错误", rspMessageName))
        return 
    end



    --处理附加数据
    -- local cmdAppendData = serverCmdData.appendData
    -- if cmdAppendData ~= nil  then
    --     local tlAppendItem = cmdAppendData.appendItem or {}
    --     for _, cmdAppendItem in ipairs(tlAppendItem) do
    --         local messageId = cmdAppendItem.id
    --         local data = cmdAppendItem.data
    --         local name = Message.GetAppMessageName(messageId)

    --         if name then
    --             local cmdX = Proto.Decode(name,data)
    --             if cmdX then
    --                 --Event.Brocast(name, cmdX, request, self.socket)
    --                 _XPCALL(Event.Brocast, name, cmdX, request, self.socket)
    --             else
    --                 Log.Error( string.format("错误的数据包:%s", name) )
    --             end
    --         else
    --             Log.Error( string.format("App %s 缺少messageId",messageId) )
    --         end
    --     end

    -- end

    --反序列化
    local XDto = Proto.Decode(rspMessageName, data)
    if not XDto then
        Log.Error( string.format("错误的数据包:%s", rspMessageName) )
    end
    Log.QF:Dump(XDto)
    Log.QF:Dump(Proto.Build(rspMessageName,XDto))
end

return M