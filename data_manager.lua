local Actor = require 'cls.game.actor'

local data_manager = {}

local actors = {}

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

return data_manager