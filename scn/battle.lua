local hexagon = require 'lib.hexagon'

local Map  = require 'cls.map.map'
local Terrain  = require 'cls.map.terrain'
local Unit = require 'cls.game.unit'

local data = require 'data_manager'
local base_scene = require 'scn.base'
local scene_manager = require 'scn.scene_manager'

local battle = {}
setmetatable(battle, base_scene)
battle.__index = battle

local MAP_OFFSET_X = love.graphics.getWidth() / 2
local MAP_OFFSET_Y = love.graphics.getHeight() / 2

function battle.new(battle_filename)
    local self = {}
    setmetatable(self, battle)

    self.filename      = battle_filename
    self.player_units  = {}
    self.enemy_units   = {}
    self.neutral_units = {}
    self.level_name    = ""
    self.map           = nil
    self.has_finished  = false

    return self
end

function battle:load()
    local battle_data = love.filesystem.load("dat/levels/" .. self.filename .. ".lua")()
    self.map = Map.new(battle_data.map)
    for _, unit in pairs(battle_data.starting_player_units) do
        local actor = data.actor(unit.name)
        local x, y = unpack(unit.position)
        local unit = Unit.new(x, y, actor)
        table.insert(self.player_units, unit)
    end
end

function battle:mouse_coords(mx, my)
    return (mx or love.mouse.getX()) - MAP_OFFSET_X, 
           (my or love.mouse.getY()) - MAP_OFFSET_Y
end

function battle:update(dt)
    if self.has_finished then
        scene_manager.popScene()
    end
end

function battle:draw()
    self:draw_map()
    self:draw_gui()
end

function battle:draw_map()
    self.map:draw(MAP_OFFSET_X, MAP_OFFSET_Y)
    for _, unit in pairs(self.player_units) do
        unit:draw_sprite(MAP_OFFSET_X, MAP_OFFSET_Y)
    end
end

local function unit_at(self, i, j) 
    for _, unit in pairs(self.player_units) do
        if unit:is_at(i, j) then
            return unit
        end
    end
    for _, unit in pairs(self.enemy_units) do
        if unit:is_at(i, j) then
            return unit
        end
    end
    for _, unit in pairs(self.neutral_units) do
        if unit:is_at(i, j) then
            return unit
        end
    end
    return nil
end

local function draw_bar(x, y, w, h, value, max, empty_colour, full_colour)
    local fullness = w * value / max
    love.graphics.setColor(empty_colour)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(full_colour)
    love.graphics.rectangle("fill", x + 1, y + 1, fullness - 2, h - 2)
    love.graphics.setColor(1, 1, 1)
    local msg = tostring(value)
    if value ~= max then
        msg = msg .. " / " .. max
    end
    love.graphics.print(msg, x + fullness, y)
end

function battle:draw_gui()
    local mx, my = self:mouse_coords()
    local i, j = hexagon.get_axial(mx, my)
    love.graphics.print(i .. ", " .. j, 0, 0)

    local t = self.map:tile_at(i, j)
    if t and t.terrain_type ~= Terrain.BLANK then
        love.graphics.print(t.terrain_type.name, 0, 16)

        local w = 96
        local h = 96
        local x = 8
        local y = love.graphics.getHeight() - h - 8 

        love.graphics.rectangle("line", x, y, w, h)
        love.graphics.printf(t.terrain_type.name, x, y + 4, w, "center")
        love.graphics.print("Def", x + 4, y + 16)
        love.graphics.print(t.terrain_type.defence, x + 8, y + 32)
        love.graphics.print("Avo", x + 32 + 4, y + 16)
        love.graphics.print(t.terrain_type.avoid, x + 32 + 8, y + 32)
        love.graphics.print("Hea", x + 64 + 4, y + 16)
        love.graphics.print(t.terrain_type.heal, x + 64 + 8, y + 32)
    end

    local u = unit_at(self, i, j)
    if u then
        local w = 256
        local h = 96
        local x = love.graphics.getWidth() - w - 8
        local y = love.graphics.getHeight() - h - 8
        love.graphics.rectangle("line", x, y, w, h)
        u:draw_face(x + w - 64, y + 96)
        love.graphics.printf(u.actor.name, x, y + 4, w, "center")
        draw_bar(x+8, y+h-24, 108, 16, u.health, u.actor.max_health, {0.25, 0, 0}, {0.75, 0, 0})
    end
end

return battle
