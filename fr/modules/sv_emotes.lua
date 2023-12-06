RegisterNetEvent('FR:sendSharedEmoteRequest')
AddEventHandler('FR:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('FR:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('FR:receiveSharedEmoteRequest')
AddEventHandler('FR:receiveSharedEmoteRequest', function(i, a)
    local source = source
    if a == -1 then 
        TriggerEvent("FR:acBan", FR.getUserId(source), 11, FR.getPlayerName(source), source, "Triggering receiveSharedEmoteRequest")
    end
    TriggerClientEvent('FR:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('FR:receiveSharedEmoteRequest', source, a)
end)


local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = FR.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('FR:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function FR.ShaveHead(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        FRclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                FRclient.isPlayerSurrenderedNoProgressBar(nplayer,{},function(surrendering)
                    if surrendering then
                        FR.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('FR:startShavingPlayer', source, nplayer)
                        shavedPlayers[FR.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        FRclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                FRclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
