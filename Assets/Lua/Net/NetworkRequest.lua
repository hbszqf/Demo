local M = class(...)

--申请一个 NetWorkRequest缓存池
local netWorkRequestPool = LuaClassPool.GetPool(M)


function M.GetFromPool(params)
    local request = netWorkRequestPool:GetFromPool()
    request:SetParams(params)
    return request
end

function M.ReturnToPool()
    netWorkRequestPool:ReturnToPool(request)
end

function M:SetParams(params)
    self.messageName = params.messageName
    self.tmParams    = params.params
    --正常回调(function)
    self.fCallback   = params.callback
    --错误回调(function)
    self.fErrorCallback = params.errorCallback
    --超时回调(function)
    self.fTimeoutCallback = params.timeoutCallback
    --时间
    self.timestamp = os.time()
    --自动重连
    self.isAutoReconnect = (isAutoReconnect==nil and true or isAutoReconnect)
    --请求数据
    self.sendData = nil
end

function M:SetSendData(sendData)
    self.sendData = sendData
end

function M:GetSendData()
    return self.sendData
end


function M:GetTimeStamp()
    return self.timestamp
end



return  M