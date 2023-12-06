local flaggedVehicles = {}

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if FR.hasPermission(user_id, 'police.armoury') then
            TriggerClientEvent('FR:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("FR:flagVehicleAnpr")
AddEventHandler("FR:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('FR:setFlagVehicles', -1, flaggedVehicles)
    end
end)