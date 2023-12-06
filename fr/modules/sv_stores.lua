local cfg = module("cfg/cfg_stores")


RegisterNetEvent("FR:BuyStoreItem")
AddEventHandler("FR:BuyStoreItem", function(item, amount)
    local user_id = FR.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if FR.getInventoryWeight(user_id) <= 25 then
                if FR.tryPayment(user_id,v.price*amount) then
                    FR.giveInventoryItem(user_id, item, amount, false)
                    FRclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("FR:PlaySound", source, "playMoney")
                else
                    FRclient.notify(source, {"Not enough money."})
                    TriggerClientEvent("FR:PlaySound", source, 2)
                end
            else
                FRclient.notify(source,{'Not enough inventory space.'})
                TriggerClientEvent("FR:PlaySound", source, 2)
            end
        end
    end
end)