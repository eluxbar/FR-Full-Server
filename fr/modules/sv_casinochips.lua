MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO fr_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM fr_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE fr_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE fr_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = FR.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("FR:enterDiamondCasino")
AddEventHandler("FR:enterDiamondCasino", function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('FR:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("FR:exitDiamondCasino")
AddEventHandler("FR:exitDiamondCasino", function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.setBucket(source, 0)
end)

RegisterNetEvent("FR:getChips")
AddEventHandler("FR:getChips", function()
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('FR:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("FR:buyChips")
AddEventHandler("FR:buyChips", function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    if not amount then amount = FR.getBankMoney(user_id) end
    if FR.tryBankPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('FR:chipsUpdated', source)
        FR.sendWebhook('purchase-chips',"FR Chip Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        FRclient.notify(source,{"You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("FR:sellChips")
AddEventHandler("FR:sellChips", function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('FR:chipsUpdated', source)
                    FR.sendWebhook('sell-chips',"FR Chip Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    FR.giveBankMoney(user_id, amount)
                else
                    FRclient.notify(source,{"You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)