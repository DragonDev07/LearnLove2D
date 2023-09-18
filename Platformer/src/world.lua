local wf = require('libraries.windfield')
require('src.maps') -- Maps file, used to acess layers of map
require('src.destroyAll')

world = wf.newWorld(0, 512) -- Declare Windfield World
world:addCollisionClass("Player") -- Add Collision Class for Player
world:addCollisionClass("Collisions") -- Add Collision Class for Platforms
world:addCollisionClass("Platforms")
world:addCollisionClass("Transition")

transitions = {}
collisions = {}
platformCollisions = {}

function world:loadMap(destX, destY)
    destroyAll()
    player.isJumping = false

    if destX and destY then
        player:setPosition(destX, destY)
    end

    if mapsTable.gameMap.layers["Collisions"] then
        for i, obj in pairs(mapsTable.gameMap.layers["Collisions"].objects) do
            local collision = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collision:setType("static")
            collision:setCollisionClass("Collisions")
            table.insert(collisions, collision)
        end
    end

    if mapsTable.gameMap.layers["Loading Zones"] then
        for i, obj in pairs(mapsTable.gameMap.layers["Loading Zones"].objects) do
            spawnTransition(obj.x, obj.y, obj.width, obj.height, obj.name, obj.properties.destX, obj.properties.destY)
        end
    end

    if mapsTable.gameMap.layers["Platform Collisions"] then
        for i, obj in pairs(mapsTable.gameMap.layers["Platform Collisions"].objects) do
            local collision = world:newLineCollider(obj.x, obj.y, obj.x + obj.width, obj.y)
            collision:setType("static")
            collision:setCollisionClass("Platforms")
            table.insert(platformCollisions, collision)
        end
    end
end

function spawnTransition(x, y, width, height, id, destX, destY)

    local transition = world:newRectangleCollider(x, y, width, height, {collision_class = "Transition"})
    transition:setType('static')

    transition.id = id
    transition.destX = destX
    transition.destY = destY

    table.insert(transitions, transition)
end