local StateIdle = import(".State.idle")
local StateLogin = import(".State.login")

local M = class(..., FSM)

function M:ctor()
    M.super.ctor(self)

    self:AddState("idle", StateIdle)                       --空闲
    self:AddState("login", StateLogin)                     --登录

    self:SwitchTo("idle")

end

function M:LoginGame(fCallback)
    local state = self:GetCurrentState()
    state:LoginGame(fCallback)
end


return M