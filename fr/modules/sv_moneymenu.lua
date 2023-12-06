RegisterServerEvent("FR:getUserinformation")
AddEventHandler("FR:getUserinformation",function(id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('FR:receivedUserInformation', source, FR.getUserSource(id), FR.getPlayerName(FR.getUserSource(id)), math.floor(FR.getBankMoney(id)), math.floor(FR.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("FR:ManagePlayerBank")
AddEventHandler("FR:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local userstemp = FR.getUserSource(id)
    if user_id == 61 then
        FRclient.notify(source, {"No Watt Skill"})
        return
    end
    if FR.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            FR.giveBankMoney(id, amount)
            FRclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            FR.tryBankPayment(id, amount)
            FRclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('FR:receivedUserInformation', source, FR.getUserSource(id), FR.getPlayerName(FR.getUserSource(id)), math.floor(FR.getBankMoney(id)), math.floor(FR.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("FR:ManagePlayerCash")
AddEventHandler("FR:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local userstemp = FR.getUserSource(id)
    if user_id == 61 then
        FRclient.notify(source, {"No Watt Skill"})
        return
    end
    if FR.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            FR.giveMoney(id, amount)
            FRclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            FR.tryPayment(id, amount)
            FRclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('FR:receivedUserInformation', source, FR.getUserSource(id), FR.getPlayerName(FR.getUserSource(id)), math.floor(FR.getBankMoney(id)), math.floor(FR.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("FR:ManagePlayerChips")
AddEventHandler("FR:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local userstemp = FR.getUserSource(id)
    if user_id == 61 then
        FRclient.notify(source, {"No Watt Skill"})
        return
    end
    if FR.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            FRclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('FR:receivedUserInformation', source, FR.getUserSource(id), FR.getPlayerName(FR.getUserSource(id)), math.floor(FR.getBankMoney(id)), math.floor(FR.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            FRclient.notify(source, {'Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            FR.sendWebhook('manage-balance',"FR Money Menu Logs", "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..FR.getPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('FR:receivedUserInformation', source, FR.getUserSource(id), FR.getPlayerName(FR.getUserSource(id)), math.floor(FR.getBankMoney(id)), math.floor(FR.getMoney(id)), chips)
                end
            end)
        end
    end
end)