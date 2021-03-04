local hexagon = require 'lib.hexagon'
local tween = require 'lib.tween'

local Map  = require 'cls.map.map'
local Terrain  = require 'cls.map.terrain'
local Unit = require 'cls.game.unit'

local data = require 'data_manager'
local base_scene = require 'scn.base'
local scene_manager = require 'scn.scene_manager'

local battle = {}
setmetatable(battle, base_scene)
battle.__index = battle

local TURN_CYCLE = {"player", "neutral", "enemy"}

local MAP_OFFSET_X = love.graphics.getWidth() / 2
local MAP_OFFSET_Y = love.graphics.getHeight() / 2

function battle.new(battle_filename)
    local self = {}
    setmetatable(self, battle)

    self.filename       = battle_filename
    self.player_units   = {}
    self.enemy_units    = {}
    self.neutral_units  = {}
    self.level_name     = ""
    self.map            = nil
    self.has_finished   = false
    self.has_started    = false
    self.turn_number    = 0
    self.turn_faction   = nil
    self.trigger_action = nil
    self.map_animations = {}
    self.gui_animations = {}

    return self
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

local function mouse_coords(mx, my)
    return (mx or love.mouse.getX()) - MAP_OFFSET_X, 
           (my or love.mouse.getY()) - MAP_OFFSET_Y
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
    for _, unit in pairs(battle_data.starting_enemy_units) do
        local enemy = data.enemy(unit.name)
        local x, y = unpack(unit.position)
        local unit = Unit.new(x, y, enemy)
        table.insert(self.enemy_units, unit)
    end
    for _, unit in pairs(battle_data.starting_neutral_units) do
    end
    self.turn = 0
    self.has_finished = false
    self.has_started = true

    -- TODO: Check for pre-battle triggers

    self:switch_turn(battle_data.first_turn or TURN_CYCLE[1])
end

function battle:switch_turn(faction)
    self.turn_faction = faction
    self.turn_number = self.turn_number + 1
    local animation = {}
    animation.y = 48
    animation.opacity = 2
    animation.text = self.turn_faction:sub(1,1):upper() .. self.turn_faction:sub(2) .. " Turn " .. self.turn_number
    animation.draw = function(self)
        local a = self.opacity
        local ox = love.graphics.getWidth() / 2
        local w = love.graphics.getFont():getWidth(self.text) + 32
        love.graphics.setColor(1, 1, 1, a)
        love.graphics.rectangle("fill", ox - w/2, self.y, w, 32)
        love.graphics.setColor(0, 0, 0, self.opacity)
        love.graphics.rectangle("line", ox - w/2, self.y, w, 32)
        love.graphics.printf(self.text, 0, self.y + 8, love.graphics.getWidth(), "center")
    end
    table.insert(self.gui_animations, animation)
    tween.new(1, animation, {opacity = 0}, tween.quadOut)
end

function battle:update(dt)
    if self.has_finished then
        scene_manager.popScene()
        return
    end
    tween.update(dt)
    -- TODO: Check for trigger action
    if self.turn_faction == "player" then
        -- Not much to do except play animations related to player input.
    elseif self.turn_faction == "neutral" then

    elseif self.turn_faction == "enemy" then

    else
        -- Whose turn is it then?
    end
end

function battle:draw()
    love.graphics.setColor(1, 1, 1)
    local x = love.graphics.getWidth() / 2
    local y = love.graphics.getHeight() / 2
    love.graphics.line(x, 0, x, 2 * y)
    love.graphics.line(0, y, 2 * x, y)
    self:draw_map()
    self:draw_gui()
end

function battle:draw_map()
    love.graphics.setColor(1, 1, 1)
    self.map:draw(MAP_OFFSET_X, MAP_OFFSET_Y)
    for _, unit in pairs(self.player_units) do
        unit:draw_sprite(MAP_OFFSET_X, MAP_OFFSET_Y, "player")
    end
    for _, unit in pairs(self.enemy_units) do
        unit:draw_sprite(MAP_OFFSET_X, MAP_OFFSET_Y, "enemy")
    end
    for _, unit in pairs(self.neutral_units) do
        unit:draw_sprite(MAP_OFFSET_X, MAP_OFFSET_Y, "neutral")
    end
    love.graphics.setColor(1, 1, 1)
    for _, animation in pairs(self.map_animations) do
        animation:draw()
    end
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
    local mx, my = mouse_coords()
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
    for _, animation in pairs(self.gui_animations) do
        animation:draw()
    end
end

return battle
