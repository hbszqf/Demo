local base = import(".base")
require("3rd/pbc/protobuf")
local M = class(..., base)

function M:OnEnter()
    self.isException = false
    CSProxy.SendNetConnect(self.socket.ip , self.socket.port, self.socket.noDelay, self.socket.netCallback, self.socket.slot)
    
    if not ret then
        self.isException = true
    end
end     

function M:OnUpdate()
    if self.isException then
        self:OnConnect(false)
    end
end

--连接成功
function M:OnConnect(suc)
    if suc then
        Log.QF("【连接服务器成功】ip = " .. self.socket.ip .. "; port = " .. self.socket.port)
        self.socket:SwitchTo("connected")
    else
        Log.QF("【连接服务器失败】ip = " .. self.socket.ip .. "; port = " .. self.socket.port)
        self.socket:SwitchTo("idle")
    end
end

--异常
function M:OnException()
    self.socket:SwitchTo("idle")
end

--接收到数据
function M:OnReceivedMessage(data)
end

function M:OnDisconnect()
    self.socket:SwitchTo("idle")
end

function M:AddNetworkRequest(request)
    request:OnTimeOut()
end

return M