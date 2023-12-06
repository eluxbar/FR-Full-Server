-- local cfg = module("cfg/cfg_trucking")
-- local ownedtrucks = {}
-- local rentedtrucks = {}
-- local onTruckJob = false


-- AddEventHandler("FRcli:playerSpawned", function()
--     local source = source
--     TriggerEvent("FR:updateOwnedTruckssv", source)
-- end)


-- local d = {
--     owned = {},
--     rented = {}
-- }

-- RegisterNetEvent("FR:updateOwnedTruckssv")
-- AddEventHandler("FR:updateOwnedTruckssv", function(ownedTrucks, rentedTrucks)
--     local source = source
    
--     d["owned"][source] = ownedTrucks
--     d["rented"][source] = rentedTrucks
--     TriggerClientEvent("FR:updateOwnedTrucks", source, d["owned"][source], d["rented"][source])
-- end)







-- RegisterServerEvent("FR:rentTruck")
-- AddEventHandler("FR:rentTruck", function(vehicleName, price)
--     local source = source
--     local user_id = FR.getUserId(source)
    
--     ownedtrucks[user_id] = ownedtrucks[user_id] or {}
--     rentedtrucks[user_id] = rentedtrucks[user_id] or {}
    
--     TriggerClientEvent("FR:updateOwnedTrucks", source, ownedtrucks[user_id], rentedtrucks[user_id])
-- end)

-- RegisterServerEvent("FR:spawnTruck")
-- AddEventHandler("FR:spawnTruck", function(vehicleName)
--     local source = source
--     TriggerClientEvent("FR:spawnTruckCl", source, vehicleName)
-- end)

-- RegisterServerEvent("FR:truckJobBuyAllTrucks")
-- AddEventHandler("FR:truckerJobBuyAllTrucks", function()
--     local source = source
    
--     -- Add your logic to handle buying all trucks here
    
--     TriggerClientEvent("FR:updateOwnedTrucks", source, ownedtrucks[source], rentedtrucks[source])
-- end)

-- RegisterServerEvent("FR:toggleTruckJob")
-- AddEventHandler("FR:toggleTruckJob", function(onDuty)
--     local source = source
--     onTruckJob = onDuty
    
--     -- Add your logic to handle the trucker job status here
    
--     TriggerClientEvent("FR:setTruckerOnDuty", source, onDuty)
-- end)
