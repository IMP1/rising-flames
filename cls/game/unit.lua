local resource_manager = require 'resource_manager'

local hexagon = require 'lib.hexagon'

local Unit = {}
Unit.__index = Unit

function Unit.new(x, y, actor, health)
    local self = {}
    setmetatable(self, Unit)

    self.position = {x, y}
    self.actor    = actor
    self.health   = health or self.actor.max_health

    return self
end

function Unit:is_at(x, y)
    return x == self.position[1] and y == self.position[2]
end

function Unit:draw_sprite(ox, oy, faction)
    local i, j = unpack(self.position)
    local x, y = unpack(hexagon.center_pixel(i, j))
    if faction == "player" then
        love.graphics.setColor(1, 1, 1)
    elseif faction == "enemy" then
        love.graphics.setColor(0.8, 0, 0)
    elseif faction == "neutral" then
        love.graphics.setColor(0.2, 0.8, 0.2)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.circle("fill", x + ox, y + oy, 4)
end

function Unit:draw_face(x, y)
    local img = resource_manager.face(self.actor.data_name)
    love.graphics.draw(img, x - img:getWidth() / 2, y - img:getHeight())
    -- body
end

return Unit