local sti = require('libraries.sti')

-- levels
mapsTable = {}
mapsTable.level1 = 'maps/level1.lua'
mapsTable.level2 = 'maps/level2.lua'
mapsTable.gameMap = sti(mapsTable.level1)

function mapsTable:update(dt)
    mapsTable.gameMap:update(dt) -- Update tiles (animations, etc)
end

function triggerTransition(id, destX, destY)
    if id == "toLevel1" then
        mapsTable.gameMap = sti(mapsTable.level1)
    elseif id == "toLevel2" then
        mapsTable.gameMap = sti(mapsTable.level2)
    end

    world:loadMap(destX, destY)
    player:setPosition(destX, destY)
end

function mapsTable:draw()
    mapsTable.gameMap:drawLayer(mapsTable.gameMap.layers["Platforms"]) -- Draw the platforms
end