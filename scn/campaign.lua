local base_scene = require 'scn.base'
local scene_manager = require 'scn.scene_manager'

local campaign = {}
setmetatable(campaign, base_scene)
campaign.__index = campaign

function campaign.new(campaign_filename)
    local self = {}
    setmetatable(self, campaign)

    self.filename      = campaign_filename
    self.levels        = {}
    self.current_level = 0

    return self
end

function campaign:load()
    local campaign_data = love.filesystem.load("dat/campaigns/" .. self.filename .. ".lua")()
    self.name = campaign_data.name
    self.levels = campaign_data.levels
    self.current_level = 0
    self:next_level()
end

function campaign:next_level()
    self.current_level = self.current_level + 1
    if self.current_level > #self.levels then
        scene_manager.popScene()
        return 
    end
    local level = self.levels[self.current_level]
    if level.type == "battle" then
        scene_manager.pushScene(require('scn.battle').new(level.file))
    elseif level.type == "conversation" then
        scene_manager.pushScene(require('scn.conversation').new(level.file))
    end
end

function campaign:update(dt)
    self:next_level()
end

return campaign
