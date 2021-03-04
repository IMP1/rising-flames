local Actor = {}
Actor.__index = Actor

Actor.MovementType = {
    FOOT   = 0,
    HEAVY  = 1,
    ARMOUR = 2,
    MAGE   = 3,
    HORSE  = 4,
    FLYING = 5,
    BANDIT = 6,
    PIRATE = 7,
}

Actor.Class = {
    LORD = {
        name = "Lord",
        movement_type = Actor.MovementType.FOOT,
        strength      = 1.0,
    },
    THIEF = {
        name = "Thief",
        movement_type = Actor.MovementType.FOOT,
        strength      = 1.0,
    },
    FIGHTER = {
        name = "Fighter",
        movement_type = Actor.MovementType.HEAVY,
        strength      = 1.0,
    },
    RANGER = {
        name = "Ranger",
        movement_type = Actor.MovementType.HORSE,
        strength      = 1.0,
    },
    CAVALIER = {
        name = "Cavalier",
        movement_type = Actor.MovementType.HORSE,
        strength      = 1.0,
    },
    KNIGHT = {
        name = "Knight",
        movement_type = Actor.MovementType.ARMOUR,
        strength      = 1.0,
    },
    SHAMAN = {
        name = "Shaman",
        movement_type = Actor.MovementType.MAGE,
        strength      = 1.0,
    },
    SAGE = {
        name = "Sage",
        movement_type = Actor.MovementType.MAGE,
        strength      = 1.0,
    },
    ARCHER = {
        name = "Archer",
        movement_type = Actor.MovementType.FOOT,
        strength      = 1.0,
    },
    WYVERN_RIDER = {
        name = "Wyvern Rider",
        movement_type = Actor.MovementType.FLYING,
        strength      = 1.0,
    },
    CORSAIR = {
        name = "Corsair",
        movement_type = Actor.MovementType.PIRATE,
        strength      = 1.0,
    },
}

function Actor.new(name, actor_data)
    local self = {}
    setmetatable(self, Actor)

    -- Base Attributes
    
    self.data_name       = name
    self.name            = actor_data.name
    self.class           = actor_data.class
    self.max_health      = actor_data.stats.base.health
    self.move_distance   = actor_data.stats.base.move_distance   -- (in tiles)
    self.vision_distance = actor_data.stats.base.vision_distance -- (in tiles)
    self.level           = actor_data.level
    self.experience      = actor_data.experience
    self.levels_to_gain  = 0
    self.equipment       = actor_data.equipment
    
    -- Base Stats
    self.base_strength   = actor_data.stats.base.strength   -- Effectiveness of physical attacks.
    self.base_defence    = actor_data.stats.base.defence    -- Resistance to physical attacks.
    self.base_magic      = actor_data.stats.base.magic      -- Effectiveness of magical attacks.
    self.base_resistance = actor_data.stats.base.resistance -- Resistance to magical attacks.
    self.base_speed      = actor_data.stats.base.speed      -- Speed determines who attacks first (and double attacks).
    self.base_skill      = actor_data.stats.base.skill      -- Skill determines critical-hit likelihoods.

    -- Weapon Stats
    self.weapon_proficienies = actor_data.stats.weapon_proficiencies -- Proficiency (damage multiplier) with Weapon Categories.
    self.equipped_weapon     = nil
    -- Equip first weapon in equipment.
    for _, item in ipairs(self.equipment) do
        if self.equipped_weapon == nil and getmetatable(item) == Weapon then
            self.equipped_weapon = item
        end
    end

    -- Growth Stats
    if actor_data.stats.growth then
        self.growth_health     = actor_data.stats.growth.health          -- Probability that health will increase on level-up.
        self.growth_move       = actor_data.stats.growth.move_distance   -- Probability that move will increase on level-up.
        self.growth_vision     = actor_data.stats.growth.vision_distance -- Probability that vision will increase on level-up.
        self.growth_strength   = actor_data.stats.growth.strength        -- Probability that strength will increase on level-up.
        self.growth_defence    = actor_data.stats.growth.defence         -- Probability that defence will increase on level-up.
        self.growth_magic      = actor_data.stats.growth.magic           -- Probability that magic will increase on level-up.
        self.growth_resistance = actor_data.stats.growth.resistance      -- Probability that resistance will increase on level-up.
        self.growth_speed      = actor_data.stats.growth.speed           -- Probability that speed will increase on level-up.
        self.growth_skill      = actor_data.stats.growth.skill           -- Probability that skill will increase on level-up.
    end

    return self
end


function Actor:get_experience_gain(enemy)
    local relativeStrength = enemy.class.strength / self.class.strength
    return relativeStrength * 10
end
    
function Actor:weapon_weight()
    if equipped_weapon == nil then
        return 0
    else
        return equipped_weapon.weight
    end
end
    
function Actor:weapon_accuracy()
    if equipped_weapon == nil then
        return 0
    else
        return equipped_weapon.accuracy
    end
end


function Actor:canUseWeapon(weapon)
    if self.weapon_proficienies[weapon.category] == nil then
        return false
    end
    return self.weapon_proficienies[weapon.category] >= weapon.required_rank
end
    
function Actor:weapon_proficiency(weapon)
    return self.weapon_proficienies[weapon.category]
end
    
function Actor:weapon_bonus_accuracy()
    if self.equipped_weapon == nil then
        return 0
    else
        return self.equipped_weapon:bonus_accuracy(self)
    end
end
    
function Actor:weapon_bonus_might()
    if self.equipped_weapon == nil then
        return 0
    else
        return self.equipped_weapon:bonus_might(self)
    end
end

function Actor:attack_speed()
    local strength
    if self.equipped_weapon:is_magical() then
        strength = self.base_magic
    else
        strength = self.base_strength
    end
    return math.max(self.base_speed, self.base_speed - (self:weapon_weight() - strength))
end

function Actor:hit_rate()
    return self:weapon_accuracy() + (self.base_skill * 2) + (self:weapon_bonus_accuracy() / 2)
end

function Actor:evasion_rate()
    return self:attack_speed() * 2
end

function Actor:level_up()
    if math.random() < self.growth_health then
        self.max_health = self.max_health + 1
    end
    if math.random() < self.growth_strength then
        self.base_strength = self.base_strength + 1
    end
    if math.random() < self.growth_defence then
        self.base_defence = self.base_defence + 1
    end
    if math.random() < self.growth_magic then
        self.base_magic = self.base_magic + 1
    end
    if math.random() < self.growth_resistance then
        self.base_resistance = self.base_resistance + 1
    end
    if math.random() < self.growth_speed then
        self.base_speed = self.base_speed + 1
    end
    if math.random() < self.growth_skill then
        self.base_skill = self.base_skill + 1
    end
    if math.random() < self.growth_move then
        self.move_distance = self.move_distance + 1
    end
    if math.random() < self.growth_vision then
        self.vision_distance = self.vision_distance + 1
    end
    self.levels_to_gain = self.levels_to_gain - 1
end

return Actor