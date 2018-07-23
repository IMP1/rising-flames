function love.conf(game)
    game.window.title  = "Rising Flames"
    game.window.width  = 960
    game.window.height = 640

    game.modules.physics = false
    game.modules.joystick = false
    game.modules.video = false
    game.modules.system = false
    game.modules.data = false
    game.modules.math = false
    game.modules.thread = false
end