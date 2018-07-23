local actor  = require 'cls.game.actor'
local weapon = require 'cls.game.weapon'

return {
    name = "Colm",
    class = actor.Class.THIEF,
    level = 1,
    experience = 0,
    stats = {
        base = {
            health          = 18,
            move_distance   = 6,
            vision_distance = 8,
            strength        = 4,
            defence         = 3,
            magic           = 4,
            resistance      = 1,
            speed           = 10,
            skill           = 4,
        },
        growth = {
            health          = 0.7,
            move_distance   = 0,
            vision_distance = 0,
            strength        = 0.4,
            defence         = 0.25,
            magic           = 0.4,
            resistance      = 0.2,
            speed           = 0.65,
            skill           = 0.4,
        },
        weapon_proficiencies = {
            [weapon.Category.SWORD] = weapon.Rank.E,
        },
    },
    equipment = {},
}