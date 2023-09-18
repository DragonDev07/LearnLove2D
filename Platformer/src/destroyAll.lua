function destroyAll()
    colliderTableDestroy(collisions)
    colliderTableDestroy(transitions)
    colliderTableDestroy(platformCollisions)
end

function colliderTableDestroy(tableList)
    local i = #tableList
    while i > 0 do
        if tableList[i] ~= nil then
            tableList[i]:destroy()
        end
        table.remove(tableList, i)
        i = i - 1
    end
end