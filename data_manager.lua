local Actor = require 'cls.game.actor'

local data_manager = {}

local actors = {}
local enemy_classes = {}

local function new_actor(actor_name)
    local actor_data = love.filesystem.load("dat/actors/" .. actor_name .. ".lua")()
    return Actor.new(actor_name, actor_data)
end

function data_manager.actor(actor_name)
    -- Cached
    if actors[actor_name] then
        return actors[actor_name]
    end
    -- TODO: check save file
    -- Load
    if love.filesystem.getInfo("dat/actors/" .. actor_name .. ".lua") then
        actors[actor_name] = new_actor(actor_name)
        return actors[actor_name]
    end
end

function data_manager.enemy(class_name)
    local path = "dat/enemies/" .. class_name .. ".lua"
    if not enemy_classes[class_name] and love.filesystem.getInfo(path) then
        enemy_classes[class_name] = love.filesystem.load(path)()
    end
    if enemy_classes[class_name] then
        local enemy = Actor.new(class_name, enemy_classes[class_name])
        return enemy
    end
end

return data_manager