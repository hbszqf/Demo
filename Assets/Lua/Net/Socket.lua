local StateIdle = import(".State.idle")
local StateConnected = import(".State.connected")
--local StateReconnect = import(".State.reconnect")
local StateConnecting = import(".State.connecting")

local M = class(..., FSM)

function M:ctor(slot, autoRecounnect, isLog)
    M.super.ctor(self)
    self.slot = slot
    self.clientIndex = 0

    self.autoRecounnect = autoRecounnect
    self:AddState("idle", StateIdle)                --空闲
    self:AddState("connected", StateConnected)      --连接
    --self:AddState("reconnect", StateReconnect)      --重连中
    self:AddState("connecting", StateConnecting)    --连接中

    self.netCallback = function(event, data)
        Log.QF(event)
        if event == 101 then
            self:OnConnect(true)
        elseif event == 102 then
            self:OnException()
        elseif event == 103 then
            self:OnDisconnect()
        elseif event == 104 then
           self:OnReceivedMessage(data)
        elseif event == 105 then
            --self:OnConnect(false)
        end   
    end

    
    self.timer = Timer.New(function()
        self:OnUpdate()
    end,1,-1):Start()

    --初始切換到idle
    self:SwitchTo("idle")
end

--连接服务器
function M:Connect(ip, port, serverId, connectCallback, disconnectCallback)
    assert(self:GetState() == "idle", string.format("self:GetState = %s", self:GetState()) )
    
    self.serverId = serverId
    self.ip= ip
    self.port = port
    self.fConnectCallback = connectCallback
    self.fDisconnectCallback = disconnectCallback

    Log.Net('【连接服务器】ip = ' .. ip .. "; port = " .. port)

    self:SwitchTo("connecting")
end



function M:OnUpdate()
    Log.QF(self:GetCurrentState():GetName())
    self:GetCurrentState():OnUpdate()
end

--发送数据给服务器
function M:Send(tmParams)
    local request = NetworkRequest.GetFromPool(tmParams)
    local clientRequestData  = self:CreateClientRequestData(tmParams.messageName,tmParams.params)
    request.index = clientRequestData.clientIndex
    
    local sendData = Proto.Encode("Request", clientRequestData)
    request:SetSendData(sendData)
    self:GetCurrentState():AddNetworkRequest(request)
end 


function M:GetState()
    local state = self:GetCurrentStateName()
    return state
end

function M:OnSwitch(lastStateName, nextStateName)
    --连接状态切换到已连接状态
    if lastStateName=="connecting" and nextStateName =="connected" then
        if self.fConnectCallback then self.fConnectCallback(true) end
    end

    --连接失败
    if lastStateName=="connecting" and nextStateName =="idle" then
        if self.fConnectCallback then self.fConnectCallback(false) end
    end
end

----------------------------------------------------------


--断线
function M:OnDisconnect()
    self:GetCurrentState():OnDisconnect()
end

--异常
function M:OnException()
    self:GetCurrentState():OnException()
end

--连接成功
function M:OnConnect(suc)
    self:GetCurrentState():OnConnect(suc)
end

--收到数据包
function M:OnReceivedMessage(data)
    self:GetCurrentState():OnReceivedMessage(data)
end

--创建客户端最外层数据包
function M:CreateClientRequestData(messageName,tmParams)
    local messageId = Message.GetMessageId(messageName)
    if messageId == nil then
        assert(false, string.format("%s 的 messageId 为空",messageName))
        return false
    end

    local reqMessageName = Message.GetReqMessageName(messageId)
    
    self.clientIndex = self.clientIndex + 1
    local data = Proto.Encode(reqMessageName,tmParams)

    local clientRequestData = {}
    clientRequestData.apiId = messageId
    
    clientRequestData.clientIndex = self.clientIndex
    clientRequestData.data = data

    return clientRequestData
end




return M