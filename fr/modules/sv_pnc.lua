MySQL.createCommand("FR/add_jail_stats","UPDATE fr_fine_hours SET total_player_fined = (total_player_fined+1) WHERE user_id = @user_id")

RegisterServerEvent('FR:checkForPolicewhitelist')
AddEventHandler('FR:checkForPolicewhitelist', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        if FR.hasPermission(user_id, 'police.announce') then
            TriggerClientEvent('FR:openPNC', source, true, {}, {})
        else
            TriggerClientEvent('FR:openPNC', source, false, {}, {})
        end
    end
end)

RegisterServerEvent('FR:searchPerson')
AddEventHandler('FR:searchPerson', function(firstname, lastname)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        exports['fr']:execute("SELECT * FROM fr_user_identities WHERE firstname = @firstname AND name = @lastname", {firstname = firstname, lastname = lastname}, function(result) 
            if result ~= nil then
                local returnedUsers = {}
                for k,v in pairs(result) do
                    local user_id = result[k].user_id
                    local firstname = result[k].firstname
                    local lastname = result[k].name
                    local age = result[k].age
                    local phone = result[k].phone
                    local data = exports['fr']:executeSync("SELECT * FROM fr_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    local licence = data.licence
                    local points = data.points
                    local ownedVehicles = exports['fr']:executeSync("SELECT * FROM fr_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
                    local actualVehicles = {}
                    for a,b in pairs(ownedVehicles) do 
                        table.insert(actualVehicles, b.vehicle)
                    end
                    local ownedProperties = exports['fr']:executeSync("SELECT * FROM fr_user_homes WHERE user_id = @user_id", {user_id = user_id})
                    local actualHouses = {}
                    for a,b in pairs(ownedProperties) do 
                        table.insert(actualHouses, b.home)
                    end
                    table.insert(returnedUsers, {user_id = user_id, firstname = firstname, lastname = lastname, age = age, phone = phone, licence = licence, points = points, vehicles = actualVehicles, playerhome = actualHouses, warrants = {}, warning_markers = {}})
                end
                if next(returnedUsers) then
                    TriggerClientEvent('FR:sendSearcheduser', source, returnedUsers)
                else
                    TriggerClientEvent('FR:noPersonsFound', source)
                end
            end
        end)
    end
end)

RegisterServerEvent('FR:finePlayer')
AddEventHandler('FR:finePlayer', function(id, charges, amount, notes)
    local source = source
    local user_id = FR.getUserId(source)
    local amountNum = tonumber(amount)
    
    if amountNum > 250000 then
        amountNum = 250000
    end
    
    if next(charges) then
        local chargesList = ""
        for k, v in pairs(charges) do
            chargesList = chargesList .. "\n> - **" .. v.fine .. "**"
        end
        
        if FR.hasPermission(user_id, 'police.armoury') then
            if id == user_id then
                TriggerClientEvent('FR:verifyFineSent', source, false, "Can't fine yourself!")
                return
            end
            
            if FR.tryBankPayment(id, amountNum) then
                local officerReward = math.floor(amountNum * 0.1)
                FR.giveBankMoney(user_id, officerReward)
                FRclient.notify(FR.getUserSource(id), {'You have been fined £' .. getMoneyStringFormatted(amountNum) .. '.'})
                FRclient.notify(source, {'~g~You have received £' .. getMoneyStringFormatted(officerReward) .. ' for fining ' .. FR.getPlayerName(FR.getUserSource(id)) .. '.'})
                TriggerEvent('FR:addToCommunityPot', amountNum)
                TriggerClientEvent('FR:verifyFineSent', source, true)
                
                local criminalName = FR.getPlayerName(FR.getUserSource(id))
                local criminalPermID = id
                local criminalTempID = FR.getUserSource(id)
                local formattedAmount = '£' .. getMoneyStringFormatted(amountNum)
                
                exports['fr']:execute("SELECT * FROM `fr_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.user_id == user_id then
                                exports['fr']:execute("UPDATE fr_police_hours SET total_players_fined = @total_players_fined WHERE user_id = @user_id", {user_id = user_id, total_players_fined = v.total_players_fined + 1}, function() end)
                                return
                            end
                        end
                        exports['fr']:execute("INSERT INTO fr_police_hours (`user_id`, `total_players_fined`, `username`) VALUES (@user_id, @total_players_fined, @username);", {user_id = user_id, total_players_fined = 1}, function() end) 
                    end
                end)
                FR.sendWebhook('fine-player', 'FR Fine Logs', "> Officer Name: **" .. FR.getPlayerName(source) .. "**\n> Officer TempID: **" .. source .. "**\n> Officer PermID: **" .. user_id .. "**\n> Criminal Name: **" .. criminalName .. "**\n> Criminal PermID: **" .. criminalPermID .. "**\n> Criminal TempID: **" .. criminalTempID .. "**\n> Amount: **" .. formattedAmount .. "**\n> Charges: " .. chargesList)
            else
                TriggerClientEvent('FR:verifyFineSent', source, false, 'The player does not have enough money.')
            end
        end
    end
end)


RegisterServerEvent('FR:addPoints')
AddEventHandler('FR:addPoints', function(points, id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        -- FRclient.notify(FR.getUserSource(id), {'You have received '..points..' on your licence.'})
        -- exports['fr']:execute("UPDATE fr_dvsa SET points = points+@newpoints WHERE user_id = @user_id", {user_id = id, newpoints = points})
        -- exports['fr']:execute('SELECT * FROM fr_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(licenceInfo)
        --     local licenceType = licenceInfo[1].licence
        --     local points = json.decode(licenceInfo[1].points)
        --     if (licenceType == "active" or licenceType == "full") and points > 12 then
        --         exports['fr']:execute("UPDATE fr_dvsa SET licence = 'banned' WHERE user_id = @user_id", {user_id = id})
        --         Wait(100)
        --         dvsaUpdate(user_id)
        --     end
        -- end)
    end
end)


RegisterCommand('testad', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id == 1 then
        TriggerClientEvent('FR:notifyAD', source, 'Phase 3 Firearms', 'Red Vauxhall Corsa')
    end
end)