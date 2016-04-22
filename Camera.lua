local Camera = {}
Camera.__index = Camera

function Camera.new(args)
	local camera = setmetatable({}, Camera)
	camera:init(args)
	return camera
end

function Camera:init(args)
	self.x, self.y = args.x or 0, args.y or 0
	self.scale = args.scale or 1
end

function Camera:draw()
	local width, height = love.graphics.getDimensions()

	love.graphics.translate(0.5 * width, 0.5 * height)
	love.graphics.scale(self.scale * height)
	love.graphics.translate(-self.x, -self.y)

	love.graphics.setLineWidth(1 / (self.scale * height))
end

return Camera
