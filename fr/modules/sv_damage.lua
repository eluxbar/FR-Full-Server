local headshots = {}

RegisterNetEvent("FR:syncEntityDamage")
AddEventHandler("FR:syncEntityDamage", function(u, v, t, s, m, n) -- s head
    local source = source
    local user_id = FR.getUserId(source)
    local user_id2 = FR.getUserId(t)
    if user_id2 then
        if not headshots[user_id2] then
            headshots[user_id2] = {headshots = 0, bodyshots = 0}
        end
        if s then
            headshots[user_id2].headshots = headshots[user_id2].headshots + 1
        else
            headshots[user_id2].bodyshots = headshots[user_id2].bodyshots + 1
        end
    end
    TriggerClientEvent('FR:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
end)



AddEventHandler("FR:playerLeave", function(user_id, source)
    if headshots[user_id] then
        local totalShots = headshots[user_id].headshots + headshots[user_id].bodyshots
        local headshotPercentage = math.floor((headshots[user_id].headshots / totalShots) * 100)
        FR.sendWebhook('headshot', "FR HS % Logs", "> Players Perm ID: **"..user_id.."**\n> Total Shots Hit: **"..totalShots.."**\n> Total Headshots: **"..headshots[user_id].headshots.."**\n> Total Headshot Percentage: **"..headshotPercentage.."%**\n> Please keep in mind that these are logs. Please investigate further into high headshot percentages.")
        headshots[user_id] = nil
    end
end)