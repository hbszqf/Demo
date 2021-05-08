local Socket = import(".Socket")

local M = {}
--重连后面处理
local autoRecounnect =  false
local socket = Socket.new(0, autoRecounnect, isLog)


--连接到服务器
function M.Connect(ip, port, serverId, connectCallback, disconnectCallback)
    socket:Connect(ip,port,serverId,connectCallback,disconnectCallback)
end

--连接服务器协程版
function M.Connect_cor(ip, port, serverId, disconnectCallback)
    local cor = CorUtil.new()
    M.Connect(ip, port, serverId, function(...)
        cor:Resume(...)
    end, disconnectCallback)
    return cor:Yield()
end

-- 消息发送--
function M.Send(tmParams)  
    socket:Send(tmParams)
end

--内部接口消息发送协程版本
function M.SendInner_cor(tmParams)
    local cor = CorUtil.new()

    tmParams.callback = function(xRsp)
        cor:Resume( true, xRspMsg)
    end

    tmParams.errorCallback = function(cmdResult)
        cor:Resume( false, cmdResult)
    end

    tmParams.timeoutCallback = function()
        cor:Resume( false )
    end

    M.Send(tmParams)

    return cor:Yield()
end

--外部调用接口
function M.Send_cor(messageName,tmParams,isSilence)
    local params = {}
    params.messageName = messageName
    params.params      = tmParams
    params.isSilence   = isSilence or true
    return M.SendInner_cor(params)
end

function M.GetSocket()
    return socket
end

function M.GetState()
    return socket:GetState()
end


return  M