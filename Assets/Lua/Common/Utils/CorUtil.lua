--普通协程帮助类



local running = coroutine.running
local yield = coroutine.yield
local resume = coroutine.resume
local unpack = unpack



local M = class(...)
local M_comap = {}
setmetatable(M_comap, {__mode = "kv"})

function M:ctor()
    self.cor = running()
    assert(self.cor, "当前函数只能运行在协程中")
    --是否Resume
    self.isResume = false
    --是否Yield
    self.isYield = false
    --Resume时的返回值
    self.tlRet = nil
end

function M:Yield()
    self.isYield = true

    if not self.isResume then
        M_comap[self.cor] = true
        self.tlRet = { yield() }
    end
    local tlRet = self.tlRet
    self.isResume = false
    self.isYield = false
    self.tlRet = nil
    return unpack(tlRet or {})
end

function M:Resume(...)
    self.isResume = true
    if self.isYield then
        M_comap[self.cor] = nil
        local flag, msg = resume(self.cor, ...)
        if not flag then        
            msg = debug.traceback(self.cor, msg)                  
            error(msg)              
        end 
    else
        self.tlRet = {...}
    end
end

function M:Wait(time)
    coroutine.wait(time)
end


function M.StartCor(callFunc)
    local task = function()
        local corUtil = CorUtil.new()
        callFunc(corUtil)
    end
    coroutine.start(task)
end

return M