local scene_manager = require 'scn.scene_manager'

local INITIAL_SCENE = require 'scn.title'

function love.load()
    scene_manager.hook()
    scene_manager.setScene(INITIAL_SCENE.new())
end

function love.update(dt)
    scene_manager.update(dt)
end

function love.draw()
    local x = love.graphics.getWidth() / 2
    local y = love.graphics.getHeight() / 2
    love.graphics.line(x, 0, x, 2 * y)
    love.graphics.line(0, y, 2 * x, y)
    scene_manager.draw()
end