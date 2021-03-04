local move_type = require 'cls.game.actor'.MovementType

local Terrain = {}
Terrain.__index = Terrain

-- movement cost of -1 means impassable
function Terrain.new(name, defence, avoid, heal, vision, default_move_cost, ...)
    local self = {}
    setmetatable(self, Terrain)

    self.name    = name
    self.defence = defence
    self.avoid   = avoid
    self.heal    = heal
    self.vision  = vision
    self.default_move_cost = default_move_cost
    self.movement_costs = {}

    for _, m in pairs({...}) do
        self.movement_costs[m[1]] = m[2]
    end

    return self
end

function Terrain:can_cross(movement_type)
    return self:cost(movement_type) >= 0
end

function Terrain:cost(movement_type)
    if self.movement_costs[movement_type] == nil then
        return self.default_move_cost
    else
        return self.movement_costs[movement_type]
    end
end

-- Absence of map
Terrain.BLANK  = Terrain.new("Blank", 
                            -1, -1, -1, -1, -1)
 
Terrain.PLAIN  = Terrain.new("Plain",
                            0, 0, 0, 1, 1)
Terrain.GRASS  = Terrain.new("Grass",
                            0, 0, 0, 1, 1)
Terrain.FOREST = Terrain.new("Forest",
                            1, 20, 0, -1, 2, 
                            {move_type.HORSE,  3})
Terrain.RIVER  = Terrain.new("River",
                            0, 0, 0, 0, -1, 
                            {move_type.FOOT,   5}, 
                            {move_type.BANDIT, 5},
                            {move_type.HORSE,  5},
                            {move_type.PIRATE, 2})
Terrain.BRIDGE = Terrain.new("Bridge",
                            0, 0, 0, 0, 1)
Terrain.FORT   = Terrain.new("Fort",
                            2, 20, 0.2, 0, 2)
Terrain.PEAK   = Terrain.new("Peak",
                            2, 40, 0.2, 2, -1,
                            {move_type.BANDIT, 4},
                            {move_type.FLYING, 1})
                    
return Terrain