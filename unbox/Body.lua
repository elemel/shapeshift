local common = require "unbox/common"
local Contact = require "unbox/Contact"

local Body = {}
Body.__index = Body

function Body.new(args)
    local body = setmetatable({}, Body)
    body:init(args or {})
    return body
end

function Body:init(args)
    self.dynamic = false
    self.x, self.y = args.x or 0, args.y or 0
    self.width, self.height = args.width or 1, args.height or 1
    self.velocityX, self.velocityY = args.velocityX or 0, args.velocityY or 0
    self.gravityX, self.gravityY = args.gravityX or 0, args.gravityY or 0

    self.contacts = {}

    self.world = assert(args.world)
    self.world.bodies[self] = true

    self:updateBounds()
    self:initCellBounds()
    self:addToCells()

    self:setDynamic(args.dynamic or false)
    self:setDirty(true)
end

function Body:destroy()
    self:removeFromCells()

    self:setDynamic(false)
    self:setDirty(false)

    self.world.bodies[self] = nil
    self.world = nil
end

function Body:isDynamic()
    return self.dynamic
end

function Body:setDynamic(dynamic)
    if dynamic ~= self.dynamic then
        if self.dynamic then
            self.world.dynamicBodies[self] = nil
        end

        self.dynamic = dynamic

        if self.dynamic then
            self.world.dynamicBodies[self] = true
        end
    end
end

function Body:isDirty()
    return self.dirty
end

function Body:setDirty(dirty)
    if dirty ~= self.dirty then
        if self.dirty then
            self.world.dirtyBodies[self] = nil
        end

        self.dirty = dirty

        if self.dirty then
            self.world.dirtyBodies[self] = true
        end
    end
end

function Body:getPosition()
    return self.x, self.y
end

function Body:setPosition(x, y)
    self.x, self.y = x, y
    self:updateBounds()
    self:setDirty(true)
end

function Body:getDimensions()
    return self.width, self.height
end

function Body:setDimensions(width, height)
    self.width, self.height = width, height
    self:updateBounds()
    self:setDirty(true)
end

function Body:getVelocity()
    return self.velocityX, self.velocityY
end

function Body:setVelocity(velocityX, velocityY)
    self.velocityX, self.velocityY = velocityX, velocityY
end

function Body:getContacts()
    return self.contacts
end

function Body:update(dt)
    local gravityX = self.gravityX + self.world.gravityX
    local gravityY = self.gravityY + self.world.gravityY

    self.x = self.x + self.velocityX * dt + 0.5 * gravityX * dt * dt
    self.y = self.y + self.velocityY * dt + 0.5 * gravityY * dt * dt

    self.velocityX = self.velocityX + gravityX * dt
    self.velocityY = self.velocityY + gravityY * dt

    self:updateBounds()
    self:setDirty(true)
end

function Body:updateBounds()
    self.x1, self.y1 = self.x - 0.5 * self.width, self.y - 0.5 * self.height
    self.x2, self.y2 = self.x + 0.5 * self.width, self.y + 0.5 * self.height
end

function Body:initCellBounds()
    self.cellX1, self.cellY1 = self.world:getCellIndices(self.x1, self.y1)
    self.cellX2, self.cellY2 = self.world:getCellIndices(self.x2, self.y2)
end

function Body:updateCellBounds()
    local cellX1, cellY1 = self.world:getCellIndices(self.x1, self.y1)
    local cellX2, cellY2 = self.world:getCellIndices(self.x2, self.y2)

    self.cellX1 = common.clamp(self.cellX1, cellX1 - 1, cellX1)
    self.cellY1 = common.clamp(self.cellY1, cellY1 - 1, cellY1)

    self.cellX2 = common.clamp(self.cellX2, cellX2, cellX2 + 1)
    self.cellY2 = common.clamp(self.cellY2, cellY2, cellY2 + 1)
end

