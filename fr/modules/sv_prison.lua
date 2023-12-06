MySQL.createCommand("FR/get_prison_time","SELECT prison_time FROM fr_prison WHERE user_id = @user_id")
MySQL.createCommand("FR/set_prison_time","UPDATE fr_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("FR/add_prisoner", "INSERT IGNORE INTO fr_prison SET user_id = @user_id")
MySQL.createCommand("FR/get_current_prisoners", "SELECT * FROM fr_prison WHERE prison_time > 0")
MySQL.createCommand("FR/add_jail_stat","UPDATE fr_police_hours SET total_player_jailed = (total_player_jailed+1) WHERE user_id = @user_id")

local cfg = module("cfg/cfg_prison")
local newDoors = {}
for k,v in pairs(cfg.doors) do
    for a,b in pairs(v) do
        newDoors[b.doorHash] = b
        newDoors[b.doorHash].currentState = 0
    end
end  
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = FR.getUserId(source)
    MySQL.execute("FR/add_prisoner", {user_id = user_id})
end)

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("FR/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('FR:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('FR:forcePlayerInPrison', source, true)
                    TriggerClientEvent('FR:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('FR:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('FR:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
        TriggerClientEvent('FR:prisonUpdateGuardNumber', -1, #FR.getUsersByPermission('hmp.menu'))
        TriggerClientEvent('FR:prisonSyncAllDoors', source, newDoors)
    end
end)

RegisterNetEvent("FR:getNumOfNHSOnline")
AddEventHandler("FR:getNumOfNHSOnline", function()
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FR/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('FR:prisonSpawnInMedicalBay', source)
                FRclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('FR:getNumberOfDocsOnline', source, #FR.getUsersByPermission('nhs.menu'))
            end
        end
    end)
end)

RegisterServerEvent("FR:prisonArrivedForJail")
AddEventHandler("FR:prisonArrivedForJail", function()
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FR/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                FR.setBucket(source, 0)
                TriggerClientEvent('FR:unHandcuff', source, false)
                TriggerClientEvent('FR:toggleHandcuffs', source, false)
                TriggerClientEvent('FR:forcePlayerInPrison', source, true)
                TriggerClientEvent('FR:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('FR:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("FR:prisonStartJob")
AddEventHandler("FR:prisonStartJob", function(job)
    local source = source
    local user_id = FR.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("FR:prisonEndJob")
AddEventHandler("FR:prisonEndJob", function(job)
    local source = source
    local user_id = FR.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("FR/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("FR/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('FR:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    FRclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("FR:jailPlayer")
AddEventHandler("FR:jailPlayer", function(player)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        FRclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                FRclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("FR/get_prison_time", {user_id = FR.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    FR.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            MySQL.execute("FR/set_prison_time", {user_id = FR.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('FR:prisonTransportWithBus', player, lastCellUsed+1)
                                            FR.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            exports['fr']:execute("SELECT * FROM `fr_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                                if result ~= nil then 
                                                    for k,v in pairs(result) do
                                                        if v.user_id == user_id then
                                                            exports['fr']:execute("UPDATE fr_police_hours SET total_players_jailed = @total_players_jailed WHERE user_id = @user_id", {user_id = user_id, total_players_jailed = v.total_players_jailed + 1}, function() end)
                                                            return
                                                        end
                                                    end
                                                    exports['fr']:execute("INSERT INTO fr_police_hours (`user_id`, `total_players_jailed`, `username`) VALUES (@user_id, @total_players_jailed, @username);", {user_id = user_id, total_players_jailed = 1}, function() end) 
                                                end
                                            end)
                                            TriggerClientEvent('FR:prisonCreateItemAreas', player, prisonItemsTable)
                                            FRclient.notify(source, {"~g~Jailed Player."})
                                            FR.sendWebhook('jail-player', 'FR Jail Logs',"> Officer Name: **"..FR.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..FR.getPlayerName(player).."**\n> Criminal PermID: **"..FR.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            FRclient.notify(source, {"Invalid time."})
                                        end
                                    end)
                                else
                                    FRclient.notify(source, {"Player is already in prison."})
                                end
                            end
                        end)
                    else
                        FRclient.notify(source, {"You must have the player handcuffed."})
                    end
                end)
            else
                FRclient.notify(source, {"Player not found."})
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        MySQL.query("FR/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("FR/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and FR.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('FR:prisonStopClientTimer', FR.getUserSource(v.user_id))
                        TriggerClientEvent('FR:prisonReleased', FR.getUserSource(v.user_id))
                        TriggerClientEvent('FR:forcePlayerInPrison', FR.getUserSource(v.user_id), false)
                        FRclient.setHandcuffed(FR.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(2000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.noclip') then
        FR.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("FR/set_prison_time", {user_id = FR.getUserId(player), prison_time = 0})
                TriggerClientEvent('FR:prisonStopClientTimer', player)
                TriggerClientEvent('FR:prisonReleased', player)
                TriggerClientEvent('FR:forcePlayerInPrison', player, false)
                FRclient.setHandcuffed(player, {false})
                FRclient.notify(source, {"~g~Target will be released soon."})
            else
                FRclient.notify(source, {"Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('FR:prisonUpdateGuardNumber', -1, #FR.getUsersByPermission('hmp.menu'))
    end
end)

local currentLockdown = false
RegisterServerEvent("FR:prisonToggleLockdown")
AddEventHandler("FR:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('FR:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('FR:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("FR:prisonSetDoorState")
AddEventHandler("FR:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("FR:enterPrisonAreaSyncDoors")
AddEventHandler("FR:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- FR:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- FR:requestPrisonerData