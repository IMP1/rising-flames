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
    scene_manager.draw()
end