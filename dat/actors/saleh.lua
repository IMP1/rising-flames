local actor  = require 'cls.game.actor'
local weapon = require 'cls.game.weapon'

return {
    name = "Saleh",
    class = actor.Class.SAGE,
    level = 4,
    experience = 0,
    stats = {
        base = {
            health          = 30,
            move_distance   = 6,
            vision_distance = 4,
            strength        = 16,
            defence         = 8,
            magic           = 16,
            resistance      = 13,
            speed           = 14,
            skill           = 18,
        },
        growth = {
            health          = 0.5,
            move_distance   = 0,
            vision_distance = 0,
            strength        = 0.3,
            defence         = 0.3,
            magic           = 0.3,
            resistance      = 0.35,
            speed           = 0.4,
            skill           = 0.25,
        },
        weapon_proficiencies = {
            [weapon.Category.LIGHT]     = weapon.Rank.B,
            [weapon.Category.ELEMENTAL] = weapon.Rank.A,
            [weapon.Category.STAFF]     = weapon.Rank.C,
        },
    },
    equipment = {},

}
