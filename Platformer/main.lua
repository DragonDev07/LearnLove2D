function love.load()
    -- External Files
    require('src.player')
    require('src.world')
    require('src.debug')
    require('src.maps')
    require('src.camera')

    -- Load
    world:loadMap(0, 0)
end

function love.update(dt)
    player:update(dt) -- Update the player
    debugVals:update(dt) -- Update the debug vals
    mapsTable:update(dt) -- Update the tiles (animations etc)
    cam:update(dt) -- Update the camera
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0) -- Set background color (TEMP WHILE I MAKE A BG)

    cam:attach()
    mapsTable:draw() -- Draw the map
        player:draw() -- Draw all player stuff
        debugVals:drawInCam() -- Draw the debug inside camera stuff
     cam:detach()

     debugVals:drawHudDebugs() -- Draw the debugs ontop of the camera (HUD)
end