--有限状态机
local M = class(...)
function M:ctor()
    M.super.ctor(self)
    
    --所有状态
    self.tmState = {}
    --当前状态
    self.curState = nil
end


function M:dispose()
    if self.isDisposed then return end
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
    self.curState = newState
    if newState ~= nil then 
        newState:OnEnter(...)
    end
end


return M