local common = require "boxel/common"
local Cell = require "boxel/Cell"
local Contact = require "boxel/Contact"

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
        cell = Cell.new({
            world = self,
            x = x, y = y,
        })
    end

    assert(not cell.bodies[body])

    for body2, _ in pairs(cell.bodies) do
        local contact = body.contacts[body2]

        if not contact then
            contact = Contact.new({
                world = self,
                body1 = body, body2 = body2,
            })
        end

        contact.cellCount = contact.cellCount + 1
    end

    cell.bodies[body] = true
end

function World:removeBodyFromCell(body, x, y)
    local cell = assert(common.get2(self.cells, x, y))
    assert(cell.bodies[body])
    cell.bodies[body] = nil

    for body2, _ in pairs(cell.bodies) do
        local contact = assert(body.contacts[body2])
        assert(contact.cellCount >= 1)
        contact.cellCount = contact.cellCount - 1

        if contact.cellCount == 0 then
            contact:destroy()
        end
    end

    if not next(cell.bodies) then
        cell:destroy()
    end
end

function World:queryPoint(x, y)
    local cellX, cellY = self:getCellIndices(x, y)
end

function World:queryBox(x, y, width, height)
    local x1, y1 = x - 0.5 * width, y - 0.5 * height
    local x2, y2 = x + 0.5 * width, y + 0.5 * height

    local cellX1, cellY1 = self:getCellIndices(x1, y1)
    local cellX2, cellY2 = self:getCellIndices(x2, y2)

    local cellBodies = {}

    for cellX = cellX1, cellX2 do
        for cellY = cellY1, cellY2 do
            local cell = common.get2(self.cells, cellX, cellY)

            if cell then
                for body, _ in pairs(cell.bodies) do
                    cellBodies[body] = true
                end
            end
        end
    end

    local boxBodies = {}

    for body, _ in pairs(cellBodies) do
        if body:intersectsBox(x, y, width, height) then
            boxBodies[body] = true
        end
    end

    return boxBodies
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
        body:updateContacts()
        body.dirty = false
    end

    self.dirtyBodies = {}
end

function World:draw()
    love.graphics.setColor(0x00, 0x00, 0xff, 0xff)

    for x, column in pairs(self.cells) do
        for y, cell in pairs(column) do
            love.graphics.rectangle("line",
                self.cellWidth * (x - 0.5), self.cellHeight * (y - 0.5),
                self.cellWidth, self.cellHeight)
        end
    end

    love.graphics.setColor(0x00, 0xff, 0x00, 0xff)

    for body, _ in pairs(self.bodies) do
        love.graphics.rectangle("line",
            body.x - 0.5 * body.width, body.y - 0.5 * body.height,
            body.width, body.height)
    end

    love.graphics.setColor(0xff, 0x00, 0x00, 0xff)

    for contact, _ in pairs(self.contacts) do
        love.graphics.line(contact.body1.x, contact.body1.y,
            contact.body2.x, contact.body2.y)
    end

    love.graphics.setColor(0xff, 0xff, 0xff, 0xff)
end

return World
