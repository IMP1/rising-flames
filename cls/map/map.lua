local Hexagon = require 'cls.map.hexagon'

local Map = {}
Map.__index = Map

function Map.new(map_name)
    local self = {}
    setmetatable(self, Map)

    if map_name then
        return Map.load(self, map_name)
    else
        return Map.randomise(self)
    end
end

function Map.randomise(self)
    self.width  = 8
    self.height = 8
    self.title  = "Randomised Map"
    self.tiles  = {}
    return self
end

function Map.load(self, map_name)
    local map_data = love.filesystem.load('dat/maps/' .. map_name .. ".lua")()
    self.width = map_data.width
    self.height = map_data.height
    self.tiles = {}
    for j, row in pairs(map_data.tiles) do
        self.tiles[j] = {}
        for i, tile in pairs(row) do
            local x = (i-1) - math.floor(self.width / 2)
            local y = j - math.floor(self.height / 2) - math.min(j, 0)
            self.tiles[j][i] = Hexagon.new(x, y, tile)
        end
    end
    return self
end

function Map:tile_at(x, y)
    local i = x + math.floor(self.width / 2) + 1
    local j = (y-1) + math.floor(self.height / 2) + 1
    if self.tiles[j] then
        return self.tiles[j][i]
    end
end

function Map:draw(ox, oy)
    for _, row in pairs(self.tiles) do
        for _, tile in pairs(row) do
            tile:draw(ox, oy)
        end
    end
end

return Map