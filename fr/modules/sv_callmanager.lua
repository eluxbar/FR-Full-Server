local tickets = {}
local callID = 0
local cooldown = {}
local permid = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = FR.getUserId(source)
    local user_source = FR.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            FRclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    FR.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = FR.getPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(FR.getUsers({})) do
                    TriggerClientEvent("FR:addEmergencyCall", v, callID, FR.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                FRclient.notify(user_source,{"~b~Your request has been sent."})
            else
                FRclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            FRclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)
RegisterCommand("calladmin", function(source)
    local user_id = FR.getUserId(source)
    local user_source = FR.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            FRclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    FR.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = FR.getPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(FR.getUsers({})) do
                    TriggerClientEvent("FR:addEmergencyCall", v, callID, FR.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                FRclient.notify(user_source,{"~b~Your request has been sent."})
            else
                FRclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            FRclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = FR.getUserId(source)
    local user_source = FR.getUserSource(user_id)
    FR.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = FR.getPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(FR.getUsers({})) do
                TriggerClientEvent("FR:addEmergencyCall", v, callID, FR.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            FRclient.notify(user_source,{"~b~Sent Police Call."})
        else
            FRclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = FR.getUserId(source)
    local user_source = FR.getUserSource(user_id)
    FR.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = FR.getPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(FR.getUsers({})) do
                TriggerClientEvent("FR:addEmergencyCall", v, callID, FR.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            FRclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            FRclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        TriggerEvent('FR:Return', source)
    end
end)
local adminFeedback = {} 
AddEventHandler("FR:Return", function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.tickets') then
        local v = adminFeedback[user_id]
        if savedPositions[user_id] then
            FR.setBucket(source, savedPositions[user_id].bucket)
            FRclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            FRclient.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            FRclient.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('FR:sendTicketInfo', source)
        FRclient.staffMode(source, {false})
        SetTimeout(1000, function() 
            FRclient.setPlayerCombatTimer(source, {0}) 
        end)
    end
end)

RegisterNetEvent("FR:TakeTicket")
AddEventHandler("FR:TakeTicket", function(ticketID)
    local user_id = FR.getUserId(source)
    local admin_source = FR.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and FR.hasPermission(user_id, "admin.tickets") then
                    if FR.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local tempID = v.tempID
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                FR.setBucket(admin_source, playerbucket)
                                FRclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            FRclient.getPosition(v.tempID, {}, function(coords)
                                FRclient.staffMode(admin_source, {true})
                                adminFeedback[user_id] = {playersource = tempID, ticketID = ticketID}
                                TriggerClientEvent('FR:sendTicketInfo', admin_source, v.permID, v.name, v.reason)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                    ticketPay = 30000
                                else
                                    ticketPay = 20000
                                end
                                exports['fr']:execute("SELECT * FROM `fr_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                    if result ~= nil then 
                                        for k,v in pairs(result) do
                                            if v.user_id == user_id then
                                                exports['fr']:execute("UPDATE fr_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = FR.getPlayerName(admin_source)}, function() end)
                                                return
                                            end
                                        end
                                        exports['fr']:execute("INSERT INTO fr_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = FR.getPlayerName(admin_source)}, function() end) 
                                    end
                                end)
                                FR.giveBankMoney(user_id, ticketPay)
                                FRclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for taking a ticket."})
                                FRclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                TriggerClientEvent('FR:smallAnnouncement', v.tempID, 'ticket accepted', "Your admin ticket has been accepted by "..FR.getPlayerName(admin_source), 33, 10000)
                                FR.sendWebhook('ticket-logs',"FR Ticket Logs", "> Admin Name: **"..FR.getPlayerName(admin_source).."**\n> Admin TempID: **"..admin_source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..v.name.."**\n> Player PermID: **"..v.permID.."**\n> Player TempID: **"..v.tempID.."**\n> Reason: **"..v.reason.."**")
                                FRclient.teleport(admin_source, {table.unpack(coords)})
                                TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                                tickets[ticketID] = nil
                            end)
                        else
                            FRclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        FRclient.notify(admin_source,{"You cannot take a ticket from an offline player."})
                        TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and FR.hasPermission(user_id, "police.armoury") then
                    if FR.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                FRclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                        else
                            FRclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and FR.hasPermission(user_id, "nhs.menu") then
                    if FR.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            FRclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                        else
                            FRclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("FR:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

RegisterNetEvent("FR:PDRobberyCall")
AddEventHandler("FR:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = FR.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(FR.getUsers({})) do
        TriggerClientEvent("FR:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("FR:NHSComaCall")
AddEventHandler("FR:NHSComaCall", function()
    local user_id = FR.getUserId(source)
    local user_source = FR.getUserSource(user_id)
    if FR.getUsersByPermission("nhs.menu") == nil then
        FRclient.notify(user_source,{"~r~There are no NHS on duty."})
        return
    end
    FRclient.notify(user_source,{"~g~NHS have been notified."})
    callID = callID + 1
    tickets[callID] = {
        name = FR.getPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        reason = "Immediate Attention",
        type = 'nhs'
    }
    for k, v in pairs(FR.getUsers({})) do
        TriggerClientEvent("FR:addEmergencyCall", v, callID, FR.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
    end
end)