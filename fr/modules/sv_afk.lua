function getPlayerFaction(user_id)
    if FR.hasPermission(user_id, 'police.armoury') then
        return 'pd'
    elseif FR.hasPermission(user_id, 'nhs.menu') then
        return 'nhs'
    elseif FR.hasPermission(user_id, 'hmp.menu') then
        return 'hmp'
    elseif FR.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('FR:factionAfkAlert')
AddEventHandler('FR:factionAfkAlert', function(text)
    local source = source
    local user_id = FR.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        FR.sendWebhook(getPlayerFaction(user_id)..'-afk', 'FR AFK Logs', "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('FR:setNoLongerAFK')
AddEventHandler('FR:setNoLongerAFK', function()
    local source = source
    local user_id = FR.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        FR.sendWebhook(getPlayerFaction(user_id)..'-afk', 'FR AFK Logs', "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = FR.getUserId(source)
    if not FR.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)