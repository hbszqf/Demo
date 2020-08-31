local M = {}

function M.LoginGame(fCallback)
    local gameMgrFSM = M.GetGameMgrFSMInstance()
    return gameMgrFSM:LoginGame(fCallback)
end

return M