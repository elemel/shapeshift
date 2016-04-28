local Body = require "boxel/Body"

local Character = {}
Character.__index = Character

function Character.new(args)
	local character = setmetatable({}, Character)
	character:init(args or {})
	return character
end

function Character:init(args)
	self.game = assert(args.game)
	self.physics = assert(args.physics)

	self.body = Body.new({
		world = self.physics.world,
		dynamic = true,
		x = args.x, y = args.y,
		width = args.width, height = args.height,
		velocityX = args.velocityX, velocityY = args.velocityY,
	})

	self.game:setUpdateHandler("constraint", self, Character.updateConstraint)
	self.game.entities[self] = true
end

function Character:destroy()
	self.game.entities[self] = nil
	self.game:setUpdateHandler("constraint", self, nil)

	self.body:destroy()
end

function Character:updateConstraint(dt)
	for body, contact in pairs(self.body:getContacts()) do
		self.body:resolve(body)
	end
end

function Character:draw()
end

return Character
