local soundCode = math.random(143, 1000000)

RegisterServerEvent('FR:soundCodeServer', function()
    TriggerClientEvent('FR:soundCode', source, soundCode)
end)
RegisterServerEvent("FR:playNuiSound", function(sound, distance, soundEventCode)
    local source = source
    local user_id = FR.getUserId(source)
    if soundCode == soundEventCode then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent("FR:playClientNuiSound", -1, coords, sound, distance)
    else
        TriggerClientEvent("FR:playClientNuiSound", source, coords, sound, distance)
        Wait(2500)
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger Sound Event')
    end
end)

RegisterCommand("tomss", function(source, args)
    local user_id = FR.getUserId(source)
    if user_id == 0 then
        local distance = 15
        if args[2] then
            distance = tonumber(args[2])
        end
        TriggerClientEvent("FR:playClientNuiSound", -1, GetEntityCoords(GetPlayerPed(FR.getUserSource(tonumber(args[1])))), 'scream', distance)
    end
end)