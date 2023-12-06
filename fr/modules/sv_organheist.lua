local cfg = module('cfg/cfg_organheist')
local organlocation = {["police"] = {}, ["civ"] = {}}
local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0




RegisterNetEvent("FR:joinOrganHeist")
AddEventHandler("FR:joinOrganHeist", function()
    local source = source
    local user_id = FR.getUserId(source)
    if not playersInOrganHeist[source] then
        if inWaitingStage then
            if FR.hasPermission(user_id, 'police.armoury') then
                playersInOrganHeist[source] = { type = 'police' }
                policeInGame = policeInGame + 1
                TriggerClientEvent('FR:addOrganHeistPlayer', -1, source, 'police')
                TriggerClientEvent('FR:teleportToOrganHeist', source, organlocation["police"], timeTillOrgan, 'police', 1)
            elseif FR.hasPermission(user_id, 'nhs.menu') then
                FRclient.notify(source, {'You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[source] = { type = 'civ' }
                civsInGame = civsInGame + 1
                TriggerClientEvent('FR:addOrganHeistPlayer', -1, source, 'civ')
                TriggerClientEvent('FR:teleportToOrganHeist', source, organlocation["civ"], timeTillOrgan, 'civ', 2)
                FRclient.giveWeapons(source, { { ['WEAPON_ROOK'] = { ammo = 250 } }, false })
            end
            FR.setBucket(source, 15)
            FRclient.setArmour(source, { 100, true })
        else
            FRclient.notify(source, {'~r~Organ Heist Has Not Started Yet! Starts at 7PM!'})
        end
    else
        FRclient.notify(source, {'~r~You have already joined the Organ Heist!'})
    end
end)


RegisterNetEvent("FR:diedInOrganHeist")
AddEventHandler("FR:diedInOrganHeist", function(killer)
    local source = source
    local playerid = FR.getUserId(source)
    if playersInOrganHeist[source] then
        if FR.getUserId(killer) ~= nil then
            local killerID = FR.getUserId(killer)
            FR.giveBankMoney(killerID, 100000)
            TriggerClientEvent('FR:organHeistKillConfirmed', killer, FR.getPlayerName(source))
        end
        TriggerClientEvent('FR:endOrganHeist', source)
        TriggerClientEvent('FR:removeFromOrganHeist', -1, source)
        Wait(2000)
        FR.setBucket(source, 0)
        playersInOrganHeist[source] = nil
    end
end)


AddEventHandler('playerDropped', function(reason)
    local source = source
    if playersInOrganHeist[source] then
        playersInOrganHeist[source] = nil
        TriggerClientEvent('FR:removeFromOrganHeist', -1, source)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if inGamePhase then
            local policeAlive = 0
            local civAlive = 0
            
            for k, v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive + 1
                end
            end
            
            if policeAlive == 0 or civAlive == 0 then
                for k, v in pairs(playersInOrganHeist) do
                    if policeAlive == 0 then
                        TriggerClientEvent('FR:endOrganHeistWinner', k, 'Civilians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('FR:endOrganHeistWinner', k, 'Police')
                    end
                    TriggerClientEvent('FR:endOrganHeist', k)
                    FR.setBucket(k, 0)
                    local user_id = FR.getUserId(k)
                    if user_id then
                        FR.giveBankMoney(user_id, 250000)
                    end
                    playersInOrganHeist[k] = nil
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 18 and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((60 - tonumber(time["min"])) * 60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in " .. math.floor((timeTillOrgan / 60)) .. " minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 19 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('FR:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k, v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('FR:endOrganHeist', k)
                        FRclient.notify(k, {'Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                        FR.setBucket(k, 0)
                    end
                end
            end
        end
    end
end)





-- TP Organ Server Event
RegisterServerEvent("FR:TPToOrganHeist")
AddEventHandler("FR:TPToOrganHeist", function()
    if inWaitingStage then
        local source = source
        FRclient.notify(source, {'~g~You are being teleported to the Organ Heist. Please wait for a moment...'})
        Citizen.Wait(5000)
        FRclient.notify(source, {'~g~You have been teleported to the Organ Heist.'})
        FRclient.teleport(source, vector3(232.5415802002,-1388.8203125,30.464513778687))
    else
        FRclient.notify(source, {'~r~Organ Heist has not started yet.'})
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        if inWaitingStage then
            FRclient.notify(-1, {'~g~Organ Heist Has Started! Type /tporgan to go to organ!'})
        end
    end
end)



-- Start Organ Command Event 

RegisterCommand("startorgan", function(source, args, rawCommand)
    local user_id = FR.getUserId(source)
    if user_id == 1 or user_id == 0 then
        if not inGamePhase then
            inWaitingStage = true
            for i = 10, 1, -1 do
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in " .. i .. " minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
                Citizen.Wait(60 * 1000)
            end
                
            inGamePhase = true
            inWaitingStage = false
            TriggerClientEvent('FR:startOrganHeist', -1)
        else
            FRclient.notify(source, {"An Organ Heist event is already in progress."})
        end
    else
        FRclient.notify(source, {"You are not authorized to use this command."})
    end
end)


-- Function For Changing The Organ Location

function FR.SetOrganLocations()
    local dayOfMonth = tonumber(os.date("%d"))
    
    if dayOfMonth % 2 == 1 then
        organlocation["police"] = cfg.locations[1].safePositions[math.random(2)] -- Bottom Floor
        organlocation["civ"] = cfg.locations[2].safePositions[math.random(2)] -- Top Floor
    else
        organlocation["police"] = cfg.locations[2].safePositions[math.random(2)] -- Top Floor
        organlocation["civ"] = cfg.locations[1].safePositions[math.random(2)] -- Bottom Floor
    end
end
FR.SetOrganLocations() -- Set the organ locations on server start
