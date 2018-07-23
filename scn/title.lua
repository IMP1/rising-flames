local base_scene = require 'scn.base'
local scene_manager = require 'scn.scene_manager'

local title = {}
setmetatable(title, base_scene)
title.__index = title

function title.new()
    local self = {}
    setmetatable(self, title)

    return self
end

function title:load()
    local new_campaign = require('scn.campaign').new("rising_flames")
    scene_manager.setScene(new_campaign)
end

return title
