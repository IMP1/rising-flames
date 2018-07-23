local resource_manager = {}

local faces = {}

function resource_manager.actor_face(actor_name)
    if faces[actor_name] == nil then
        local path = "res/gfx/faces/" .. actor_name .. ".png"
        faces[actor_name] = love.graphics.newImage(path)
    end
    return faces[actor_name]
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