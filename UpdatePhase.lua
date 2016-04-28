local UpdatePhase = {}
UpdatePhase.__index = UpdatePhase

function UpdatePhase.new(args)
	local phase = setmetatable({}, UpdatePhase)
	phase:init(args)
	return phase
end

function UpdatePhase:init(args)
	self.game = assert(args.game)
	self.name = assert(args.name)
	self.entities = {}

	self.game.updatePhases[self.name] = self
	table.insert(self.game.sortedUpdatePhases, self)
end

function UpdatePhase:setHandler(entity, handler)
	self.entities[entity] = handler
end

function UpdatePhase:update(dt)
	for entity, handler in pairs(self.entities) do
		handler(entity, dt)
	end
end

return UpdatePhase
