RegisterServerEvent('FR:saveTattoos')
AddEventHandler('FR:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.tryFullPayment(user_id, price) then
        FR.setUData(user_id, "FR:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('FR:getPlayerTattoos')
AddEventHandler('FR:getPlayerTattoos', function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id, "FR:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('FR:setTattoos', source, json.decode(data))
        end
    end)
end)
