
-- if jit then
--     jit.off()
-- end
--local print = print
local M = {}
Main = M

require("Common.init")
require("Net.init")


--注册proto
do
    local protobufPath = CSProxy.PbPath
    -- for _, name in ipairs(tmProto.__loadlist__) do
        
    --     --protobuf.register_file(protobufPath .. name)
        
    --     Log.Print("注册 .pb 文件: " , name, path)
    --     protobuf.register_buffer(CsProxy.LoadFile(path))
    -- end
    protobuf.register_buffer(CSProxy.LoadFile(protobufPath.."/GameError.proto"))
    protobuf.register_buffer(CSProxy.LoadFile(protobufPath.."/GameMsg.proto"))
    protobuf.register_buffer(CSProxy.LoadFile(protobufPath.."/ApiMsg.proto"))
    protobuf.register_buffer(CSProxy.LoadFile(protobufPath.."/ApiUserDto.proto"))
    protobuf.register_buffer(CSProxy.LoadFile(protobufPath.."/ApiUser.proto"))
end


function M.StartMain()
    --默认
    --Network.Connect("192.168.1.150",8080,1)

    --周未
    --Network.Connect("192.168.1.227",9001,1)

    --大唐

    CorUtil.StartCor(function(corUtil)
        --先连接服务器
        local ret, msg = Network.Connect_cor("192.168.1.44", 9080, 1)

        if not ret then
            Log.QF("connect server error")
            return
        end

        Log.QF("连接服务器成功")

        --登录
        local params = {}
        params.centerUserId   = "hbqf"
        params.centerSession  = "123456"
        params.deviceId       = "1234454"
        params.deviceType     = "3"
        params.channel        ="444" 
        params.zone           ="23456"

        local ret, userLoginRsp = Network.Send_cor("UserLogin",params)
        


    end)

    --Network.Connect("192.168.1.80",3000,1)

end 

function M.ReleaseMain()
end 

return  M
