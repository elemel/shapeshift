local Body = {}
Body.__index = Body

function Body.new(args)
    local body = setmetatable({}, Body)
    body:init(args or {})
    return body
end

function Body:init(args)
    self.dynamic = args.dynamic or false
    self.x, self.y = args.x or 0, args.y or 0
    self.width, self.height = args.width or 1, args.height or 1
    self.velocityX, self.velocityY = args.velocityX or 0, args.velocityY or 0
    self.gravityX, self.gravityY = args.gravityX or 0, args.gravityY or 0
    self.color = args.color or {0xff, 0xff, 0xff, 0xff}

    self.cellX1, cellY1 = 0, 0
    self.cellX2, cellY2 = -1, -1

    self.contacts = {}

    self.world = args.world
    self.world.bodies[self] = true

    if self.dynamic then
        self.world.dynamicBodies[self] = true
    end
end

function Body:destroy()
    self:setDynamic(false)
    self.world.bodies[self] = nil
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
    self:setDirty(true)
end

function Body:getDimensions()
    return self.width, self.height
end

function Body:setDimensions(width, height)
    self.width, self.height = width, height
    self:setDirty(true)
end

function Body:getVelocity()
    return self.velocityX, self.velocityY
end

function Body:setVelocity(velocityX, velocityY)
    self.velocityX, self.velocityY = velocityX, velocityY
end

function Body:update(dt)
    local gravityX = self.gravityX + self.world.gravityX
    local gravityY = self.gravityY + self.world.gravityY

    self.x = self.x + self.velocityX * dt + 0.5 * gravityX * dt * dt
    self.y = self.y + self.velocityY * dt + 0.5 * gravityY * dt * dt

    self.velocityX = self.velocityX + gravityX * dt
    self.velocityY = self.velocityY + gravityY * dt

    self:setDirty(true)
end

function Body:updateCells()
    local x1, y1 = self.x - 0.5 * self.width, self.y - 0.5 * self.height
    local x2, y2 = self.x + 0.5 * self.width, self.y + 0.5 * self.height

    local cellX1, cellY1 = self.world:getCellIndices(x1, y1)
    local cellX2, cellY2 = self.world:getCellIndices(x2, y2)

    if cellX1 ~= self.cellX1 or cellY1 ~= self.cellY1 or
            cellX2 ~= self.cellX2 or cellY2 ~= self.cellY2 then
        -- Remove body from old cells
        for cellX = self.cellX1, self.cellX2 do
            for cellY = self.cellY1, self.cellY2 do
                if not (cellX1 <= cellX and cellX <= cellX2 and
                        cellY1 <= cellY and cellY <= cellY2) then
                    self.world:removeBodyFromCell(self, cellX, cellY)
                end
            end
        end

        -- Add body to new cells
        for cellX = cellX1, cellX2 do
            for cellY = cellY1, cellY2 do
                if not (self.cellX1 <= cellX and cellX <= self.cellX2 and
                        self.cellY1 <= cellY and cellY <= self.cellY2) then
                    self.world:addBodyToCell(self, cellX, cellY)
                end
            end
        end

        self.cellX1, self.cellY1 = cellX1, cellY1
        self.cellX2, self.cellY2 = cellX2, cellY2
    end
end

function Body:updateContacts()
end

return Body
