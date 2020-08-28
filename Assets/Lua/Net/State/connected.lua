local base = import(".base")
local M = class(..., base)




function M:AddNetworkRequest(clientRequestData)
    CSProxy.SendNetMessage(clientRequestData, self.socket.slot)
end

function M:OnReceivedMessage(data)
    Log.QF("客户端connect状态接受到数据")
    local serverCmdData = protobuf.decode("com.kw.wow.proto.Response", data)
    Log.QF:Dump(serverCmdData)

    local data = serverCmdData.data
    local userLoginRsp = protobuf.decode("com.kw.wow.proto.UserLoginRsp", serverCmdData.data)


    --local userLoginRsp1 = protobuf.decode("com.kw.wow.proto.DtoUser", userLoginRsp.user)
    Log.QF:Dump(userLoginRsp)

end
return M