local actor = require 'cls.game.actor'

return {
    name = "Humble Beginnings",
    map = "map_1",
    starting_player_units = {
        { name = "colm", position = {-3, 2} },
        { name = "saleh", position = {-4, 3} },
    },
    starting_enemy_units = {
        { 
            name = "bandit_1", 
            position = {1, 0}, 
            class = actor.Class.FIGHTER 
        }, 
    },
    starting_neutral_units = {},
    triggers = {},
}
