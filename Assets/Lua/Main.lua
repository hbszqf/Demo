--mobile环境下, 开启jit会导致性能下降, 所以统一关闭jit


-- if jit then
--     jit.off()
-- end
--local print = print
local M = {}
Main = M
function M.StartMain()
    print(" M.StartMain 111111111111111111111111111111")
end 

function M.ReleaseMain()
    print(" ReleaseMain 222222222222222222222222222222")
end 

return  M
