local common = require "aliax/common"

local Grid = {}
Grid.__index = Grid

function Grid.new(args)
	local grid = setmetatable({}, grid)
	grid:init(args)
	return grid
end

function Grid:init(args)
	self.cellWidth, self.cellHeight = args.cellWidth or 1, args.cellHeight or 1
	self.cells = {}
end

function Grid:destroy()
end



return Grid
