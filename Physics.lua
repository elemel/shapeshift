local unbox = require "unbox"

local Physics = {}
Physics.__index = Physics

function Physics.new(args)
	local physics = setmetatable({}, Physics)
	physics:init(args)
	return physics
end

function Physics:init(args)
	self.game = args.game
	self.world = unbox.newWorld({
		cellWidth = args.cellWidth, cellHeight = args.cellHeight,
		gravityX = args.gravityX, gravityY = args.gravityY,
	})

	self.game.entities[self] = true
	self.game:setUpdateHandler("physics", self, Physics.updatePhysics)
	self.game:setDrawHandler("debug", self, Physics.drawDebug)
end

function Physics:destroy()
	self.game:setDrawHandler("debug", self, nil)
	self.game:setUpdateHandler("physics", self, nil)
	self.game.entities[self] = nil
end

function Physics:update(dt)
end

function Physics:updatePhysics(dt)
	self.world:update(dt)
end

function Physics:drawDebug()
	self.world:draw()
end

return Physics
