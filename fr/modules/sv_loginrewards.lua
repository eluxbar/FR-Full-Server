local cfg = module("cfg/cfg_loginrewards")

MySQL.createCommand("dailyrewards/set_reward_time","UPDATE fr_daily_rewards SET last_reward = @last_reward WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/set_reward_streak","UPDATE fr_daily_rewards SET streak = @streak WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_time","SELECT last_reward FROM fr_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_streak","SELECT streak FROM fr_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/add_id", "INSERT IGNORE INTO fr_daily_rewards SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = FR.getUserId(source)
    MySQL.execute("dailyrewards/add_id", {user_id = user_id})
end)

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("dailyrewards/get_reward_time", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                if rows[1].last_reward ~= nil then
                    local x = rows[1].last_reward
                    local y = os.time()
                    local streak = 0
                    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
                        if #rows > 0 then
                            if rows[1].streak > 0 and y - 86400*2 > x then
                                streak = 0
                            else
                                streak = rows[1].streak
                            end
                        end
                        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                        TriggerClientEvent('FR:setDailyRewardInfo', source, streak, x,y)
                        return
                    end)
                end
            end
        end)
    end
end)



RegisterNetEvent("FR:claimNextLoginReward")
AddEventHandler("FR:claimNextLoginReward", function()
    local source = source
    local user_id = FR.getUserId(source)
    local streak = 0
    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            streak = rows[1].streak+1
        end
        for k,v in pairs(cfg.rewards) do
            if v.day == streak then
                if v.money then
                    FR.giveBankMoney(user_id, v.item)
                    TriggerClientEvent('FR:smallAnnouncement', source, 'login reward', "You have claimed £"..getMoneyStringFormatted(v.item).." from the login reward!", 33, 10000)
                else
                    if string.find(v.name, "Key") then
                        exports['fr']:execute('SELECT ?? FROM fr_crates WHERE user_id = ?', { key, user_id }, function(result)
                            if result and result[1] then    
                                local keys = result[1][key]
                                keys = tonumber(keys) or 0
                                keys = keys + amount
                                exports['fr']:execute('UPDATE fr_crates SET ?? = ? WHERE user_id = ?', { key, keys, user_id })
                            end
                        end)
                        ForceRefresh(user_id)
                    else
                        local first, second = generateUUID("Items", 4, "alphanumeric"), generateUUID("Items", 4, "alphanumeric")
                        local code = string.upper(first .. "-" .. second)
                        local currentDate = os.date("%d/%m/%Y")
                        exports['fr']:execute("INSERT INTO fr_stores (code, item, user_id, date) VALUES (@code, @item, @user_id, @date)", {code = code, item = v.item, user_id = user_id, date = currentDate})
                    end
                    TriggerClientEvent('FR:smallAnnouncement', source, 'login reward', "You have claimed a "..v.name.." from the login reward!", 33, 10000)
                end
                MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
                return
            end
        end
        FR.giveBankMoney(user_id, 150000)
        TriggerClientEvent('FR:smallAnnouncement', source, 'login reward', "You have claimed £150,000 from the login reward!", 33, 10000)
        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
        MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
    end)
end)
