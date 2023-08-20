function love.load()
    -- Libraries
    wf = require('libraries.windfield')

    world = wf.newWorld(0, 100)

    player = world:newRectangleCollider(350, 100, 80, 80)
    ground = world:newRectangleCollider(100, 400, 600, 100)
    ground:setType("static")
end

function love.update(dt)
    world:update(dt)

    local px, py = player:getLinearVelocity()
    if love.keyboard.isDown('w') and py > -300 then
        player:applyLinearImpulse(0, -5000)
    end

    if love.keyboard.isDown('a') and px > -300  then
        player:applyForce(-5000, 0)
    end

    if love.keyboard.isDown('d') and px < 300  then
        player:applyForce(5000, 0)
    end
end

function love.draw()
    world:draw()
end