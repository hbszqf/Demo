local M = {}

local GameBehaviourMgrFSM = import(".GameBehaviourMgrFSM")

--游戏生命周期状态机对外接口
function M.LoginGame(fCallback)
    local gameBehaviourMgrFSM = GameBehaviourMgrFSM.GetInstance()
    return gameBehaviourMgrFSM:LoginGame(fCallback)
end

return M