local actor  = require 'cls.game.actor'
local weapon = require 'cls.game.weapon'

return {
    name = "Bandit",
    class = actor.Class.FIGHTER,
    level = 1,
    stats = {
        base = {
            health          = 14,
            move_distance   = 5,
            vision_distance = 8,
            strength        = 4,
            defence         = 3,
            magic           = 2,
            resistance      = 1,
            speed           = 8,
            skill           = 3,
        },
        weapon_proficiencies = {
            [weapon.Category.AXE] = weapon.Rank.E,
        },
    },
    equipment = {},
}