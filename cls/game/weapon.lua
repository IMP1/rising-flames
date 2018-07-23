local Weapon = {}
Weapon.__index = Weapon

Weapon.Rank = {
    E = 1,
    D = 2,
    C = 3,
    B = 4,
    A = 5,
    S = 6,
}

Weapon.Category = {
    SWORD     = { realm = "physical" },
    LANCE     = { realm = "physical" },
    AXE       = { realm = "physical" },
    BOW       = { realm = "physical" },
    DARK      = { realm = "magical" },
    LIGHT     = { realm = "magical" },
    ELEMENTAL = { realm = "magical" },
    STAFF     = { realm = "magical" },
}

function Weapon.new()
    local self = {}
    setmetatable(self, Weapon)

    self.required_rank  = Weapon.Rank.E
    self.category       = Weapon.Category.SWORD
    self.weight         = 0
    self.accuracy       = 1
    self.max_uses       = 10
    self.remaining_uses = self.max_uses

    return self
end

function Weapon:is_magical()
    return self.category.realm == "magical"
end

function Weapon:is_physical()
    return self.category.realm == "physical"
end

function Weapon:bonus_accuracy(weilder)
    if self.category == Weapon.Category.AXE then
        if weilder.weapon_proficiency(self) == Weapon.Rank.C then
            return 5
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.B then
            return 10
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.A then
            return 15
        end
    elseif self.category == Weapon.Category.LANCE or 
            self.category == Weapon.Category.BOW or 
            self.category == Weapon.Category.DARK or 
            self.category == Weapon.Category.LIGHT or 
            self.category == Weapon.Category.ELEMENTAL then 
        if weilder.weapon_proficiency(self) == Weapon.Rank.B then
            return 5
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.A then
            return 5
        end
    end
    return 0
end

function Weapon:bonus_might(weilder)
    if self.category == Weapon.Category.SWORD then
        if weilder.weapon_proficiency(self) == Weapon.Rank.C then
            return 1
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.B then
            return 2
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.A then
            return 3
        end
    elseif self.category == Weapon.Category.LANCE or 
            self.category == Weapon.Category.BOW or 
            self.category == Weapon.Category.DARK or 
            self.category == Weapon.Category.LIGHT or 
            self.category == Weapon.Category.ELEMENTAL then 
        if weilder.weapon_proficiency(self) == Weapon.Rank.C then
            return 1
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.B then
            return 1
        elseif weilder.weapon_proficiency(self) == Weapon.Rank.A then
            return 2
        end
    end
    return 0
end

return Weapon