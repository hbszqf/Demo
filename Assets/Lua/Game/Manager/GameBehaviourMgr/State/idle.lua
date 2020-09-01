local base = import(".base")
local M = class(..., base)

function M:OnEnter(fErrCallback, fOnDisconnect)
end

function M:OnExit()
    M.super.OnExit(self)
end


return M