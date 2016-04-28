local Body = require "boxel/Body"
local Block = require "Block"
local Camera = require "Camera"
local Character = require "Character"
local DrawPhase = require "DrawPhase"
local Game = require "Game"
local GameScreen = require "GameScreen"
local Physics = require "Physics"
local Terrain = require "Terrain"
local UpdatePhase = require "UpdatePhase"
local Wall = require "Wall"

function love.load()
	local game = Game.new()

	UpdatePhase.new({
		game = game,
		name = "physics",
	})

	UpdatePhase.new({
		game = game,
		name = "constraint",
	})

	DrawPhase.new({
		game = game,
		name = "camera",
	})

	DrawPhase.new({
		game = game,
		name = "debug",
	})

	Camera.new({
		game = game,
		scale = 1 / 32,
	})

	local physics = Physics.new({
		game = game,
		cellWidth = 2, cellHeight = 2,
		gravityX = 0, gravityY = 16,
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

	local wall = Wall.new({
		game = game,
		physics = physics,
		width = 16, height = 1,
	})

	local character = Character.new({
		game = game,
		physics = physics,
		x = 0, y = -1,
		width = 1, height = 2,
		velocityX = 2, velocityY = -16,
	})

	screen = GameScreen.new({game = game})
end

function love.update(dt)
	screen:update(dt)
end

function love.draw()
	screen:draw()
end
