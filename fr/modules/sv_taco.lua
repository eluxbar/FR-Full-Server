local tacoDrivers = {}

RegisterNetEvent('FR:addTacoSeller')
AddEventHandler('FR:addTacoSeller', function(coords, price)
    local source = source
    local user_id = FR.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('FR:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('FR:RemoveMeFromTacoPositions')
AddEventHandler('FR:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = FR.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('FR:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('FR:payTacoSeller')
AddEventHandler('FR:payTacoSeller', function(id)
    local source = source
    local user_id = FR.getUserId(source)
    if tacoDrivers[id] then
        if FR.getInventoryWeight(user_id)+1 <= FR.getInventoryMaxWeight(user_id) then
            if FR.tryFullPayment(user_id,15000) then
                FR.giveInventoryItem(user_id, 'Taco', 1)
                FR.giveBankMoney(id, 15000)
                TriggerClientEvent("FR:PlaySound", source, "money")
            else
                FRclient.notify(source, {'You do not have enough money.'})
            end
        else
            FRclient.notify(source, {'Not enough inventory space.'})
        end
    end
end)