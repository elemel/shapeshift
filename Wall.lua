local Body = require "boxel/Body"

local Wall = {}
Wall.__index = Wall

function Wall.new(args)
	local wall = setmetatable({}, Wall)
	wall:init(args or {})
	return wall
end

function Wall:init(args)
	self.game = assert(args.game)
	self.physics = assert(args.physics)
	self.game.entities[self] = true

	self.body = Body.new({
		world = self.physics.world,
		x = args.x, y = args.y,
		width = args.width, height = args.height,
	})
end

function Wall:destroy()
	self.body:destroy()
	self.game.entities[self] = nil
end

function Wall:update(dt)
end

function Wall:draw()
end

return Wall
