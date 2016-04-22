local Game = {}
Game.__index = Game

function Game.new(args)
	local game = setmetatable({}, Game)
	game:init(args)
	return game
end

function Game:init(args)
	self.camera = args.camera
	self.entities = {}
end

function Game:update(dt)
	for entity, _ in pairs(self.entities) do
		entity:update(dt)
	end
end

function Game:draw()
	self.camera:draw()

	for entity, _ in pairs(self.entities) do
		entity:draw()
	end
end

return Game
