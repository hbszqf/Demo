
-- if jit then
--     jit.off()
-- end
--local print = print
local M = {}
Main = M

require("Common.init")
function M.StartMain()
    -- CSProxy.LoadRes("Actor/Boss/boss_001/boss_001.prefab",function(go)
    --     Log.QF("load finish")
    --     Log.QF:Dump(go)
    --     Log.QF:Dump(go.transform.position)
    -- end)

end 

function M.ReleaseMain()
end 

return  M
