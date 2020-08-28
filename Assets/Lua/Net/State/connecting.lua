local base = import(".base")
require("3rd/pbc/protobuf")
local M = class(..., base)

function M:OnEnter()
    CSProxy.SendNetConnect(self.socket.ip , self.socket.port, self.socket.noDelay, self.socket.netCallback, self.socket.slot)
end     


--连接成功
function M:OnConnect(suc)
    if suc then
        -- local extend = protobuf.encode("com.kw.wow.proto.MailReadRq",{lordId=1,keyId="hbqf"})
        -- CSProxy.SendNetMessage(extend, self.socket.slot)
        -- Log.QF("发送数据到服务器")
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



function M:OnDisconnect()
    self.socket:SwitchTo("idle")
end

function M:AddNetworkRequest(request)
    request:OnTimeOut()
end

return M