
-- if jit then
--     jit.off()
-- end
--local print = print
local M = {}
Main = M

require("Common.init")
require("Net.init")
require("Game.Manager.init")
require("Game.Controller.init")



function M.StartMain()

    --Network.Connect("192.168.1.80",3000,1)

    --默认
    --Network.Connect("192.168.1.150",8080,1)

    --周未
    --Network.Connect("192.168.1.227",9001,1)

    --大唐

    -- if true then
    --     return 
    -- end

    

    --登录游戏
    --GameBehaviourMgr.LoginGame()


    CorUtil.StartCor(function(corUtil)
        --先连接服务器
        Log.QF("main测试连接服务器")
        local ret, msg = Network.Connect_cor("192.168.129.157", 6545, 1)

        if not ret then
            Log.QF("connect server error")
            return
        end

        --Log.QF("main测试连接服务器")

        --登录
        local params = {}
        params.test_number   = 1
        params.test_str  = "test"
        -- params.deviceId       = "1234454"
        -- params.deviceType     = "3"
        -- params.channel        ="444" 
        -- params.zone           ="23456"

        local ret, userLoginRsp = Network.Send_cor("ReqTest",params)
    end)


end 

function M.ReleaseMain()
end 

return  M
