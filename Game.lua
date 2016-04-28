local Game = {}
Game.__index = Game

function Game.new(args)
	local game = setmetatable({}, Game)
	game:init(args or {})
	return game
end

function Game:init(args)
	self.updatePhases = {}
	self.sortedUpdatePhases = {}

	self.drawPhases = {}
	self.sortedDrawPhases = {}

	self.entities = {}
end

function Game:setUpdateHandler(phase, entity, handler)
	self.updatePhases[phase]:setHandler(entity, handler)
end

function Game:setDrawHandler(phase, entity, handler)
	self.drawPhases[phase]:setHandler(entity, handler)
end

function Game:update(dt)
	for i, phase in ipairs(self.sortedUpdatePhases) do
		phase:update(dt)
	end
end

function Game:draw()
	for i, phase in ipairs(self.sortedDrawPhases) do
		phase:draw(dt)
	end
end

return Game
