
-- if jit then
--     jit.off()
-- end
--local print = print
local M = {}
Main = M

require("Common.init")
function M.StartMain()
    print(" M.StartMain 111111111111111111111111111111")
end 

function M.ReleaseMain()
    print(" ReleaseMain 222222222222222222222222222222")
end 

return  M
