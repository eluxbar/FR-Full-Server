local chatCooldown = {}
local lastmsg = nil
local blockedWords = {
    "nigger",
    "nigga",
    "wog",
    "coon",
    "paki",
    "faggot",
    "anal",
    "kys",
    "homosexual",
    "lesbian",
    "suicide",
    "negro",
    "queef",
    "queer",
    "allahu akbar",
    "terrorist",
    "wanker",
    "n1gger",
    "f4ggot",
    "n0nce",
    "d1ck",
    "h0m0",
    "n1gg3r",
    "h0m0s3xual",
    "nazi",
    "hitler",
	"fag",
	"fa5",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		for k,v in pairs(chatCooldown) do
			chatCooldown[k] = nil
		end
	end
end)

RegisterCommand("anon", function(source, args)
	local message = table.concat(args, " ")
	TriggerEvent("FR:Anon", message)
end)

--Dispatch Message
RegisterServerEvent("FR:Anon", function(source, args)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = FR.getPlayerName(source)
    local message = args
	local user_id = FR.getUserId(source)
	if name then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('FR:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		FR.sendWebhook('anon', "FR Chat Logs", "```"..message.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
		TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 128, 128, 128 }, message, "ooc", "Anonymous")	
	end
end)

function FR.ooc(source, args, raw)
	if #args <= 0 then 
		return 
	end
	local source = source
	local name = FR.getPlayerName(source)
	local message = args
	local user_id = FR.getUserId(source)
	if not chatCooldown[source] then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(args:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('FR:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		if FR.hasGroup(user_id, "Founder") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif FR.hasGroup(user_id, "Lead Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Lead Developer ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif FR.hasGroup(user_id, "Operations Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Operations Manager ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif FR.hasGroup(user_id, "Community Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Community Manager ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Staff Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Staff Manager ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Head Administrator") and user_id ~= 61 then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Administrator ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Senior Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Administrator ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "OOC")	
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")			
			chatCooldown[source] = true			
		elseif FR.hasGroup(user_id, "Senior Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Senior Moderator ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Support Team") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Trial Staff") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Baller") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^3" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Rainmaker") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^4" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Kingpin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^1" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Supreme") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^5" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Premium") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^6" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif FR.hasGroup(user_id, "Supporter") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^2" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^7" .. FR.getPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		end
		FR.sendWebhook('ooc', "FR Chat Logs", "```"..message.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	else
		TriggerClientEvent('chatMessage', source, "^1[FR]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert", "OOC")
		chatCooldown[source] = true
	end
end
RegisterServerEvent("FR:ooc", function(source, args)
	FR.ooc(source, args)
end)

RegisterCommand("ooc", function(source, args, raw)
    local message = table.concat(args, " ")
    FR.ooc(source, message)
end)

RegisterCommand("/", function(source, args, raw)
	local message = table.concat(args, " ")
	message = message:sub(1)
    FR.ooc(source, message)
end)





RegisterCommand('cc', function(source, args, rawCommand)
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.ban') then
        TriggerClientEvent('chat:clear',-1)             
    end
end, false)


RegisterServerEvent("FR:TwitterLogs")
AddEventHandler("FR:TwitterLogs", function(source,message)
	local user_id = FR.getUserId(source)
	FR.sendWebhook("twitter", "FR Chat Logs", "```"..message.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
end)
--Function
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- RegisterCommand("verify", function(source,args,raw)
--     local source = source
--     if source ~= 0 then
--         local user_id = FR.getUserId(source)
--     end
--     if user_id == 1 or user_id == 1 or source == 0 then
--         print("Verifying")
--         local code = args[1]
--         local discord_id = args[2]
--         print(code, discord_id)
--         exports["fr"]:execute("SELECT * FROM fr_verification WHERE code = @code",{code = code}, function(result)
--             if result[1] ~= nil then
--                 print("Code Found")
--                 local user_id = result[1].user_id
--                 exports["fr"]:execute("UPDATE fr_verification SET verified = @verified WHERE code = @code",{verified = 1, code = code})
--                 exports["fr"]:execute("UPDATE fr_verification SET discord_id = @discord_id WHERE code = @code",{discord_id = discord_id, code = code})
--                 if source ~= 0 then
--                     print("Verified\nCode: "..code.."\nDiscord ID: "..discord_id)
--                     FRClient.notify(source, "Verified\nCode: "..code.."\nDiscord ID: "..discord_id)
--                 else
--                     print("Verified\nCode: "..code.."\nDiscord ID: "..discord_id)
--                 end
--             else
--                 if source ~= 0 then
--                     FRClient.notify(source, "Invalid Code")
--                 else
--                     print("Invalid Code")
--                 end
--             end
--         end)
--     end
-- end)
-- RegisterCommand("clearbans", function(source,args,raw)
--     local source = source
--     if source == 0 then
--         exports["fr"]:execute("SELECT * FROM fr_users WHERE banned = 1 && banreason = ", {}, function(result)
--             if #result > 0 then
--                 for k,v in pairs(result) do
--                     print(v.id)
--                     FR.setBanned(v.id,false)
--                     print("Unbanned "..v.id)
--                 end
--             end
--          end)
--     end
-- end)
-- RegisterCommand("unbanplayers", function(source,args,raw)
--     local source = source
--     if source == 0 then
--         exports["fr"]:execute("SELECT * FROM fr_users WHERE banned = 1", {}, function(result)
--             if #result > 0 then
--                 for k,v in pairs(result) do
--                     print(v.id)
--                     FR.setBanned(v.id,false)
--                     print("Unbanned "..v.id)
--                 end
--             end
--          end)
--     end
-- end)
-- RegisterCommand("unbans", function(source,args,raw)
--     local source = source
--     if source == 0 then
--         if args[1] == nil then
--             print("Please provide a ban reason")
--             return
--         end
--         exports["fr"]:execute("SELECT * FROM fr_users WHERE banned = 1 && banreason = @banreason", {banreason = args[1]}, function(result)
--             if #result > 0 then
--                 for k,v in pairs(result) do
--                     print(v.id)
--                     FR.setBanned(v.id,false)
--                     print("Unbanned "..v.id)
--                 end
--             end
--          end)
--     end

RegisterCommand("moneywipe", function(source, args, raw)
    local source = source
    if source ~= 0 then
        local user_id = FR.getUserId(source)
    end
    if user_id == 1 or user_id == 0 or source == 0 then
        print("Setting bank to 50000000 for all users")

        exports["fr"]:execute("UPDATE fr_user_moneys SET bank = @new_bank_value", {new_bank_value = 250000}, function(result)
            if source ~= 0 then
                print("Bank set to 50000000 for all users")
                FRClient.notify(source, "Bank set to 50000000 for all users")
            else
                print("Bank set to 50000000 for all users")
            end
        end)
    end
end)
function cleanMessage(message)
	local replacements = {
	  [" "] = "",
	  ["-"] = "",
	  ["."] = "",
	  ["$"] = "s",
	  ["€"] = "e",
	  [","] = "",
	  [";"] = "",
	  [":"] = "",
	  ["*"] = "",
	  ["_"] = "",
	  ["|"] = "",
	  ["/"] = "",
	  ["<"] = "",
	  [">"] = "",
	  ["ß"] = "ss",
	  ["&"] = "",
	  ["+"] = "",
	  ["¦"] = "",
	  ["§"] = "s",
	  ["°"] = "",
	  ["#"] = "",
	  ["@"] = "a",
	  ["\""] = "",
	  ["("] = "",
	  [")"] = "",
	  ["="] = "",
	  ["?"] = "",
	  ["!"] = "",
	  ["´"] = "",
	  ["`"] = "",
	  ["'"] = "",
	  ["^"] = "",
	  ["~"] = "",
	  ["["] = "",
	  ["]"] = "",
	  ["{"] = "",
	  ["}"] = "",
	  ["£"] = "e",
	  ["¨"] = "",
	  ["ç"] = "c",
	  ["¬"] = "",
	  ["\\"] = "",
	  ["1"] = "i",
	  ["3"] = "e",
	  ["4"] = "a",
	  ["5"] = "s",
	  ["0"] = "o"
	}
  
	local finalmessage = message:lower()
	finalmessage = finalmessage:gsub(".", function(c)
	  return replacements[c] or c
	end)
  
	return finalmessage
  end


-- RegisterCommand("resetbanned", function(source, args, raw)
--     if source ~= 0 then
--         print("Resetting 'banned' to 0 for users with 'banned' value not equal to 1")

--         exports["fr"]:execute("UPDATE fr_user_ids SET banned = 0 WHERE banned != 1", {}, function(result)
--             if source ~= 0 then
--                 print("Banned status reset to 0 for eligible users")
--                 FRClient.notify(source, "Banned status reset to 0 for eligible users")
--             else
--                 print("Banned status reset to 0 for eligible users")
--             end
--         end)
--     end

