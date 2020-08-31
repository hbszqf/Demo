--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "3rd.event.eventlib"

local Event = {}
local events = {}

function Event.AddListener(event,handler)
	if not event or type(event) ~= "string" then
		error("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect(handler)

	return handler
end

function Event.Brocast(event,...)
	if not events[event] then
		--error("brocast " .. event .. " has no event.")
        --logWarn("brocast " .. event .. " has no event.")
        return false
	else
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if not events[event] then
		--error("remove " .. event .. " has no event.")
        --logWarn("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler)
	end
end


Event2 = {}

function Event2:AddListener(event,handler)
	return Event.AddListener(event, handler)
end

function Event2:RemoveListener(event, handler)
	return Event.RemoveListener(event, handler)
end

return Event