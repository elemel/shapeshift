local common = require "common"

local Block = {}
Block.__index = Block

function Block.new(args)
	local block = setmetatable({}, Block)
	block:init(args)
	return block
end

function Block:init(args)
	self.x, self.y = args.x, args.y
	self.width, self.height = args.width, args.height

	self.terrain = args.terrain
	self.terrain.blocks[self] = true

	self.x1 = common.round(self.x - 0.5 * self.width)
	self.x2 = common.round(self.x + 0.5 * self.width)

	for x = self.x1, self.x2 do
		local column = self.terrain.columns[x]

		if column then
			column[self] = true
		end
	end
end

function Block:destroy()
	for x = self.x1, self.x2 do
		local column = self.terrain.columns[x]

		if column then
			column[self] = nil
		end
	end

	self.terrain.blocks[self] = nil
end

function Block:update(dt)
end

function Block:draw()
	love.graphics.rectangle("fill",
		self.x - 0.5 * self.width, self.y - 0.5 * self.height,
		self.width, self. height)
end

return Block
