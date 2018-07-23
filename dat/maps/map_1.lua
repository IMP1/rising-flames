local tile = require 'cls.map.terrain'
local _ = tile.BLANK
local P = tile.PLAIN
local R = tile.RIVER
local G = tile.GRASS
local B = tile.BRIDGE

tiles = {
    { _, _, _, P, G, R, G, G, P, },
    { _, _, P, P, G, R, G, P, P, },
    { _, P, P, G, R, G, G, G, G, },
    { P, P, P, G, B, G, R, R, R, },
    { P, P, P, G, R, R, G, G, _, },
    { P, P, P, G, G, G, G, _, _, },
    { P, P, P, P, G, G, _, _, _, },
}

return {
    name = "Testing",
    tiles = tiles,
    width = 8,
    height = 8,
}
