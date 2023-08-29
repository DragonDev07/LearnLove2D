function love.load()
    -- Libraries
    anim8 = require("libraries.anim8")
    sti = require("libraries.sti")
    camera = require("libraries.camera")
    wf = require("libraries.windfield")

    world = wf.newWorld(0, 512) -- Declare Windfield World
    world:addCollisionClass("Player") -- Add Collision Class for Player
    world:addCollisionClass("Platforms") -- Add Collision Class for Platforms
    wold:addCollisionClass("Loading Zones") -- Add Collision Class for Loading Zones
    gameMap = sti(level.one) -- Import Level 1 Map
    cam = camera() -- Create Camera
    cam:zoom(2)
    love.graphics.setDefaultFilter("nearest", "nearest") -- Set Filter

    -- Debug Values
    debugVals = {}
    debugVals.showCollisions = false
    debugVals.showFPS = false
    debugVals.showPositions = false

    -- level
    level = {}
    level.one = 'maps/level1.lua'
    level.two = 'maps/level2.lua'

    -- Player!
    player = {}
    player.collider = world:newRectangleCollider(0, 0, 20, 28)
    player.collider:setCollisionClass("Player")
    player.collider:setFixedRotation(true)
    player.x = 0
    player.y = 0
    player.speed = 500
    player.jumpSpeed = 200
    player.isJumping = false
    player.spriteSheet = love.graphics.newImage("sprites/PlatformerPlayer.png")
    player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.idle = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.right = anim8.newAnimation(player.grid('1-3', 2), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-3', 3), 0.2)

    player.anim = player.animations.idle

    collisions = {}
    if gameMap.layers["Collisions"] then
        for i, obj in pairs(gameMap.layers["Collisions"].objects) do
            local collision = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collision:setType("static")
            collision:setCollisionClass("Platforms")
            table.insert(collisions, collision)
        end
    end

    loadingZones = {}
    if gameMap.layers["Loading Zones"] then
        for i, obj in pairs(gameMap.layers["Loading Zones"].objects) do
            local loadingZone = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            loadingZone:setType("static")
            loadingZone:setCollisionClass("Loading Zones")
            table.insert(loadingZones, loadingZone)
        end
    end
end

function love.update(dt)
    world:update(dt) -- Update the world made by windfield
    gameMap:update(dt) -- Update the tiles (animations etc)
    local isMoving = false -- Player Moving Variable
    local px, py = player.collider:getLinearVelocity() -- Get players velocity

    -- Variables used to limit camera bounds
    local w = love.graphics.getWidth() / 2
    local h = love.graphics.getHeight() /2
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Move the player sprite to the collider's position
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    -- Check if player is touching the ground, if so, set jumping to false
    if player.collider:enter("Platforms") then
        player.isJumping = false
    end

    -- Check if player is touching the ground, if so, set jumping to true
    if player.collider:exit("Platforms") then
        player.isJumping = true
    end

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

    -- Movement Input & Control
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and px > -300 then
        player.collider:applyForce(player.speed, 0)
        player.anim = player.animations.right
        isMoving = true
    end
    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and px < 300 then
        player.collider:applyForce(-player.speed, 0)
        player.anim = player.animations.left
        isMoving = true
    end
    if (love.keyboard.isDown("w") or love.keyboard.isDown("up") or love.keyboard.isDown("space")) and py > -300 and player.isJumping == false then
        player.collider:applyLinearImpulse(0, -player.jumpSpeed)
        -- player.anim = player.animations.up
        isMoving = true
    end

    -- Idle Animation (if player not moving)
    if isMoving == false then
        player.anim = player.animations.idle
    end

    player.anim:update(dt) -- Update whichever animation is currently active

    -- -- Camera Bounds & Locking Onto Player
    cam:lookAt(player.x, player.y)    -- Lock camera onto player

    -- -- -- Stop camera left border 
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- -- Stop camera top border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- -- Stop camera right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end

    -- -- Stop camera bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

function love.draw()
    local camX, camY = cam:position()
    cam:attach()
        -- Draw layers of tiledMap
        gameMap:drawLayer(gameMap.layers["Platforms"])

        -- Draw the player & animation
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1.5, nil, 8, 8)

        -- Draw the world (collisions) if debug value = true
        if debugVals.showCollisions then
            world:draw()
        end
     cam:detach()

     -- Draw FPS ontop of camera if debug value = true
     if debugVals.showFPS then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
     end

     if debugVals.showPositions then
        love.graphics.print("Player X: " .. player.x, 0, 0)
        love.graphics.print("Player Y: " .. player.y, 0, 10)
        love.graphics.print("Camera X: " .. camX, 0, 20)
        love.graphics.print("Camera Y: " .. camY, 0, 30)
     end
end