function Body:addToCells()
    for cellX = self.cellX1, self.cellX2 do
        for cellY = self.cellY1, self.cellY2 do
            self.world:addBodyToCell(self, cellX, cellY)
        end
    end
end

function Body:removeFromCells()
    for cellX = self.cellX1, self.cellX2 do
        for cellY = self.cellY1, self.cellY2 do
            self.world:removeBodyFromCell(self, cellX, cellY)
        end
    end
end

function Body:updateContacts()
    local cellX1, cellY1 = self.cellX1, self.cellY1
    local cellX2, cellY2 = self.cellX2, self.cellY2

    self:updateCellBounds()

    if self.cellX1 ~= cellX1 or self.cellY1 ~= cellY1 or
            self.cellX2 ~= cellX2 or self.cellY2 ~= cellY2 then
        -- Remove body from old cells
        for cellX = cellX1, cellX2 do
            for cellY = cellY1, cellY2 do
                if not (self.cellX1 <= cellX and cellX <= self.cellX2 and
                        self.cellY1 <= cellY and cellY <= self.cellY2) then
                    self.world:removeBodyFromCell(self, cellX, cellY)
                end
            end
        end

        -- Add body to new cells
        for cellX = self.cellX1, self.cellX2 do
            for cellY = self.cellY1, self.cellY2 do
                if not (cellX1 <= cellX and cellX <= cellX2 and
                        cellY1 <= cellY and cellY <= cellY2) then
                    self.world:addBodyToCell(self, cellX, cellY)
                end
            end
        end
    end
end

function Body:intersects(body)
    return self:intersectsBounds(body.x1, body.y1, body.x2, body.y2)
end

function Body:intersectsBounds(x1, y1, x2, y2)
    return x1 < self.x2 and self.x1 < x2 and y1 < self.y2 and self.y1 < y2
end

function Body:intersectsBox(x, y, width, height)
    return self:intersectsBounds(x - 0.5 * width, y - 0.5 * height,
        x + 0.5 * width, y + 0.5 * height)
end

function Body:resolve(body)
    if self:intersects(body) then
        local distanceX1, distanceX2 = self.x2 - body.x1, body.x2 - self.x1
        local distanceY1, distanceY2 = self.y2 - body.y1, body.y2 - self.y1

        if math.min(distanceX1, distanceX2) <
                math.min(distanceY1, distanceY2) then
            if distanceX1 < distanceX2 then
                self.x = self.x - distanceX1
                self.velocityX = math.min(self.velocityX, body.velocityX)
            else
                self.x = self.x + distanceX2
                self.velocityX = math.max(self.velocityX, body.velocityX)
            end
        else
            if distanceY1 < distanceY2 then
                self.y = self.y - distanceY1
                self.velocityY = math.min(self.velocityY, body.velocityY)
            else
                self.y = self.y + distanceY2
                self.velocityY = math.max(self.velocityY, body.velocityY)
            end
        end

        self:updateBounds()
        self:setDirty(true)
    end
end

function Body:getDistance(body)
    local distance, normalX, normalY, x1, y1, x2, y2

    if self.x2 < body.x1 then
        if self.y2 < body.y1 then
            return self.x2, self.y2, body.x1, body.y1
        elseif self.y1 < body.y2 then
            local y = 0.5 * (math.max(self.y1, body.y1) + math.min(self.y2, body.y2))
            return self.x2, y, body.x1, y
        else
            return self.x2, self.y1, body.x1, body.y2
        end
    elseif self.x1 < body.x2 then
        if self.y2 < body.y1 then
        elseif self.y1 < body.y2 then
        else
        end
    else
        if self.y2 < body.y1 then
            return self.x1, self.y2, body.x2, body.y1
        elseif self.y1 < body.y2 then
            local y = 0.5 * (math.max(self.y1, body.y1) + math.min(self.y2, body.y2))
            return self.x1, y, body.x2, y
        else
            return self.x1, self.y1, body.x2, body.y2
        end
    end

    return distance, normalX, normalY, x1, y1, x2, y2
end

return Body
