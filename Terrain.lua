local Terrain = {}
Terrain.__index = Terrain

function Terrain.new(args)
	local terrain = setmetatable({}, Terrain)
	terrain:init(args)
	return terrain
end

function Terrain:init(args)
	self.game = args.game
	self.blocks = {}
	self.columns = {}

	for x = 1, args.width do
		self.columns[x] = {}
	end

	self.game.entities[self] = true
end

function Terrain:destroy()
	self.game.entities[self] = nil
end

function Terrain:update(dt)
end

function Terrain:draw()
	for block, _ in pairs(self.blocks) do
		block:draw()
	end
end

return Terrain
