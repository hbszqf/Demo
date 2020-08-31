--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local eventlib = require "3rd.event.eventlib"

local M = class(...)

function M:ctor()
	self.events = {}
end

function M:dispose()
    self:RemoveAllListener()
    M.super.dispose(self)
end

function M:AddListener(event, handler)

    local events = self.events

	--if not event or type(event) ~= "string" then
	--	error("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	--end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		events[event] = eventlib:new(event)
	end

	events[event]:connect(handler)

    return handler
end

function M:Brocast(event,...)
    local events = self.events
	if not events[event] then
        return false
	else
		events[event]:fire(...)
	end
end

function M:RemoveListener(event,handler)
    local events = self.events
    if not events then
        return
    end
	if not events[event] then
	else
		events[event]:disconnect(handler)
	end
end

function M:RemoveAllListener(event)
    local events = self.events
    if event then
        events[event] = nil
    else
        self.events = {}
    end
end

function M:GetTmEvent()
    return self.events
end

if false then
    local eventProxy = M.New()
    local handler = eventProxy:AddListener("event", function(...)
        print("receive ",...)
    end)
    print("Broadcast Event")
    eventProxy:Brocast("event", "event")
    eventProxy:RemoveAllListener("event1")
    print("Broadcast Event")
    eventProxy:Brocast("event", "event")
end

return M