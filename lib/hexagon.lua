local Hexagon = {}
Hexagon.__index = Hexagon

local ROOT_3 = math.sqrt(3)

local NEIGHBOURS = { 
    {1, -1}, { 1, 0}, {0,  1},
    {-1, 1}, {-1, 0}, {0, -1},
}

local SIZE = 24

local HEIGHT = SIZE * 2
local VERT = 3 * HEIGHT / 4
    
local WIDTH = HEIGHT * ROOT_3 / 2
local HORZ = WIDTH

function Hexagon.set_size(size)
    SIZE   = size
    HEIGHT = SIZE * 2
    VERT   = 3 * HEIGHT / 4
    WIDTH  = HEIGHT * ROOT_3 / 2
    HORZ   = WIDTH
end

function Hexagon.neighbour(map, hex, direction)
    local d = NEIGHBOURS[direction]
    return map[hex.j + d[1]][hex.i + d[0]]
end

function Hexagon.get_axial(x, y)
    local ai = ((1/3) * ROOT_3 * x - (1/3) * y) / SIZE
    local aj = (2/3) * y / SIZE
    local ak = -(ai + aj)
    
    local ri = math.floor(ai + 0.5)
    local rj = math.floor(aj + 0.5)
    local rk = math.floor(ak + 0.5)
    
    local di = math.abs(ri - ai)
    local dj = math.abs(rj - aj)
    local dk = math.abs(rk - ak)
    
    if (di > dj and di > dk) then
        ri = -(rj + rk)
    elseif (dj > dk) then
        rj = -(ri + rk)
    else
        rk = -(ri + rj)
    end
    return ri, rj
end

function Hexagon.center_pixel(i, j)
    local x = HORZ * (i + j / 2)
    local y = VERT * j
    
    local rx = math.floor(x)
    local ry = math.floor(y)
    return {rx, ry}
end

function Hexagon.distance(self, other)
    local self_k  = -(self.i  + self.j);
    local other_k = -(other.i + other.j);
    return (Math.abs(self.i - other.i) + Math.abs(self.j - other.j) + Math.abs(self_k - other_k)) / 2;
end

function Hexagon.new(i, j)
    local self = {}
    setmetatable(self, Hexagon)

    self.i = i
    self.j = j

    return self
end

function Hexagon:coords()
    return self.i, self.j
end


return Hexagon