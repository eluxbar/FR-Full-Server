RegisterServerEvent("FR:getCommunityPotAmount")
AddEventHandler("FR:getCommunityPotAmount", function()
    local source = source
    local user_id = FR.getUserId(source)
    exports['fr']:execute("SELECT value FROM fr_community_pot", function(potbalance)
        if potbalance[1] then
            TriggerClientEvent('FR:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
        else
            print("ERROR: No value for fr_community_pot")
        end
    end)    
end)

RegisterServerEvent("FR:tryDepositCommunityPot")
AddEventHandler("FR:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['fr']:execute("SELECT value FROM fr_community_pot", function(potbalance)
            if FR.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['fr']:execute("UPDATE fr_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('FR:gotCommunityPotAmount', source, newpotbalance)
                FR.sendWebhook('com-pot', 'FR Community Pot Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("FR:tryWithdrawCommunityPot")
AddEventHandler("FR:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['fr']:execute("SELECT value FROM fr_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['fr']:execute("UPDATE fr_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('FR:gotCommunityPotAmount', source, newpotbalance)
                FR.giveMoney(user_id, amount)
                FR.sendWebhook('com-pot', 'FR Community Pot Logs', "> Admin Name: **"..FR.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("FR:addToCommunityPot")
AddEventHandler("FR:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['fr']:execute("SELECT value FROM fr_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['fr']:execute("UPDATE fr_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)

function getMoneyStringFormatted(cashString)
    local i, j, minus, int = tostring(cashString):find('([-]?)(%d+)%.?%d*')
    
    if int == nil then 
        return cashString
    else
        -- reverse the int-string and append a comma to all blocks of 3 digits
        int = int:reverse():gsub("(%d%d%d)", "%1,")
  
        -- reverse the int-string back, remove an optional comma, and put the optional minus back
        return minus .. int:reverse():gsub("^,", "")
    end
  end
  