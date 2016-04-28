local DrawPhase = {}
DrawPhase.__index = DrawPhase

function DrawPhase.new(args)
	local phase = setmetatable({}, DrawPhase)
	phase:init(args)
	return phase
end

function DrawPhase:init(args)
	self.game = assert(args.game)
	self.name = assert(args.name)
	self.entities = {}

	self.game.drawPhases[self.name] = self
	table.insert(self.game.sortedDrawPhases, self)
end

function DrawPhase:setHandler(entity, handler)
	self.entities[entity] = handler
end

function DrawPhase:draw()
	for entity, handler in pairs(self.entities) do
		handler(entity)
	end
end

return DrawPhase
