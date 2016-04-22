local GameScreen = {}
GameScreen.__index = GameScreen

function GameScreen.new(args)
	local screen = setmetatable({}, GameScreen)
	screen:init(args)
	return screen
end

function GameScreen:init(args)
	self.game = args.game
end

function GameScreen:update(dt)
	self.game:update(dt)
end

function GameScreen:draw()
	self.game:draw()
end

return GameScreen
