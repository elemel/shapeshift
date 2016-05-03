local common = require "unbox/common"

local Cell = {}
Cell.__index = Cell

function Cell.new(args)
    local cell = setmetatable({}, Cell)
    cell:init(args)
    return cell
end

function Cell:init(args)
    self.world = assert(args.world)
    self.x, self.y = assert(args.x), assert(args.y)

    self.bodies = {}

    common.set2(self.world.cells, self.x, self.y, self)
end

function Cell:destroy()
    common.set2(self.world.cells, self.x, self.y, nil)
end

return Cell
