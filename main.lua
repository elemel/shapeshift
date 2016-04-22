local Body = require "aliax/Body"
local Block = require "Block"
local Camera = require "Camera"
local Game = require "Game"
local GameScreen = require "GameScreen"
local Physics = require "Physics"
local Terrain = require "Terrain"

function love.load()
	local camera = Camera.new({
		scale = 1 / 16,
	})

	local game = Game.new({camera = camera})

	local physics = Physics.new({
		game = game,
		gravityX = 0, gravityY = 16,
	})

	Body.new({
		world = physics.world,
		dynamic = true,
		velocityX = 4, velocityY = -12,
	})

	local terrain = Terrain.new({
		game = game,
		width = 256,
	})

	-- Block.new({
	-- 	terrain = terrain,
	-- 	x = 1, y = 1,
	-- 	width = 1, height = 1,
	-- })

	screen = GameScreen.new({game = game})
end

function love.update(dt)
	screen:update(dt)
end

function love.draw()
	screen:draw()
end
