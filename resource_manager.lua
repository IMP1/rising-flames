local resource_manager = {}

local faces = {}

function resource_manager.face(char_name)
    if faces[char_name] == nil then
        local path = "res/gfx/faces/" .. char_name .. ".png"
        faces[char_name] = love.graphics.newImage(path)
    end
    return faces[char_name]
end

local function load_faces() 
    local files = love.filesystem.getDirectoryItems("res/gfx/faces")
    for _, filename in pairs(files) do
        local path = "res/gfx/faces/" .. filename
        faces[filename] = love.graphics.newImage(path)
    end 
end

function resource_manager.load_all(dir)
    load_faces()
end

return resource_manager