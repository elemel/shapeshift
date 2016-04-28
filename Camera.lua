local Camera = {}
Camera.__index = Camera

function Camera.new(args)
	local camera = setmetatable({}, Camera)
	camera:init(args)
	return camera
end

function Camera:init(args)
	self.game = assert(args.game)
	self.x, self.y = args.x or 0, args.y or 0
	self.scale = args.scale or 1

	self.game:setDrawHandler("camera", self, Camera.drawCamera)
end

function Camera:destroy()
	self.game:setDrawHandler("camera", self, nil)
end

function Camera:drawCamera()
	local width, height = love.graphics.getDimensions()
	local scale = self.scale * height

	love.graphics.translate(0.5 * width, 0.5 * height)
	love.graphics.scale(scale)
	love.graphics.translate(-self.x, -self.y)

	love.graphics.setLineWidth(1 / scale)
end

return Camera
