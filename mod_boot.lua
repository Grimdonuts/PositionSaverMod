add_hook('postbeginlevel', 'GrantSaverItems')

function GrantSaverItems()
    if (Global.player:isInInventory('PositionLoader') ~= 1) then
        local loader = SpawnScript('global.collectibles.PositionLoader', 'PositionLoader')
        Global.player:addToInventory(loader,0,1)
    end
    if (Global.player:isInInventory('PositionSaver') ~= 1) then
        local saver = SpawnScript('global.collectibles.PositionSaver', 'PositionSaver')
        Global.player:addToInventory(saver,0,1)
    end
end