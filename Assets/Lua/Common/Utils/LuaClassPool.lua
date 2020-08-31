--对象池
local M = class(...)

local PoolFactory = {}

function M.GetPool(Class)
	local pool = PoolFactory[Class]
	if pool then return pool end

	pool = M.new(Class)
	PoolFactory[Class] = pool
	return pool
end

function M.RemovePool( Class )
	local pool = PoolFactory[Class]
	if not pool then return end

	pool:Clear()
	PoolFactory[Class] = nil
end

function M:ctor(Class)
    self.Class = Class
    self.tlObjs= {}

    --暂且支持类
    self.type = "class"
end


function M:dispose()
	self:Clear()
end

function M:Clear()
	for k,obj in ipairs(self.tlObjs) do
		if obj.dispose then
			obj:dispose()
		end
	end
	self.tlObjs = {}
end


function M:GetFromPool(...)
	return self:GetFromPoolByIndex(#self.tlObjs, ...)
end


function M:GetFromPoolByIndex( index, ... )
	local obj = self.tlObjs[index]
	if not obj then
		local Class = self.Class
	  	obj = Class.new()
	else
		table.remove(self.tlObjs, index)
	end
	if obj.OnGetFromPool then
	  	obj:OnGetFromPool(...)
	end
	return obj
end


function M:ReturnToPool(obj)
	assert(obj, "返回池的obj不能为nil！！！")
	if obj.OnReturnToPool then
		obj:OnReturnToPool()
	end
	table.insert(self.tlObjs, obj)
end



-- 内存池对象继承
local LuaClassPoolObj = class("LuaClassPoolObj")
M.LuaClassPoolObj = LuaClassPoolObj
function LuaClassPoolObj:OnReturnToPool()
end

function LuaClassPoolObj:OnGetFromPool()
end



return M