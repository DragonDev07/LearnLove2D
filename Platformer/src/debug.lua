require('src.camera')

-- Debug Values
debugVals = {}
debugVals.showCollisions = false -- If true shows the collision boxes
debugVals.showFPS = false -- Shows FPS Counter
debugVals.showPositions = false -- Shows position values of the camera and the player
debugVals.showIsJumping = false -- Shows if the player is in a jumping state or not

function debugVals:update(dt)
    -- Set Show Collisions if key pressed
    if love.keyboard.isDown("f1") then
        debugVals.showCollisions = not debugVals.showCollisions
    end

    -- Set Show FPS if key pressed
    if love.keyboard.isDown("f2") then
        debugVals.showFPS = not debugVals.showFPS
    end

    -- Set Show Positions if key pressed
    if love.keyboard.isDown("f3") then
        debugVals.showPositions = not debugVals.showPositions
    end

    if love.keyboard.isDown("f4") then
        debugVals.showIsJumping = not debugVals.showIsJumping
    end
end

function debugVals:drawInCam()
    -- Draw the world (collisions) if debug value = true
    if debugVals.showCollisions then
        world:draw() -- Drawing the world (collision boxes)
    end
end

function debugVals:drawHudDebugs()
    local camX, camY = cam:position() -- Get camera position

    -- Draw FPS ontop of camera if debug value = true
    if debugVals.showFPS then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 00)
     end

    -- Draw camera position & player position values
    if debugVals.showPositions then
        love.graphics.print("Player X: " .. player.x, 0, 10)
        love.graphics.print("Player Y: " .. player.y, 0, 20)
        love.graphics.print("Camera X: " .. camX, 0, 30)
        love.graphics.print("Camera Y: " .. camY, 0, 40)
    end

    -- Draw player jumping state
    if debugVals.showIsJumping then
        love.graphics.print("isJumping: " .. tostring(player.isJumping), 0, 50)
    end
end