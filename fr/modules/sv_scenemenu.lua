local spikes = 0
local speedzones = 0

RegisterNetEvent("FR:placeSpike")
AddEventHandler("FR:placeSpike", function(heading, coords)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('FR:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("FR:removeSpike")
AddEventHandler("FR:removeSpike", function(entity)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('FR:deleteSpike', -1, entity)
        TriggerClientEvent("FR:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("FR:requestSceneObjectDelete")
AddEventHandler("FR:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("FR:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("FR:createSpeedZone")
AddEventHandler("FR:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
        speedzones = speedzones + 1
        TriggerClientEvent('FR:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("FR:deleteSpeedZone")
AddEventHandler("FR:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('FR:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

