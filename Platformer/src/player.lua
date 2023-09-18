local anim8 = require('libraries.anim8') -- Library for animations
require('src.world') -- Import the world
maps = require('src.maps')

love.graphics.setDefaultFilter("nearest", "nearest") -- Set filter for when scaling

-- Declare Player
player = {} -- Stores all player info
player.collider = world:newRectangleCollider(0, 0, 20, 28) -- Create player collider
player.collider:setCollisionClass("Player") -- Set the collision class
player.collider:setFixedRotation(true) -- Set fixed rotation
player.x = 0 -- Player x position
player.y = 0 -- Player y position
player.speed = 500 -- Speed used for horizontal movement
player.jumpSpeed = 300 -- Speed thats used for jump
player.isJumping = false -- Used to check if player has already jumped once
player.isMoving = false -- If false, idle animation runs, updated in player:update
player.spriteSheet = love.graphics.newImage("sprites/PlatformerPlayer.png") -- Player's sprite sheet (animations)
player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() ) -- Grid used for animations

player.animations = {} -- Stores all seperate animations
player.animations.idle = anim8.newAnimation( player.grid('1-4', 1), 0.2) -- Declare idle animtion
player.animations.right = anim8.newAnimation(player.grid('1-3', 2), 0.2) -- Declare move right animation
player.animations.left = anim8.newAnimation(player.grid('1-3', 3), 0.2) -- Declare move left animation

player.anim = player.animations.idle -- Active animation

-- player:update runs each frame
function player:update(dt)
    player:checkTransition()
    world:update(dt) -- Update the world
    player.isMoving = false -- Make is moving false each frame
    local px, py = player.collider:getLinearVelocity() -- Get players velocity

    -- Move the player sprite to the collider's position
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    -- Check if player is touching the ground, if so, set jumping to false
    if player.collider:enter("Platforms") then
        player.isJumping = false
    end

    -- Movement Input & Control
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and px > -300 then
        player.collider:applyForce(player.speed, 0)
        player.anim = player.animations.right
        player.isMoving = true
    end

    if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and px < 300 then
        player.collider:applyForce(-player.speed, 0)
        player.anim = player.animations.left
        player.isMoving = true
    end

    if (love.keyboard.isDown("w") or love.keyboard.isDown("up") or love.keyboard.isDown("space")) and py > -300 and player.isJumping == false then
        player.collider:applyLinearImpulse(0, -player.jumpSpeed)
        player.isMoving = true
        player.isJumping = true
    end

    -- Idle Animation (if player not moving)
    if player.isMoving == false then
        player.anim = player.animations.idle
    end

    player.anim:update(dt) -- Update whichever animation is currently active

    if player.collider:enter("toLevel2") then
        mapsTable:changeMap(mapsTable.level2)
    end

    if player.collider:enter("toLevel1") then
        mapsTable:changeMap(mapsTable.level1)
    end
end

-- player:draw runs each frame
function player:draw()
    -- Draw the player & animation
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1.5, nil, 8, 8)
end

function player:setPosition(x, y)
    player.collider:setX(x)
    player.collider:setY(y)
end

function player:checkTransition()
    if player.collider:enter('Transition') then
        local t = player.collider:getEnterCollisionData('Transition')
        triggerTransition(t.collider.id, t.collider.destX, t.collider.destY)
        --triggerTransition(t.collider.id, t.collider.destX, t.collider.destY)
    end
end