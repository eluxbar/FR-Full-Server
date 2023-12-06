local coinflipTables = {
    [1] = false,
    [2] = false,
    [5] = false,
    [6] = false,
}

local linkedTables = {
    [1] = 2,
    [2] = 1,
    [5] = 6,
    [6] = 5,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = FR.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('FR:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
            coinflipGameData[k] = nil
        end
    end
end)

RegisterNetEvent("FR:requestCoinflipTableData")
AddEventHandler("FR:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("FR:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("FR:requestSitAtCoinflipTable")
AddEventHandler("FR:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        local currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("FR:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("FR:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("FR:leaveCoinflipTable")
AddEventHandler("FR:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("FR:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("FR:proposeCoinflip")
AddEventHandler("FR:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = FR.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            TriggerClientEvent('FR:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('FR:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('FR:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            FRclient.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            FRclient.notify(source,{"Not enough chips!"})
                        end
                    end)
                else
                    FRclient.notify(source,{'Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       FRclient.notify(source,{"Error betting!"})
    end
end)

RegisterNetEvent("FR:requestCoinflipTableData")
AddEventHandler("FR:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("FR:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("FR:cancelCoinflip")
AddEventHandler("FR:cancelCoinflip", function()   
    local source = source
    local user_id = FR.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("FR:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("FR:acceptCoinflip")
AddEventHandler("FR:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = FR.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('FR:chipsUpdated', source)
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('FR:chipsUpdated', FR.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = FR.getPlayerName(source), loser = FR.getPlayerName(FR.getUserSource(v.user_id))}
                        TriggerClientEvent('FR:coinflipOutcome', source, true, game)
                        TriggerClientEvent('FR:coinflipOutcome', FR.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('FR:chipsUpdated', source)
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..FR.getPlayerName(source).." has WON a coin flip against "..FR.getPlayerName(FR.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!")
                        end
                        FR.sendWebhook('coinflip-bet',"FR Coinflip Logs", "> Winner Name: **"..FR.getPlayerName(source).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..FR.getPlayerName(FR.getUserSource(v.user_id)).."**\n> Loser TempID: **"..FR.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = FR.getPlayerName(FR.getUserSource(v.user_id)), loser = FR.getPlayerName(source)}
                        TriggerClientEvent('FR:coinflipOutcome', source, false, game)
                        TriggerClientEvent('FR:coinflipOutcome', FR.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('FR:chipsUpdated', FR.getUserSource(v.user_id))
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..FR.getPlayerName(source).." has WON a coin flip against "..FR.getPlayerName(FR.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!")
                        end
                        FR.sendWebhook('coinflip-bet',"FR Coinflip Logs", "> Winner Name: **"..FR.getPlayerName(FR.getUserSource(v.user_id)).."**\n> Winner TempID: **"..FR.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..FR.getPlayerName(source).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    FRclient.notify(source,{"Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)