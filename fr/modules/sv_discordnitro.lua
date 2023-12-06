RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("FR:spawnNitroBMX", source)
    else
        if FR.checkForRole(user_id, '1127282397273128991') then
            TriggerClientEvent("FR:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("FR:spawnMoped", source)
        end
    end)
end)