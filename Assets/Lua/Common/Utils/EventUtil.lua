--------------------------------------------------------------------------------------------
-- @description 事件管理器
-- @author qf
-- @coryright 蜂鸟工作室
-- @release 2020-08-31
--------------------------------------------------------------------------------------------
local M = class(...)

function M:ctor()
    self.tmListener = {}
    
    self.tmBind = {}
end

function M:dispose()
    self:RemoveAll()
    M.super.dispose(self)
end

function M:RemoveAll()
    self:RemoveAllListener()
    self:UnbindAll()
    self:DeferAll()
end

--@region 事件
function M:AddListener(eventProxy, eventName, func)

    local handler = eventProxy:AddListener(eventName, func)

	local listener = {
		eventProxy = eventProxy,
		eventName = eventName,
		handler = handler
	}

	self.tmListener[listener] = listener
	return listener
end

function M:RemoveAllListener()
	local tmListener = self.tmListener
    if next( tmListener ) == nil then
        return
    end

    for _,  listener in pairs(tmListener) do
        local eventProxy = listener.eventProxy
        local eventName = listener.eventName
        local handler = listener.handler
        eventProxy:RemoveListener(eventName, handler)
    end
end

function M:RemoveListener(listener)
	local eventProxy = listener.eventProxy
    local eventName = listener.eventName
    local handler = listener.handler
    eventProxy:RemoveListener(eventName, handler) 
end
--@endregion

--@region GameCache
function M:Bind(cacheName, f)
    local cache = GameCacheMgr.GetGameCache(cacheName)
    self.tmBind[cacheName] = true

    cache:Bind(self, {
        onUpdate = f,
        onAdd = f,
        onDelete = f,
    })
end

function M:UnbindAll()
    for cacheName, _ in pairs(self.tmBind) do
        local cache = GameCacheMgr.GetGameCache(cacheName)
        cache:Unbind(self)
    end
    self.tmBind = {}
end
--@endregion

--@region Timer


--@endregion

--@region Defer
function M:AddDefer(defer)
    if not self.tlDefer then
        self.tlDefer = {}
    end
    self.tlDefer[#self.tlDefer+1] = defer
end

function M:DeferAll()
    if not self.tlDefer then return end
    for _, defer in ipairs(self.tlDefer) do
        defer()
    end
    self.tlDefer = nil
end

--@endregion

return M