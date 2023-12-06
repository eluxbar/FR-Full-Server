RegisterCommand("a", function(source,args, rawCommand)
    if #args <= 0 then return end
	local name = FR.getPlayerName(source)
    local message = table.concat(args, " ")
    local user_id = FR.getUserId(source)

    if FR.hasPermission(user_id, "admin.tickets") then
        FR.sendWebhook('staff', "FR Chat Logs", "```"..message.."```".."\n> Admin Name: **"..name.."**\n> Admin PermID: **"..user_id.."**\n> Admin TempID: **"..source.."**")
        for k, v in pairs(FR.getUsers({})) do
            if FR.hasPermission(k, 'admin.tickets') then
                TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. name..": " , { 128, 128, 128 }, message, "ooc")
            end
        end
    end
end)
RegisterServerEvent("FR:PoliceChat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = FR.getUserId(source)   
    local message = args
    if FR.hasPermission(user_id, "police.armoury") then
        local callsign = ""
        if getCallsign('Police', source, user_id, 'Police') then
            callsign = "["..getCallsign('Police', source, user_id, 'Police').."]"
        end
        local playerName =  "^4Police Chat | "..callsign.." "..FR.getPlayerName(source)..": "
        for k, v in pairs(FR.getUsers({})) do
            if FR.hasPermission(k, 'police.armoury') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "Police")
            end
        end
    end
end)

RegisterCommand("p", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("FR:PoliceChat", source, message)
end)
RegisterServerEvent("FR:Nchat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = FR.getUserId(source)   
    local message = args
    if FR.hasPermission(user_id, "nhs.menu") then
        local playerName =  "^2NHS Chat | "..FR.getPlayerName(source)..": "
        for k, v in pairs(FR.getUsers({})) do
            if FR.hasPermission(k, 'nhs.menu') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "NHS")
            end
        end
    end
end)
RegisterCommand("n", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("FR:Nchat", source, message)
end)

RegisterCommand("g", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("FR:GangChat", source, message)
end)
RegisterServerEvent("FR:GangChat", function(source, message)
    local source = source
    local user_id = FR.getUserId(source)   
    local msg = message
    if FR.hasGroup(user_id,"Gang") then
        local gang = exports['fr']:executeSync('SELECT gangname FROM fr_user_gangs WHERE user_id = @user_id', {user_id = user_id})[1].gangname
        if gang then
            exports["fr"]:execute("SELECT * FROM fr_user_gangs WHERE gangname = @gangname", {gangname = gang},function(ganginfo)
                for A,B in pairs(ganginfo) do
                    local playersource = FR.getUserSource(B.user_id)
                    if playersource then
                        TriggerClientEvent('chatMessage',playersource,"^2[Gang Chat] " .. FR.getPlayerName(source)..": ",{ 128, 128, 128 },msg,"ooc", "Gang")
                    end
                end
                FR.sendWebhook('gang', "FR Chat Logs", "```"..msg.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
            end)
        end
    end
end)

