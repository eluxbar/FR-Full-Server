netObjects = {}

RegisterServerEvent("FR:spawnVehicleCallback")
AddEventHandler('FR:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = FR.getUserSource(a), id = a, name = FR.getPlayerName(FR.getUserSource(a))}
end)

RegisterServerEvent("FR:delGunDelete")
AddEventHandler("FR:delGunDelete", function(object)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("FR:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("FR:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)