local hexagon = require 'lib.hexagon'
local Terrain = require 'cls.map.terrain'

local SIZE = 24

hexagon.set_size(SIZE)

local Hexagon = {}
Hexagon.__index = Hexagon

function Hexagon.new(i, j, terrain_type)
    local self = {}
    setmetatable(self, Hexagon)

    self.hex = hexagon.new(i, j)
    self.terrain_type = terrain_type

    return self
end

function Hexagon:draw(ox, oy)
    if self.terrain_type == Terrain.PLAIN then
        love.graphics.setColor(0.4, 0.5, 0)
    elseif self.terrain_type == Terrain.GRASS then
        love.graphics.setColor(0, 0.5, 0)
    elseif self.terrain_type == Terrain.FOREST then
        love.graphics.setColor(0, 0.3, 0)
    elseif self.terrain_type == Terrain.RIVER then
        love.graphics.setColor(0, 0, 0.5)
    elseif self.terrain_type == Terrain.BRIDGE then
        love.graphics.setColor(0.4, 0.2, 0)
    elseif self.terrain_type == Terrain.FORT then
        love.graphics.setColor(0.2, 0.2, 0.2)
    elseif self.terrain_type == Terrain.PEAK then
        love.graphics.setColor(0.5, 0.4, 0.2)
    else
        love.graphics.setColor(0, 0, 0, 0)
    end
    local x, y = unpack(hexagon.center_pixel(self.hex:coords()))
    love.graphics.circle("fill", ox + x, oy + y, SIZE - 2)
end

return Hexagon