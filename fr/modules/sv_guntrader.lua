RegisterNetEvent('FR:gunTraderSell')
AddEventHandler('FR:gunTraderSell', function()
    local source = source
	local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'weapon') > 0 then
            FR.tryGetInventoryItem(user_id, 'weapon', 1, false)
            FRclient.notify(source, {'~g~Sold weapon for £'..getMoneyStringFormatted(a.refundPercentage)})
            FR.giveBankMoney(user_id, defaultPrices['weapon'])
        else
            FRclient.notify(source, {'You do not have a weapon.'})
        end
    end
end)