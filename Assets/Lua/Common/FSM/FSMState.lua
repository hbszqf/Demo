local M = class(...)

function M:ctor(fsm, name)
    M.super.ctor(self)
    
    self.fsm = fsm
    self.name = name
end

function M:GetName()
    return self.name
end

function M:OnEnter()
end

function M:OnExit()
    
end

return M