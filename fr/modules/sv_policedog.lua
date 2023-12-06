RegisterCommand('k9', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('FR:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('FR:policeDogAttack', source)
    end
end)

RegisterNetEvent("FR:serverDogAttack")
AddEventHandler("FR:serverDogAttack", function(player)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('FR:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("FR:policeDogSniffPlayer")
AddEventHandler("FR:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = FR.getUserId(playerSrc)
        local cdata = FR.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('FR:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("FR:performDogLog")
AddEventHandler("FR:performDogLog", function(text)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'K9 Trained') then
        FR.sendWebhook('police-k9', 'FR Police Dog Logs',"> Officer Name: **"..FR.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)