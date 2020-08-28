
local M = class(..., FSMState)

function M:ctor(socket, name)
    M.super.ctor(self, socket, name)
    self.socket = socket
end

--连接成功
function M:OnConnect(suc)
end

--异常
function M:OnException()
end

--接收到数据
function M:OnReceivedMessage(data)
end

--失去连接
function M:OnDisconnect()
end

--将请求加入队列
function M:AddNetworkRequest(request)
end


return M