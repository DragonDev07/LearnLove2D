local camera = require('libraries.camera')
require('src.maps')

cam = camera() -- Create Camera
cam:zoom(2) -- Zoom camera to 2

function cam:update(dt)
    -- Variables used to limit camera bounds
    local w = love.graphics.getWidth() / 2
    local h = love.graphics.getHeight() /2
    local mapW = mapsTable.gameMap.width * mapsTable.gameMap.tilewidth
    local mapH = mapsTable.gameMap.height * mapsTable.gameMap.tileheight

    -- Camera Bounds & Locking Onto Player
    cam:lookAt(player.x, player.y)    -- Lock camera onto player

    -- Stop camera left border 
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Stop camera top border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- Stop camera right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end

    -- Stop camera bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end