local lang = FR.lang
local MoneydropEntities = {}

function tFR.MoneyDrop()
    local source = source
    Wait(100) -- wait delay for death.
    local user_id = FR.getUserId(source)
    local money = FR.getMoney(user_id)
    if money > 0 then
        local model = GetHashKey('prop_poly_bag_money')
        local name1 = FR.getPlayerName(source)
        local moneydrop = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
        local moneydropnetid = NetworkGetNetworkIdFromEntity(moneydrop)
        SetEntityRoutingBucket(moneydrop, GetPlayerRoutingBucket(source))
        MoneydropEntities[moneydropnetid] = {moneydrop, moneydrop, false, source}
        MoneydropEntities[moneydropnetid].Money = {}
        local ndata = FR.getUserDataTable(user_id)
        local stored_inventory = nil;
        if FR.tryPayment(user_id,money) then
            MoneydropEntities[moneydropnetid].Money = money
        end
    end
end

RegisterNetEvent('FR:Moneydrop')
AddEventHandler('FR:Moneydrop', function(netid)
    local source = source
    if MoneydropEntities[netid] and not MoneydropEntities[netid][3] and #(GetEntityCoords(MoneydropEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 10.0 then
        MoneydropEntities[netid][3] = true;
        local user_id = FR.getUserId(source)
        if user_id ~= nil then
            TriggerClientEvent("FR:MoneyNotInBag",source)
            if MoneydropEntities[netid].Money ~= 0 then
                FR.giveMoney(user_id,MoneydropEntities[netid].Money)
                local moneyamount = tonumber(MoneydropEntities[netid].Money)
                FRclient.notify(source,{"~g~You have picked up £"..getMoneyStringFormatted(moneyamount)})
                MoneydropEntities[netid].Money = 0
            end
        else
            FRclient.notify(source,{"The money has been picked up by someone else."})

        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(100)
        for i,v in pairs(MoneydropEntities) do 
            if v.Money == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    MoneydropEntities[i] = nil;
                end
            end
        end
    end
end)