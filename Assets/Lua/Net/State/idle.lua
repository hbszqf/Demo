local base = import(".base")
local M = class(..., base)



--切换到空闲状态手切断掉连接
function M:OnEnter()
    CSProxy.NetDisconnect(self.socket.slot)
end

function M:AddNetworkRequest(request)
    request:OnTimeOut()
end

function M:OnUpdate()

end

return M