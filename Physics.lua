local World = require "aliax/World"

local Physics = {}
Physics.__index = Physics

function Physics.new(args)
	local physics = setmetatable({}, Physics)
	physics:init(args)
	return physics
end

function Physics:init(args)
	self.game = args.game
	self.world = World.new({
		gravityX = args.gravityX, gravityY = args.gravityY,
	})

	self.game.entities[self] = true
end

function Physics:destroy()
	self.game.entities[self] = nil
end

function Physics:update(dt)
	self.world:update(dt)
end

function Physics:draw()
	self.world:draw()
end

return Physics
