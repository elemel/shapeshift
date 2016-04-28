local InstancePool = {}
InstancePool.__index = InstancePool

function InstancePool.new()
	local pool = setmetatable({}, InstancePool)
	pool.instances = {}
	return pool
end

function InstancePool:remove(mt)
	if not self.instances[mt] then
		self.instances[mt] = {}
	end

	local instance = table.remove(self.instances[mt])

	if not instance then
		instance = setmetatable({}, mt)
	end

	return instance
end

function InstancePool:add(t)
	if not self.instances[mt] then
		self.instances[mt] = {}
	end

	table.insert(self.instances[mt], t)
end

return InstancePool
