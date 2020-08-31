local M = class(..., FSMState)

function M:ctor(gameMgr, name)
    M.super.ctor(self, gameMgr, name)
    self.gameMgr = gameMgr
end




return M