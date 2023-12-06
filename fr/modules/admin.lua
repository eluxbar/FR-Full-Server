local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

RegisterServerEvent('FR:OpenSettings')
AddEventHandler('FR:OpenSettings', function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        if FR.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("FR:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("FR:OpenSettingsMenu", source, false)
        end
    end
end)

RegisterServerEvent('FR:SerDevMenu')
AddEventHandler('FR:SerDevMenu', function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        if user_id == 1 or user_id == 0 then
            TriggerClientEvent("FR:CliDevMenu", source, true)
        else
            TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to open dev menu')
        end
    end
end)

AddEventHandler("FRcli:playerSpawned", function()
    local source = source
    local user_id = FR.getUserId(source)
    Citizen.Wait(500)
    if FR.hasGroup(user_id, "pov") then
        Citizen.Wait(5000)
        TriggerClientEvent('FR:smallAnnouncement', source, 'Warning', "Your Are On POV List Make Sure You Have Clips On", 6, 10000)
    end
end)

RegisterCommand("sethours", function(source, args)
    local user_id = FR.getUserId(source)
    if source == 0 then 
        local data = FR.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        print(FR.getPlayerName(FR.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))
    elseif user_id == -1 then
        local data = FR.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        FRclient.notify(source,{"~g~You have set "..FR.getPlayerName(FR.getUserSource(tonumber(args[1]))).."'s hours to: "..tonumber(args[2])})
    end  
end)


RegisterNetEvent("FR:GetNearbyPlayers")
AddEventHandler("FR:GetNearbyPlayers", function(coords, dist)
    local source = source
    local user_id = FR.getUserId(source)
    local plrTable = {}
    if FR.hasPermission(user_id, 'admin.tickets') then
        FRclient.getNearestPlayersFromPosition(source, {coords, dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                playtime = FR.GetPlayTime(FR.getUserId(k))
                plrTable[FR.getUserId(k)] = {FR.getPlayerName(k), k, FR.getUserId(k), playtime}
            end
            plrTable[user_id] = {FR.getPlayerName(source), source, FR.getUserId(source), math.ceil((FR.getUserDataTable(user_id).PlayerTime/60)) or 0}
            TriggerClientEvent("FR:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("FR:requestAccountInfosv")
AddEventHandler("FR:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = FR.getUserId(adminrequest)
    if FR.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('FR:requestAccountInfo', FR.getUserSource(permid), true)
    end
end)

RegisterServerEvent("FR:receivedAccountInfo")
AddEventHandler("FR:receivedAccountInfo", function(gpu, cpu, userAgent, devices)
    if FR.hasPermission(adminrequest_id, 'group.remove') then
        local formatteddevices = json.encode(devices)
        local function formatEntry(entry)
            return entry.kind .. ': ' .. entry.label .. ' id = ' .. entry.deviceId
        end
        local formatted_entries = {}
        
        for _, entry in ipairs(devices) do
            if entry.deviceId ~= "communications" then
                table.insert(formatted_entries, formatEntry(entry))
            end
        end

        local newformat = table.concat(formatted_entries, '\n')
        newformat = newformat:gsub('audiooutput:', 'audiooutput: '):gsub('videoinput:', 'videoinput: ')
        FR.prompt(adminrequest, "Account Info", "GPU: " .. gpu .. " \n\nCPU: " .. cpu .. " \n\nUser Agent: " .. userAgent .. " \n\nDevices: " .. newformat, function(player, K)
        end)
    end
end)



RegisterServerEvent("FR:GetGroups")
AddEventHandler("FR:GetGroups",function(perm)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("FR:GotGroups", source, FR.getUserGroups(perm))
    end
end)

RegisterServerEvent("FR:CheckPov")
AddEventHandler("FR:CheckPov",function(userperm)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.tickets") then
        if FR.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('FR:ReturnPov', source, true)
        else
            TriggerClientEvent('FR:ReturnPov', source, false)
        end
    end
end)


RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("FR:spectatePlayer")
AddEventHandler("FR:spectatePlayer", function(id)
    local playerssource = FR.getUserSource(id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            FR.setBucket(source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent("FR:spectatePlayer",source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            FR.sendWebhook('spectate',"FR Spectate Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            FRclient.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterServerEvent("FR:stopSpectatePlayer")
AddEventHandler("FR:stopSpectatePlayer", function()
    local source = source
    if FR.hasPermission(FR.getUserId(source), "admin.spectate") then
        TriggerClientEvent("FR:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == FR.getUserId(source) then
                TriggerClientEvent("FR:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                FR.setBucket(source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("FR:ForceClockOff")
AddEventHandler("FR:ForceClockOff", function(player_temp)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    local player_perm = FR.getUserId(player_temp)
    if FR.hasPermission(user_id,"admin.tp2waypoint") then
        FR.removeAllJobs(player_perm)
        FRclient.notify(source,{'~g~User clocked off'})
        FRclient.notify(player_temp,{'~b~You have been force clocked off.'})
        FR.sendWebhook('force-clock-off',"FR Faction Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..FR.getPlayerName(player_temp).."**\n> Players TempID: **"..player_temp.."**\n> Players PermID: **"..player_perm.."**")
    else
        local player = FR.getUserSource(user_id)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 11, name, player, 'Attempted to Force Clock Off')
    end
end)

RegisterServerEvent("FR:AddGroup")
AddEventHandler("FR:AddGroup",function(perm, selgroup)
    local source = source
    local admin_temp = source
    local user_id = FR.getUserId(source)
    local permsource = FR.getUserSource(perm)
    local playerName = FR.getPlayerName(source)
    local povName = FR.getPlayerName(permsource)
    if FR.hasPermission(user_id, "group.add") then
        if selgroup == "Founder" and not FR.hasPermission(user_id, "group.add.founder") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not FR.hasPermission(user_id, "group.add.leaddeveloper") then
                FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not FR.hasPermission(user_id, "group.add.developer") then
                FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not FR.hasPermission(user_id, "group.add.staffmanager") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not FR.hasPermission(user_id, "group.add.commanager") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not FR.hasPermission(user_id, "group.add.headadmin") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Administrator" and not FR.hasPermission(user_id, "group.add.senioradmin") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Administrator" and not FR.hasPermission(user_id, "group.add.administrator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not FR.hasPermission(user_id, "group.add.srmoderator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not FR.hasPermission(user_id, "group.add.moderator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not FR.hasPermission(user_id, "group.add.supportteam") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not FR.hasPermission(user_id, "group.add.trial") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not FR.hasPermission(user_id, "group.add.pov") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            FR.addUserGroup(perm, selgroup)
            local user_groups = FR.getUserGroups(perm)
            TriggerClientEvent("FR:GotGroups", source, user_groups)
            FR.sendWebhook('group',"FR Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..FR.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
        end
    end
end)

RegisterServerEvent("FR:RemoveGroup")
AddEventHandler("FR:RemoveGroup",function(perm, selgroup)
    local source = source
    local user_id = FR.getUserId(source)
    local admin_temp = source
    local permsource = FR.getUserSource(perm)
    local playerName = FR.getPlayerName(source)
    local povName = FR.getPlayerName(permsource)
    if FR.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not FR.hasPermission(user_id, "group.remove.founder") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not FR.hasPermission(user_id, "group.remove.developer") then
                FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not FR.hasPermission(user_id, "group.remove.staffmanager") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not FR.hasPermission(user_id, "group.remove.commanager") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not FR.hasPermission(user_id, "group.remove.headadmin") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not FR.hasPermission(user_id, "group.remove.senioradmin") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Admin" and not FR.hasPermission(user_id, "group.remove.administrator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not FR.hasPermission(user_id, "group.remove.srmoderator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not FR.hasPermission(user_id, "group.remove.moderator") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not FR.hasPermission(user_id, "group.remove.supportteam") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not FR.hasPermission(user_id, "group.remove.trial") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not FR.hasPermission(user_id, "group.remove.pov") then
            FRclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            FR.removeUserGroup(perm, selgroup)
            local user_groups = FR.getUserGroups(perm)
            TriggerClientEvent("FR:GotGroups", source, user_groups)
            FR.sendWebhook('group',"FR Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..FR.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

local bans = {
    {id = "trolling",name = "1.0 Trolling",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "metagaming",name = "1.1 Metagaming",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "powergaming",name = "1.2 Power Gaming ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "failrp",name = "1.3 Fail RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rdm", name = "1.4 RDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "vdm", name = "1.6 VDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "breakrp",name = "1.8 Breaking Character",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatlog",name = "1.9 Combat logging",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatstore",name = "1.10 Combat storing",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "spitereport",name = "1.13 Spite Reporting",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
    {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "ftvl",name = "2.1 Value of Life",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "nlr", name = "2.6 NLR",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "badrp",name = "2.7 Bad RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "kidnapping",name = "2.8 Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "copbaiting",name = "3.2 Cop Baiting",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "interjectingrp",name = "3.5 Interjection of RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatrev",name = "3.6 Combat Reviving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gangcap",name = "3.7 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "maxgang",name = "3.8 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "gangalliance",name = "3.9 Gang Alliance",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "pov",name = "1.15 Failure to provide POV ",durations = {2,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
    {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false}
}
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("FR:GenerateBan")
AddEventHandler("FR:GenerateBan", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if FR.hasPermission(FR.getUserId(source), "admin.tickets") then
        exports['fr']:execute("SELECT * FROM fr_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(bans) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                PlayerOffenses[PlayerID][k] = 3
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~1st Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~2nd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~3rd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(100)
                TriggerClientEvent("FR:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
            end
        end)
    end
end)

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = FR.getUserId(source)
    for k,v in pairs(bans) do
        defaultBans[v.id] = 0
    end
    exports["fr"]:executeSync("INSERT IGNORE INTO fr_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
    exports["fr"]:executeSync("INSERT IGNORE INTO fr_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
end)

RegisterServerEvent("FR:ChangeName")
AddEventHandler("FR:ChangeName", function()
    local source = source
    local user_id = FR.getUserId(source)
    
    if user_id == 1 or user_id == 0 or user_id == 2 then
        FR.prompt(source, "Perm ID:", "", function(source, clientperm)
            if clientperm == "" then
                FRclient.notify(source, {"~r~You must enter a Perm ID."})
                return
            end
            clientperm = tonumber(clientperm)
            
            FR.prompt(source, "Name:", "", function(source, username)
                if username == "" then
                    FRclient.notify(source, {"~r~You must enter a name."})
                    return
                end
                local username = username
                
                FR.SetDiscordNameAdmin(clientperm, username)
            end)
        end)
    else
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to change name')
    end
end)

function FR.GetNameOffline(id)
    exports['fr']:execute("SELECT * FROM fr_users WHERE id = @id", {id = id}, function(result)
        if #result > 0 then
            name = result[1].username
        end
        return name
    end)
end

RegisterServerEvent("FR:BanPlayer")
AddEventHandler("FR:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = FR.getUserId(source)
    local AdminName = FR.getPlayerName(source)
    local CurrentTime = os.time()
    local adminlevel = FR.GetAdminLevel(AdminPermID)

    if not FR.hasPermission(AdminPermID, 'admin.tickets') then
        TriggerEvent("FR:acBan", admin_id, 11, AdminName, source, 'Attempted to Ban Someone')
        return
    end
    if PlayerID == AdminPermID then
        FRclient.notify(source, {"~r~You cannot ban yourself."})
        return
    end
    if FR.GetAdminLevel(PlayerID) >= adminlevel or PlayerID == 0 then
        FRclient.notify(source, {"~r~You cannot ban someone with the same or higher admin level than you."})
        return
    end
    local PlayerDiscordID = 0
    local PlayerSource = FR.getUserSource(PlayerID)
    local PlayerName = FR.getPlayerName(PlayerSource) or FR.GetNameOffline(PlayerID)
    FR.prompt(source, "Extra Ban Information (Hidden)", "", function(player, Evidence)
        if FR.hasPermission(AdminPermID, "admin.tickets") then
            if Evidence == "" then
                FRclient.notify(source, {"~r~Evidence field was left empty, please fill this in via Discord."})
                Evidence = "No Evidence Provided"
            end
            local banDuration
            local BanChatMessage
            if Duration == -1 then
                banDuration = "perm"
                BanPoints = 0
                BanChatMessage = "has been permanently banned for "..BanMessage
            else
                banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                BanChatMessage = "has been banned for "..BanMessage.." ("..Duration.."hrs)"
            end
            FR.sendWebhook('banned-player', "FR Banned Players", "> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason: **"..BanMessage.."**\n> Evidence: "..Evidence)
            TriggerClientEvent("chatMessage", -1, "^8", {180, 0, 0}, "^1"..PlayerName .. " ^3"..BanChatMessage, "alert")
            FR.sendWebhook('ban-player', "FR Ban Logs", AdminName.. " banned "..PlayerID, "> Admin Name: **"..AdminName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason(s): **"..BanMessage.."**")
            FR.ban(source, PlayerID, banDuration, BanMessage, Evidence)
            FR.AddWarnings(PlayerID, AdminName, BanMessage, Duration, BanPoints)
            exports['fr']:execute("UPDATE fr_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
            local a = exports['fr']:executeSync("SELECT * FROM fr_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
            for k, v in pairs(a) do
                if v.UserID == PlayerID then
                    if v.points > 10 then
                        exports['fr']:execute("UPDATE fr_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                        FR.banConsole(PlayerID, 2160, "You have reached 10 points and have received a 3-month ban.")
                    end
                end
            end
        end
    end)
end)




RegisterServerEvent('FR:RequestScreenshot')
AddEventHandler('FR:RequestScreenshot', function(target)
    local source = source
    local target_id = FR.getUserId(target)
    local target_name = FR.getPlayerName(target)
    local admin_id = FR.getUserId(source)
    local admin_name = FR.getPlayerName(source)
    if FR.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("FR:takeClientScreenshotAndUpload", target, FR.getWebhook('screenshot'))
        FR.sendWebhook('screenshot', 'FR Screenshot Logs', "> Players Name: **"..FR.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        TriggerEvent("FR:acBan", admin_id, 11, admin_name, source, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('FR:RequestVideo')
AddEventHandler('FR:RequestVideo', function(target)
    local source = source
    local target_id = FR.getUserId(target)
    local target_name = FR.getPlayerName(target)
    local admin_id = FR.getUserId(source)
    local admin_name = FR.getPlayerName(source)
    if FR.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("FR:takeClientVideoAndUpload", target, FR.getWebhook('video'))
        FR.sendWebhook('video', 'FR Video Logs', "> Players Name: **"..FR.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        TriggerEvent("FR:acBan", admin_id, 11, admin_name, source, 'Attempted to Request Video')
    end   
end)

RegisterServerEvent('FR:RequestVideoKillfeed')
AddEventHandler('FR:RequestVideoKillfeed', function(killer)
    TriggerClientEvent("FR:takeClientVideoAndUpload", killer, FR.getWebhook('killvideo'))   
end)

RegisterServerEvent('FR:KickPlayer')
AddEventHandler('FR:KickPlayer', function(target, tempid)
    local source = source
    local target_id = FR.getUserSource(target)
    local target_permid = target
    local playerOtherName = FR.getPlayerName(tempid)
    local admin_id = FR.getUserId(source)
    local adminName = FR.getPlayerName(source)
    local adminlevel = FR.GetAdminLevel(admin_id)
    if FR.GetAdminLevel(target) >= adminlevel or target == 0 then
        FRclient.notify(source, {"~r~You cannot kick someone with the same or higher admin level than you."})
        return
    end
    if FR.hasPermission(admin_id, 'admin.kick') then
        FR.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
            FR.sendWebhook('kick-player', 'FR Kick Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..target_id.."**\n> Player PermID: **"..target.."**\n> Kick Reason: **"..Reason.."**")
            FR.kick(target_id, "FR You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..FR.getPlayerName(source) or "No reason specified")
            FRclient.notify(source, {'~g~Kicked Player.'})
        end)
    else
        TriggerEvent("FR:acBan", admin_id, 11, name, source, 'Attempted to Kick Someone')
    end
end)




RegisterServerEvent('FR:RemoveWarning')
AddEventHandler('FR:RemoveWarning', function(warningid)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        if FR.hasPermission(user_id, "admin.removewarn") then 
            exports['fr']:execute("SELECT * FROM fr_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                if result ~= nil then
                    for k,v in pairs(result) do
                        if v.warning_id == tonumber(warningid) then
                            exports['fr']:execute("DELETE FROM fr_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                            exports['fr']:execute("UPDATE fr_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                            FRclient.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                            FR.sendWebhook('remove-warning', 'FR Remove Warning Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                        end
                    end
                end
            end)
        else
            local player = FR.getUserSource(admin_id)
            local name = FR.getPlayerName(source)
            Wait(500)
            TriggerEvent("FR:acBan", admin_id, 11, name, player, 'Attempted to Remove Warning')
        end
    end
end)

RegisterServerEvent("FR:Unban")
AddEventHandler("FR:Unban",function()
    local source = source
    local admin_id = FR.getUserId(source)
    playerName = FR.getPlayerName(source)
    if FR.hasPermission(admin_id, 'admin.unban') then
        FR.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            FRclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            FR.sendWebhook('unban-player', 'FR Unban Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            FR.setBanned(permid,false)
        end)
    else
        local player = FR.getUserSource(admin_id)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", admin_id, 11, name, player, 'Attempted to Unban Someone')
    end
end)


RegisterServerEvent("FR:getNotes")
AddEventHandler("FR:getNotes",function(player)
    local source = source
    local admin_id = FR.getUserId(source)
    if FR.hasPermission(admin_id, 'admin.tickets') then
        exports['fr']:execute("SELECT * FROM fr_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('FR:sendNotes', source, result[1].info)
            end
        end)
    end
end)

RegisterServerEvent("FR:updatePlayerNotes")
AddEventHandler("FR:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = FR.getUserId(source)
    if FR.hasPermission(admin_id, 'admin.tickets') then
        exports['fr']:execute("SELECT * FROM fr_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['fr']:execute("UPDATE fr_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                FRclient.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('FR:SlapPlayer')
AddEventHandler('FR:SlapPlayer', function(target)
    local source = source
    local admin_id = FR.getUserId(source)
    local player_id = FR.getUserId(target)
    if FR.hasPermission(admin_id, "admin.slap") then
        local playerName = FR.getPlayerName(source)
        local playerOtherName = FR.getPlayerName(target)
        FR.sendWebhook('slap', 'FR Slap Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..FR.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
        TriggerClientEvent('FR:SlapPlayer', target)
        FRclient.notify(source, {'~g~Slapped Player.'})
    else
        TriggerEvent("FR:acBan", admin_id, 11, name, source, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('FR:RevivePlayer')
AddEventHandler('FR:RevivePlayer', function(player_id, reviveall)
    local source = source
    local admin_id = FR.getUserId(source)
    local target = FR.getUserSource(player_id)
    if target ~= nil then
        if FR.hasPermission(admin_id, "admin.revive") then
            FRclient.RevivePlayer(target, {})
            FRclient.setPlayerCombatTimer(target, {0})
            FRclient.RevivePlayer(source, {})
            FRclient.setPlayerCombatTimer(source, {0})
            if not reviveall then
                local playerName = FR.getPlayerName(source)
                local playerOtherName = FR.getPlayerName(target)
                FR.sendWebhook('revive', 'FR Revive Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..FR.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                FRclient.notify(source, {'~g~Revived Player.'})
                return
            end
            FRclient.notify(source, {'~g~Revived all Nearby.'})
        else
            TriggerEvent("FR:acBan", admin_id, 11, name, source, 'Attempted to Revive Someone')
        end
    end
end)

frozenplayers = {}
RegisterServerEvent('FR:FreezeSV')
AddEventHandler('FR:FreezeSV', function(newtarget, isFrozen)
    local source = source
    local admin_id = FR.getUserId(source)
    local player_id = FR.getUserId(newtarget)
    if FR.hasPermission(admin_id, 'admin.freeze') then
        local playerName = FR.getPlayerName(source)
        local playerOtherName = FR.getPlayerName(newtarget)
        if isFrozen then
            FR.sendWebhook('freeze', 'FR Freeze Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..FR.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Frozen**")
            FRclient.notify(source, {'~g~Froze Player.'})
            frozenplayers[user_id] = true
            FRclient.notify(newtarget, {'~g~You have been frozen.'})
        else
            FR.sendWebhook('freeze', 'FR Freeze Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..FR.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Unfrozen**")
            FRclient.notify(source, {'~g~Unfrozen Player.'})
            FRclient.notify(newtarget, {'~g~You have been unfrozen.'})
            frozenplayers[user_id] = nil
        end
        TriggerClientEvent('FR:Freeze', newtarget, isFrozen)
    else
        TriggerEvent("FR:acBan", admin_id, 11, name, source, 'Attempted to Freeze Someone')
    end
end)

RegisterServerEvent('FR:TeleportToPlayer')
AddEventHandler('FR:TeleportToPlayer', function(newtarget)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = FR.getUserId(source)
    local player_id = FR.getUserId(newtarget)
    local name = FR.getPlayerName(source)
    if FR.hasPermission(user_id, 'admin.tp2player') then
        local playerName = FR.getPlayerName(source)
        local playerOtherName = FR.getPlayerName(newtarget)
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(newtarget)
        if adminbucket ~= playerbucket then
            FR.setBucket(source, playerbucket)
            FRclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        FRclient.teleport(source, coords)
        FRclient.notify(newtarget, {'~g~An admin has teleported to you.'})
    else
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Teleport to Someone')
    end
end)

RegisterServerEvent('FR:Teleport2Legion')
AddEventHandler('FR:Teleport2Legion', function(newtarget)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    if FR.hasPermission(user_id, 'admin.tp2player') then
        FRclient.teleport(newtarget, vector3(152.66354370117,-1035.9771728516,29.337995529175))
        FRclient.notify(newtarget, {'~g~You have been teleported to Legion by an admin.'})
        FRclient.setPlayerCombatTimer(newtarget, {0})
        FR.sendWebhook('tp-to-legion', 'FR Teleport Legion Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..FR.getUserId(newtarget).."**")
    else
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Teleport someone to Legion')
    end
end)
RegisterServerEvent('FR:Teleport2Paleto')
AddEventHandler('FR:Teleport2Paleto', function(newtarget)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    if FR.hasPermission(user_id, 'admin.tp2player') then
        FRclient.teleport(newtarget, vector3(-114.29886627197,6459.7553710938,31.468437194824))
        FRclient.notify(newtarget, {'~g~You have been teleported to Paleto by an admin.'})
        FRclient.setPlayerCombatTimer(newtarget, {0})
        FR.sendWebhook('tp-to-paleto', 'FR Teleport Paleto Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..FR.getUserId(newtarget).."**")
    else
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Teleport someone to Paleto')
    end
end)

RegisterNetEvent('FR:BringPlayer')
AddEventHandler('FR:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = FR.getUserSource(id) 
    local user_id = FR.getUserId(source)
    local source = source 
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tp2player') then
        if id then  
            local ped = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(ped)
            FRclient.teleport(id, pedCoords)
            local adminbucket = GetPlayerRoutingBucket(source)
            local playerbucket = GetPlayerRoutingBucket(id)
            if adminbucket ~= playerbucket then
                FR.setBucket(id, adminbucket)
                FRclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
            FRclient.setPlayerCombatTimer(id, {0})
        else 
            FRclient.notify(source,{"This player may have left the game."})
        end
    else
        local name = FR.getPlayerName(source)
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Teleport Someone to Them')
    end
end)

RegisterNetEvent('FR:GetCoords')
AddEventHandler('FR:GetCoords', function()
    local source = source 
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.tickets") then
        FRclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            FR.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
            end)
        end)
    else
        local name = FR.getPlayerName(source)
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Get Coords')
    end
end)

RegisterServerEvent('FR:Tp2Coords')
AddEventHandler('FR:Tp2Coords', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.tp2coords") then
        FR.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                FRclient.notify(source, {"We couldn't find those coords, try again!"})
            else
                FRclient.teleport(player,{x,y,z})
            end 
        end)
    else
        local name = FR.getPlayerName(source)
        TriggerEvent("FR:acBan", user_id, 11, name, source, 'Attempted to Teleport to Coords')
    end
end)

RegisterServerEvent("FR:Teleport2AdminIsland")
AddEventHandler("FR:Teleport2AdminIsland",function(id)
    local source = source
    local admin = source
    if id ~= nil then
        local admin_id = FR.getUserId(admin)
        local admin_name = FR.getPlayerName(admin)
        local player_id = FR.getUserId(id)
        local player_name = FR.getPlayerName(id)
        if FR.hasPermission(admin_id, 'admin.tp2player') then
            local playerName = FR.getPlayerName(source)
            local playerOtherName = FR.getPlayerName(id)
            FR.sendWebhook('tp-to-admin-zone', 'FR Teleport Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
            local ped = GetPlayerPed(source)
            local ped2 = GetPlayerPed(id)
            SetEntityCoords(ped2, 196.24597167969,7397.2084960938,14.497759819031)
            FR.setBucket(id, 0)
            FRclient.notify(FR.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
            FRclient.setPlayerCombatTimer(id, {0})
        else
            local name = FR.getPlayerName(source)
            TriggerEvent("FR:acBan", admin_id, 11, name, source, 'Attempted to Teleport Someone to Admin Island')
        end
    end
end)

RegisterServerEvent("FR:TeleportBackFromAdminZone")
AddEventHandler("FR:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local source = source
    local admin_id = FR.getUserId(source)
    if id ~= nil then
        if FR.hasPermission(admin_id, 'admin.tp2player') then
            local ped = GetPlayerPed(id)
            SetEntityCoords(ped, savedCoordsBeforeAdminZone)
            FR.sendWebhook('tp-back-from-admin-zone', 'FR Teleport Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..FR.getPlayerName(id).."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..FR.getUserId(id).."**")
            local name = FR.getPlayerName(source)
            TriggerEvent("FR:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
        end
    end
end)

RegisterNetEvent('FR:AddCar')
AddEventHandler('FR:AddCar', function()
    local source = source
    local admin_id = FR.getUserId(source)
    local admin_name = FR.getPlayerName(source)
    if FR.hasPermission(admin_id, 'admin.addcar') then
        FR.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            permid = tonumber(permid)
            FR.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                FR.prompt(source,"Locked:","",function(source, locked) 
                    if locked == '0' or locked == '1' then
                        if permid and car ~= "" then  
                            FRclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                                local uuid = string.upper(uuid)
                                exports['fr']:execute("SELECT * FROM `fr_user_vehicles` WHERE vehicle_plate = @plate", {plate = uuid}, function(result)
                                    if #result > 0 then
                                        FRclient.notify(source, {'Error adding car, please try again.'})
                                        return
                                    else
                                        MySQL.execute("FR/add_vehicle", {user_id = permid, vehicle = car, registration = uuid, locked = locked})
                                        FRclient.notify(source,{'~g~Successfully added Player\'s car'})
                                        FR.sendWebhook('add-car', 'FR Add Car To Player Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**\n> Spawncode: **"..car.."**")
                                    end
                                end)
                            end)
                        else 
                            FRclient.notify(source,{'~r~Failed to add Player\'s car'})
                        end
                    else
                        FRclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                    end
                end)
            end)
        end)
    else
        local player = FR.getUserSource(user_id)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 11, name, player, 'Attempted to Add Car')
    end
end)
RegisterCommand('cartoall', function(source, args)
    if source == 0 then
        if tostring(args[1]) then
            local car = tostring(args[1])
            for k, v in pairs(FR.getUsers()) do
                local plate = string.upper(generateUUID("plate", 5, "alphanumeric"))
                local locked = true -- You should define 'locked' here or retrieve it from somewhere
                MySQL.execute("FR/add_vehicle", {user_id = k, vehicle = car, registration = plate, locked = locked})
                print('Added Car To ' .. k .. ' With Plate: ' .. plate)
            end
        else
            print('Incorrect usage: cartoall [spawncode]')
        end
    end
end)

local cooldowncleanup = {}
RegisterNetEvent('FR:CleanAll')
AddEventHandler('FR:CleanAll', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.noclip') then
        if cooldowncleanup[source] then
            FRclient.notify(source, {'~r~You can only use this command once every 60 seconds.'})
            return
        end
        cooldowncleanup[source] = true
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'FR^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. FR.getPlayerName(source) .. "^0!", "alert")
        Wait(60000)
        cooldowncleanup[source] = false
    end
end)

RegisterNetEvent('FR:noClip')
AddEventHandler('FR:noClip', function()
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.noclip') then 
        FRclient.toggleNoclip(source,{})
        --FR.sendWebhook('no-clip', 'FR No Clip Log', "> Admin Name: **"..FR.getPlayerName(target).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
    end
end)

RegisterServerEvent("FR:GetPlayerData")
AddEventHandler("FR:GetPlayerData",function()
    local source = source
    user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        players = GetPlayers()
        players_table = {}
        useridz = {}
        for i, p in pairs(FR.getUsers()) do
            if FR.getUserId(p) ~= nil then
                name = FR.getPlayerName(p)
                user_idz = FR.getUserId(p)
                playtime = FR.GetPlayTime(user_idz)
                players_table[user_idz] = {name, p, user_idz, playtime}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, "FR - The Server Was Unable To Get Your User ID, Please Reconnect.")
            end
        end
        TriggerClientEvent("FR:getPlayersInfo", source, players_table, bans)
    end
end)

RegisterNetEvent("FR:searchByCriteria")
AddEventHandler("FR:searchByCriteria", function(searchtype)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        local players_table = {}
        local user_ids = {}
        local group = {}
        if searchtype == "Police" then
            group = FR.getUsersByPermission("police.armoury")
        elseif searchtype == "POV List" then
            group = FR.getUsersByPermission("pov.list")
        elseif searchtype == "Cinematic" then
            group = FR.getUsersByGroup("Cinematic")
        elseif searchtype == "NHS" then
            group = FR.getUsersByPermission("nhs.menu")
        elseif searchtype == "New Player" then
            group = FR.getUsersByGroup("NewPlayer")
        end

        if group then
            for k, v in pairs(group) do
                local usersource = FR.getUserSource(v)
                local name = FR.getPlayerName(usersource)
                local user_idz = v
                local data = FR.getUserDataTable(user_idz)
                local playtime = FR.GetPlayTime(user_idz)
                players_table[user_idz] = {name, usersource, user_idz, playtime}
                table.insert(user_ids, user_idz)
            end
        end
        TriggerClientEvent("FR:returnCriteriaSearch", source, players_table)
    end
end)


local Playtimes = {}

function FR.GetPlayTime(user_id)
    if Playtimes[user_id] == nil then
        local data = FR.getUserDataTable(user_id)
        local playtime = data.PlayerTime or 0
        local PlayerTimeInHours = math.floor(playtime/60)
        if PlayerTimeInHours < 1 then
            PlayerTimeInHours = 0
        end
        Playtimes[user_id] = PlayerTimeInHours
    else
        PlayerTimeInHours = Playtimes[user_id]
    end
    return PlayerTimeInHours
end




RegisterCommand("staffon", function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.tickets") then
        FRclient.staffMode(source, {true})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "admin.tickets") then
        FRclient.staffMode(source, {false})
    end
end)
RegisterServerEvent('FR:getAdminLevel')
AddEventHandler('FR:getAdminLevel', function()
    local source = source
    local user_id = FR.getUserId(source)
    local adminlevel = 0
    if FR.hasGroup(user_id,"Founder") then
        adminlevel = 12
        TriggerClientEvent("FR:SetDev", source)
    elseif FR.hasGroup(user_id,"Lead Developer") then
        adminlevel = 11
        TriggerClientEvent("FR:SetDev", source)
    elseif FR.hasGroup(user_id,"Operations Manager") then
        adminlevel = 10
        TriggerClientEvent("FR:SetDev", source)
    elseif FR.hasGroup(user_id,"Community Manager") then
        adminlevel = 9
    elseif FR.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 8
    elseif FR.hasGroup(user_id,"Head Administrator") then
        adminlevel = 7
    elseif FR.hasGroup(user_id,"Senior Administrator") then
        adminlevel = 6
    elseif FR.hasGroup(user_id,"Administrator") then
        adminlevel = 5
    elseif FR.hasGroup(user_id,"Senior Moderator") then
        adminlevel = 4
    elseif FR.hasGroup(user_id,"Moderator") then
        adminlevel = 3
    elseif FR.hasGroup(user_id,"Support Team") then
        adminlevel = 2
    elseif FR.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
    end
    TriggerClientEvent("FR:SetStaffLevel", source, adminlevel)
end)
RegisterServerEvent("FR:VerifyDev")
AddEventHandler("FR:VerifyDev", function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') or FR.hasGroup(user_id,"Operations Manager") then
        return
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Attempted to Verify Dev')
    end
end)
RegisterServerEvent("FR:VerifyStaff")
AddEventHandler("FR:VerifyStaff", function(stafflevel)
    local source = source
    local user_id = FR.getUserId(source)
    if stafflevel == 0 then
        return
    elseif FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') or FR.hasGroup(user_id,"Operations Manager") or FR.hasGroup(user_id,"Community Manager") or FR.hasGroup(user_id,"Staff Manager") or FR.hasGroup(user_id,"Head Administrator") or FR.hasGroup(user_id,"Senior Administrator") or FR.hasGroup(user_id,"Administrator") or FR.hasGroup(user_id,"Senior Moderator") or FR.hasGroup(user_id,"Moderator") or FR.hasGroup(user_id,"Support Team") or FR.hasGroup(user_id,"Trial Staff") or user_id == 61 then
        return
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Attempted to Verify Staff')
    end
end)
RegisterNetEvent('FR:zapPlayer')
AddEventHandler('FR:zapPlayer', function(A)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("FR:useTheForceTarget", A)
        for k,v in pairs(FR.getUsers()) do
            TriggerClientEvent("FR:useTheForceSync", v, GetEntityCoords(GetPlayerPed(A)), GetEntityCoords(GetPlayerPed(v)))
        end
    end
end)
function FR.GetAdminLevel(user_id)
    local adminlevel = 0
    if FR.hasGroup(user_id, "Founder") then
        adminlevel = 12
    elseif FR.hasGroup(user_id, "Lead Developer") then
        adminlevel = 11
    elseif FR.hasGroup(user_id, "Operations Manager") then
        adminlevel = 10
    elseif FR.hasGroup(user_id, "Community Manager") then
        adminlevel = 9
    elseif FR.hasGroup(user_id, "Staff Manager") then
        adminlevel = 8
    elseif FR.hasGroup(user_id, "Head Administrator") then
        adminlevel = 7
    elseif FR.hasGroup(user_id, "Senior Administrator") then
        adminlevel = 6
    elseif FR.hasGroup(user_id, "Administrator") then
        adminlevel = 5
    elseif FR.hasGroup(user_id, "Senior Moderator") then
        adminlevel = 4
    elseif FR.hasGroup(user_id, "Moderator") then
        adminlevel = 3
    elseif FR.hasGroup(user_id, "Support Team") then
        adminlevel = 2
    elseif FR.hasGroup(user_id, "Trial Staff") then
        adminlevel = 1
    end

    return adminlevel
end


RegisterNetEvent('FR:theForceSync')
AddEventHandler('FR:theForceSync', function(A, q, r, s)
    local source = source
    if FR.getUserId(source) == 2 then
        TriggerClientEvent("FR:useTheForceSync", A, q, r, s)
        TriggerClientEvent("FR:useTheForceTarget", A)
    end
end)

RegisterCommand("icarwipe", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('FR:clearVehicles', -1)
        TriggerClientEvent('FR:clearBrokenVehicles', -1)
    end 
end)
RegisterCommand("carwipe", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('FR:clearVehicles', -1)
        TriggerClientEvent('FR:clearBrokenVehicles', -1)
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)  -- Wait for 5 minutes (300,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)  -- Wait for 10 seconds (10,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('FR:clearVehicles', -1)
        TriggerClientEvent('FR:clearBrokenVehicles', -1)
    end
end)


RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.managecommunitypot') then
        FR.setBucket(source, tonumber(args[1]))
        FRclient.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
    end 
end)

RegisterCommand("openurl", function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id == 0 or user_id == -1 then
        local permid = tonumber(args[1])
        local data = args[2]
        FRclient.OpenUrl(FR.getUserSource(permid), {'https://'..data})
    end 
end)

RegisterCommand("clipboard", function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'group.remove') then
        local permid = tonumber(args[1])
        table.remove(args, 1)
        local msg = table.concat(args, " ")
        FRclient.CopyToClipBoard(FR.getUserSource(permid), {msg})
    end 
end)

RegisterCommand("staffdm", function(source, args)
    local sourcePlayer = source
    local user_id = FR.getUserId(sourcePlayer)

    if FR.hasPermission(user_id, 'admin.tickets') then
        local targetPlayerId = tonumber(args[1])
        local message = table.concat(args, " ", 2)
        if targetPlayerId and message then
            local targetPlayerSource = FR.getUserSource(targetPlayerId)

            if targetPlayerSource then
                FR.sendWebhook('staffdm',"FR Staff DM Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(targetPlayerSource).."**\n> Player PermID: **"..targetPlayerId.."**\n> Player TempID: **"..targetPlayerSource.."**\n> Message: **"..message.."**")
                TriggerClientEvent('FR:StaffDM', targetPlayerSource, message)
            else
                FRclient.notify(sourcePlayer, {'~r~Player is not online.'})
            end
        end
    else
        FRclient.notify(sourcePlayer, {'~r~You do not have permission to use this command.'})
    end
end)


RegisterNetEvent("FR:GetTicketLeaderboard")
AddEventHandler("FR:GetTicketLeaderboard", function(state)
    local source = source
    local user_id = FR.getUserId(source)
    if state then
        exports['fr']:execute("SELECT * FROM fr_staff_tickets WHERE user_id = @user_id", {user_id = user_id}, function(result)
            if result ~= nil then
                TriggerClientEvent('FR:GotTicketLeaderboard', source, result)
            end
        end)
    else
        exports['fr']:execute("SELECT * FROM fr_staff_tickets ORDER BY ticket_count DESC LIMIT 10", {}, function(result)
            if result ~= nil then
                TriggerClientEvent('FR:GotTicketLeaderboard', source, result)
            end
        end)
    end
end)
