function getCallsign(guildType, source, user_id, type)
    local discord_id = exports['fr']:Get_Client_Discord_ID(source)
    if discord_id then
        local guilds_info = exports['fr']:Get_Guilds()
        for guild_name, guild_id in pairs(guilds_info) do
            if guild_name == guildType then
                local nick_name = exports['fr']:Get_Guild_Nickname(guild_id, discord_id)
                if nick_name then
                    local open_bracket = string.find(nick_name, '[', nil, true)
                    local closed_bracket = string.find(nick_name, ']', nil, true)
                    if open_bracket and closed_bracket then
                        local callsign_value = string.sub(nick_name, open_bracket + 1, closed_bracket - 1)
                        return callsign_value, string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), FR.getPlayerName(source)
                    else
                        return 'N/A', string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), FR.getPlayerName(source)
                    end
                end
            end
        end
    end
end

RegisterServerEvent("FR:getCallsign")
AddEventHandler("FR:getCallsign", function(type)
    local source = source
    local user_id = FR.getUserId(source)
    Wait(1000)
    if type == 'police' and FR.hasPermission(user_id, 'police.armoury') then
        if getCallsign('Police', source, user_id, 'Police') then
            TriggerClientEvent("FR:receivePoliceCallsign", source, getCallsign('Police', source, user_id, 'Police'))
        end
        TriggerClientEvent("FR:setPoliceOnDuty", source, true)
    elseif type == 'prison' and FR.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("FR:receiveHmpCallsign", source, getCallsign('HMP', source, user_id, 'HMP'))
        TriggerClientEvent("FR:setPrisonGuardOnDuty", source, true)
    end
end)
