--有限状态机
local M = class(...)
function M:ctor() 
    --所有状态
    self.tmState = {}
    --当前状态
    self.curState = nil
end


function M:dispose()
    if self.isDisposed then return end

    if self.curState  then
        self.curState:OnExit()
    end
    for _, state in pairs( self.tmState ) do
        state:dispose()
    end
    self.tmState = nil
    self.curState = nil
    self.isDisposed = true
    M.super.dispose(self)
end

function M:AddState(name,class_fsmState)
    self.tmState[name] = class_fsmState.new(self, name)
end


function M:SwitchTo(name)
    local newState = self.tmState[name]
    local oldState = self.curState

    if newState == oldState then
        return 
    end

    if oldState~=nil then
        oldState:OnExit()
    end
    self.lastState = oldState
    self.curState = newState
    if newState ~= nil then 
        newState:OnEnter()
    end

    self:OnSwitch(oldState and oldState:GetName(), newState and newState:GetName())   
end


function M:OnSwitch(lastName, nextName)

end

--获取状态机的当前状态
function M:GetCurrentState()
    return self.curState
end

--获取状态机当前的状态名称
function M:GetCurrentStateName()
    return self.curState:GetName()
end

--获取状态机上一次的状态
function M:GetLastState()
    return self.lastState
end

--获取状态机上一次状态的名称
function M:GetLastStateName()
    return self.lastState and self.lastState:GetName()
end

--根据名称获取状态机
function M:GetFSMState(name)
    return self.tmFSMState[name]
end


return M