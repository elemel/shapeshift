local common = require "aliax/common"
local Cell = require "aliax/Cell"
local Contact = require "aliax/Contact"

local World = {}
World.__index = World

function World.new(args)
    local world = setmetatable({}, World)
    world:init(args or {})
    return world
end

function World:init(args)
    self.gravityX, self.gravityY = args.gravityX or 0, args.gravityY or 0
    self.cellWidth, self.cellHeight = args.cellWidth or 1, args.cellHeight or 1

    self.bodies = {}
    self.dynamicBodies = {}
    self.dirtyBodies = {}

    self.cells = {}
    self.contacts = {}
end

function World:destroy()
end

function World:getCellIndices(x, y)
    return common.round2(x / self.cellWidth, y / self.cellHeight)
end

function World:addBodyToCell(body, x, y)
    local cell = common.get2(self.cells, x, y)

    if not cell then
        cell = Cell.new({x = x, y = y})
        common.set2(self.cells, x, y, cell)
    end

    cell.bodies[cell] = true
end

function World:removeBodyFromCell(body, x, y)
    local cell = common.get2(self.cells, x, y)

    if cell then
        cell.bodies[cell] = nil

        if not next(cell.bodies) then
            common.set2(self.cells, x, y, nil)
        end
    end

    cell.bodies[cell] = true
end

function World:queryPoint(x, y)
    local cellX, cellY = self:getCellIndices(x, y)
end

function World:queryBox(x, y, width, height)
    local x1, y1 = x - 0.5 * width, y - 0.5 * height
    local x2, y2 = x + 0.5 * width, y + 0.5 * height

    local cellX1, cellY1 = self:getCellIndices(x1, y1)
    local cellX2, cellY2 = self:getCellIndices(x2, y2)

    local bodies = {}

    for cellX = cellX1, cellX2 do
        for cellY = cellY1, cellY2 do
            local cell = common.get2(self.cells, x, y)

            if cell then
                for body, _ in pairs(cell) do
                    bodies[body] = true
                end
            end
        end
    end

    return bodies
end

function World:update(dt)
    self:updateDynamicBodies(dt)
    self:updateContacts()
end

function World:updateDynamicBodies(dt)
    for body, _ in pairs(self.dynamicBodies) do
        body:update(dt)
    end
end

function World:updateContacts()
    for body, _ in pairs(self.dirtyBodies) do
        body:updateCells()
    end

    for body, _ in pairs(self.dirtyBodies) do
        body:updateContacts()
    end

    for body, _ in pairs(self.dirtyBodies) do
        body.dirty = false
    end

    self.dirtyBodies = {}
end

function World:draw()
    for x, column in pairs(self.cells) do
        for y, cell in pairs(column) do
            love.graphics.rectangle("line",
                self.cellWidth * (x - 0.5), self.cellHeight * (y - 0.5),
                self.cellWidth, self.cellHeight)
        end
    end

    for body, _ in pairs(self.bodies) do
        love.graphics.setColor(body.color)
        love.graphics.rectangle("fill",
            body.x - 0.5 * body.width, body.y - 0.5 * body.height,
            body.width, body.height)
    end

    love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
end

return World
