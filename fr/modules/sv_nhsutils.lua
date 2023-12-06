local bodyBags = {}

RegisterServerEvent("FR:requestBodyBag")
AddEventHandler('FR:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("FR:removeBodybag")
AddEventHandler('FR:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("FR:playNhsSound")
AddEventHandler('FR:playNhsSound', function(sound)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("FR:attachLifepakServer")
AddEventHandler('FR:attachLifepakServer', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        FRclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = FR.getUserId(nplayer)
            if nuser_id ~= nil then
                FRclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('FR:attachLifepak', source, in_coma, nuser_id, nplayer, FR.getPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                FRclient.notify(source, {"There is no player nearby"})
            end
        end)
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("FR:finishRevive")
AddEventHandler('FR:finishRevive', function(permid)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('FR:returnRevive', source)
                FR.giveBankMoney(user_id, 5000)
                FRclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                FRclient.RevivePlayer(FR.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("FR:nhsRevive") -- nhs radial revive
AddEventHandler('FR:nhsRevive', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        FRclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('FR:beginRevive', source, in_coma, FR.getUserId(playersrc), playersrc, FR.getPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = FR.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}

RegisterServerEvent("FR:attemptCPR")
AddEventHandler('FR:attemptCPR', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)

    FRclient.getNearestPlayers(source, {15}, function(nplayers)
        local targetPlayer = nplayers[playersrc]

        if targetPlayer then
            local targetPed = GetPlayerPed(playersrc)
            local targetHealth = GetEntityHealth(targetPed)

            if targetHealth > 102 then
                FRclient.notify(source, {"This person is already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('FR:attemptCPR', source)

                Citizen.Wait(15000) -- Wait for 15 seconds

                if playersInCPR[user_id] then
                    local cprChance = math.random(1, 10)

                    if cprChance == 1 then
                        FRclient.RevivePlayer(playersrc, {})
                        FRclient.notify(playersrc, {"~b~Your life has been saved."})
                        FRclient.notify(source, {"~b~You have saved this person's life."})
                    else
                        FRclient.notify(source, {'~r~Failed to perform CPR.'})
                    end

                    playersInCPR[user_id] = nil
                    FRclient.notify(source, {"~r~CPR has been canceled."})
                    TriggerClientEvent('FR:cancelCPRAttempt', source)
                end
            end
        else
            FRclient.notify(source, {"Player not found."})
        end
    end)
end)


RegisterServerEvent("FR:cancelCPRAttempt")
AddEventHandler('FR:cancelCPRAttempt', function()
    local source = source
    local user_id = FR.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        FRclient.notify(source, {"~r~CPR has been canceled."})
        TriggerClientEvent('FR:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("FR:syncWheelchairPosition")
AddEventHandler('FR:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = FR.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("FR:wheelchairAttachPlayer")
AddEventHandler('FR:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:wheelchairAttachPlayer', -1, entity, source)
end)