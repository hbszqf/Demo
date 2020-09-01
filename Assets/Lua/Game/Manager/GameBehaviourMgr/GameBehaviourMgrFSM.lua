local StateIdle = import(".State.idle")
local StateLogin = import(".State.login")

local M = class(..., FSM)
--游戏生命周期状态机
local M_ShareInstance = nil
function M.GetInstance()
    if not M_ShareInstance then
        M_ShareInstance = M.new()
    end
    return M_ShareInstance
end

function M:ctor()
    M.super.ctor(self)

    self:AddState("idle", StateIdle)                       --空闲
    self:AddState("login", StateLogin)                     --登录
    self:SwitchTo("idle")

end

function M:LoginGame(fCallback)
    self:SwitchTo("login", fCallback)
end


return M