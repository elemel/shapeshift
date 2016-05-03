local InstancePool = {}
InstancePool.__index = InstancePool

function InstancePool.new()
	local pool = setmetatable({}, InstancePool)
	pool.instances = {}
	return pool
end

function InstancePool:new(mt)
	local instance = self.instances[mt] and table.remove(self.instances[mt])
	return instance or setmetatable({}, mt)
end

function InstancePool:recycle(t)
	local mt = assert(getmetatable(t))

	if not self.instances[mt] then
		self.instances[mt] = {}
	end

	table.insert(self.instances[mt], t)
end

return InstancePool
