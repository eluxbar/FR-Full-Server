local cfg=module("cfg/cfg_simeons")
local inventory=module("fr-assets", "cfg/cfg_inventory")


RegisterNetEvent("FR:refreshSimeonsPermissions")
AddEventHandler("FR:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = FR.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if FR.hasPermission(FR.getUserId(source),b.permissionTable[1])then
                        for c,d in pairs(v) do
                            if inventory.vehicle_chest_weights[c] then
                                table.insert(v[c],inventory.vehicle_chest_weights[c])
                            else
                                table.insert(v[c],30)
                            end
                        end
                        simeonsCategories[k] = v
                    end
                else
                    for c,d in pairs(v) do
                        if inventory.vehicle_chest_weights[c] then
                            table.insert(v[c],inventory.vehicle_chest_weights[c])
                        else
                            table.insert(v[c],30)
                        end
                    end
                    simeonsCategories[k] = v
                end
            end
        end
    end
    TriggerClientEvent("FR:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("FR:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('FR:purchaseCarDealerVehicle')
AddEventHandler('FR:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local source = source
    local user_id = FR.getUserId(source)
    local playerName = FR.getPlayerName(source)   
    for k,v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]
            MySQL.query("FR/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    FRclient.notify(source,{"Vehicle already owned."})
                else
                    if FR.tryFullPayment(user_id, vehicle_price) then
                        FRclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                            local uuid = string.upper(uuid)
                            MySQL.execute("FR/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
                            FRclient.notify(source,{"~g~You paid £"..vehicle_price.." for "..vehicle_name.."."})
                            TriggerClientEvent("FR:PlaySound", source, "playMoney")
                        end)
                    else
                        FRclient.notify(source,{"Not enough money."})
                        TriggerClientEvent("FR:PlaySound", source, 2)
                    end
                end
            end)
        end
    end
end)
