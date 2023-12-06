MySQL = module("modules/MySQL")

local Inventory = module("fr-assets", "cfg/cfg_inventory")
local Housing = module("fr", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("fr-assets", "cfg/weapons")
local AmmoItems = {
    ["9mm Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["7.62mm Bullets"] = true,
    ["5.56mm NATO"] = true,
    [".357 Bullets"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued 12 Gauge"] = true
}

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local user_id = FR.getUserId(source) 
            local data = FR.getUserDataTable(user_id)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                end
                TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
                InventorySpamTrack[source] = false;
            else 
                --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
            end
        end
    end
end)

RegisterNetEvent('FR:FetchPersonalInventory')
AddEventHandler('FR:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local user_id = FR.getUserId(source) 
        local data = FR.getUserDataTable(user_id)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
            end
            TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
            InventorySpamTrack[source] = false;
        else 
            --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('FR:RefreshInventory', function(source)
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
        end
        TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('FR:GiveItem')
AddEventHandler('FR:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        FR.RunGiveTask(source, itemId)
        TriggerEvent('FR:RefreshInventory', source)
    else
        FRclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)
RegisterNetEvent('FR:GiveItemAll')
AddEventHandler('FR:GiveItemAll', function(itemId, itemLoc)
    local source = source
    if not itemId then  FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        FR.RunGiveAllTask(source, itemId)
        TriggerEvent('FR:RefreshInventory', source)
    else
        FRclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('FR:TrashItem')
AddEventHandler('FR:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        FR.RunTrashTask(source, itemId)
        TriggerEvent('FR:RefreshInventory', source)
    else
        FRclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('FR:FetchTrunkInventory')
AddEventHandler('FR:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = FR.getUserId(source)
    if InventoryCoolDown[source] then FRclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    FR.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('FR:RefreshInventory', source)
    end)
end)


RegisterNetEvent('FR:viewTrunk')
AddEventHandler('FR:viewTrunk', function(spawnCode)
    local source = source
    local user_id = FR.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    FR.getSData(carformat, function(cdata)
        cdata = json.decode(cdata) or {}
        local AmmoTable = {}
        local OtherTable = {}
        local WeaponTable = {}
        
        for i, v in pairs(cdata) do
            local itemName = FR.getItemName(i)
            if string.find(i, "wbody") then
                table.insert(WeaponTable, {
                    amount = v.amount,
                    WeaponName = itemName
                })
            elseif AmmoItems[itemName] then
                table.insert(AmmoTable, {
                    amount = v.amount,
                    AmmoName = itemName
                })
            else
                table.insert(OtherTable, {
                    amount = v.amount,
                    ItemName = itemName
                })
            end
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        local totalWeight = FR.computeItemsWeight(cdata)
        
        local viewTrunk = {
            Ammo = AmmoTable,
            Weapons = WeaponTable,
            Other = OtherTable,
        }
        
        TriggerClientEvent("FR:ReturnFetchedCarsBoot", source, viewTrunk)
    end)
end)


RegisterNetEvent('FR:WipeBoot')
AddEventHandler('FR:WipeBoot', function(spawnCode)
    local source = source
    local user_id = FR.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    FR.prompt(source, "Please replace text with YES or NO to confirm", "Wipe Boot For Vehicle: " .. spawnCode, function(source, wipeboot)
        if string.upper(wipeboot) == 'YES' then
            FR.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                for i, v in pairs(cdata) do
                    cdata[i] = nil
                end
                FR.setSData(carformat, json.encode(cdata))
                TriggerEvent('FR:RefreshInventory', source)
                FRclient.notify(source, {'~g~You have wiped the boot of this vehicle.'})
            end)
        else
            FRclient.notify(source, {'~r~You did not confirm the wipe.'})
        end
    end)
end)








local inHouse = {}
RegisterNetEvent('FR:FetchHouseInventory')
AddEventHandler('FR:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = FR.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            FR.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            FRclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('FR:cancelPlayerSearch')
AddEventHandler('FR:cancelPlayerSearch', function()
    local source = source
    local user_id = FR.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('FR:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('FR:searchPlayer')
AddEventHandler('FR:searchPlayer', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    local their_id = FR.getUserId(playersrc) 
    local their_data = FR.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('FR:startSearchingSuspect', source)
        TriggerClientEvent('FR:startBeingSearching', playersrc, source)
        FRclient.notify(playersrc, {'~b~You are being searched.'})
        Wait(10000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
            end
            exports['fr']:execute("SELECT * FROM fr_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        if FR.getMoney(their_id) then
                            FormattedSecondaryInventoryData['cash'] = {amount = FR.getMoney(their_id), ItemName = 'Cash', Weight = 0.00}
                        end
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, FR.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('FR:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)

RegisterNetEvent('FR:robPlayer')
AddEventHandler('FR:robPlayer', function(playersrc)
    local source = source
    FRclient.isPlayerSurrendered(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = FR.getUserId(source) 
                local data = FR.getUserDataTable(user_id)
                local their_id = FR.getUserId(playersrc) 
                local their_data = FR.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                    end
                    exports['fr']:execute("SELECT * FROM fr_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    FR.giveInventoryItem(user_id, i, v.amount)
                                    FR.tryGetInventoryItem(their_id, i, v.amount)
                                end
                            end
                            if FR.getMoney(their_id) > 0 then
                                FR.giveMoney(user_id, FR.getMoney(their_id))
                                FR.tryPayment(their_id, FR.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('FR:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                else 
                    --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
                end
            end
        end
    end)
end)
RegisterNetEvent('FR:UseItem')
AddEventHandler('FR:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    if not itemId then FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        FR.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                local invcap = 30
                if plathours > 0 then
                    invcap = 50
                elseif plushours > 0 then
                    invcap = 40
                end
                if FR.getInventoryMaxWeight(user_id) ~= nil then
                    if FR.getInventoryMaxWeight(user_id) > invcap then
                        return
                    end
                end
                if itemId == "offwhitebag" then
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+15)
                    TriggerClientEvent('FR:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
                elseif itemId == "guccibag" then 
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+20)
                    TriggerClientEvent('FR:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
                elseif itemId == "nikebag" then 
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+30)
                elseif itemId == "huntingbackpack" then 
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+35)
                    TriggerClientEvent('FR:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
                elseif itemId == "greenhikingbackpack" then 
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+40)
                elseif itemId == "rebelbackpack" then 
                    FR.tryGetInventoryItem(user_id, itemId, 1, true)
                    FR.updateInvCap(user_id, invcap+70)
                    TriggerClientEvent('FR:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
                elseif itemId == "Shaver" then 
                    FR.ShaveHead(source)
                elseif itemId == "handcuffkeys" then 
                    FR.handcuffKeys(source)
                end
                TriggerEvent('FR:RefreshInventory', source)
            end
        end)  
    end
    if itemLoc == "Plr" then
        FR.RunInventoryTask(source, itemId)
        TriggerEvent('FR:RefreshInventory', source)
    else
        FRclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('FR:UseAllItem')
AddEventHandler('FR:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = FR.getUserId(source) 
    if not itemId then FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        FR.LoadAllTask(source, itemId)
        TriggerEvent('FR:RefreshInventory', source)
    else
        FRclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('FR:MoveItem')
AddEventHandler('FR:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    if FR.isPurge() then return end
    if InventoryCoolDown[source] then FRclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            FR.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = FR.getInventoryWeight(user_id)+FR.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('FR:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        FR.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = FR.getInventoryWeight(user_id)+FR.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('FR:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            FR.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = FR.getInventoryWeight(user_id)+FR.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            FR.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('FR:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        FR.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = FR.computeItemsWeight(cdata)+FR.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if FR.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('FR:RefreshInventory', source)
                                    FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                    InventoryCoolDown[source] = false;
                                else 
                                    FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        FR.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = FR.computeItemsWeight(cdata)+FR.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if FR.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('FR:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    FR.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('FR:MoveItemX')
AddEventHandler('FR:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    if FR.isPurge() then return end
    if InventoryCoolDown[source] then FRclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                FR.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('FR:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            FR.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                FRclient.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                Quantity = parseInt(Quantity)
                if Quantity then
                    local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) * Quantity)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('FR:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    FRclient.notify(source, {'~r~Invalid input!'})
                end
            end
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                FR.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                FR.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('FR:RefreshInventory', source)
                            FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                            InventoryCoolDown[source] = false;
                        else 
                            FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                FRclient.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                            FR.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = FR.computeItemsWeight(cdata)+(FR.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if FR.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('FR:RefreshInventory', source)
                                        FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                        InventoryCoolDown[source] = false;
                                    else 
                                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            FRclient.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                            FR.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = FR.computeItemsWeight(cdata)+(FR.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if FR.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('FR:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        FR.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            FRclient.notify(source, {'~r~Invalid input!'})
                        end
                    end
                else
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('FR:MoveItemAll')
AddEventHandler('FR:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local user_id = FR.getUserId(source) 
    local data = FR.getUserDataTable(user_id)
    if FR.isPurge() then return end
    if not itemId then FRclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then FRclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = FR.getUserId(NetworkGetEntityOwner(idz))
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            FR.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    local amount = cdata[itemId].amount
                    if weightCalculation > FR.getInventoryMaxWeight(user_id) and FR.getInventoryWeight(user_id) ~= FR.getInventoryMaxWeight(user_id) then
                        amount = math.floor((FR.getInventoryMaxWeight(user_id)-FR.getInventoryWeight(user_id)) / FR.getItemWeight(itemId))
                    end
                    if math.floor(amount) > 0 or (weightCalculation <= FR.getInventoryMaxWeight(user_id)) then
                        FR.giveInventoryItem(user_id, itemId, amount, true)
                        local FormattedInventoryData = {}
                        if (cdata[itemId].amount - amount) > 0 then
                            cdata[itemId].amount = cdata[itemId].amount - amount
                        else
                            cdata[itemId] = nil
                        end
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('FR:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        FR.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = nil;
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "LootBag" then
            if itemId ~= nil then    
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            FR.giveInventoryItem(user_id, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('FR:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            FR.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = FR.getInventoryWeight(user_id)+(FR.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= FR.getInventoryMaxWeight(user_id) then
                        FR.giveInventoryItem(user_id, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('FR:RefreshInventory', source)
                        FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        FR.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = FR.computeItemsWeight(cdata)+(FR.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if FR.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('FR:RefreshInventory', source)
                                    FR.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        FR.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = FR.computeItemsWeight(cdata)+(FR.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if FR.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('FR:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    FR.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    FRclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                FRclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('FR:InComa')
AddEventHandler('FR:InComa', function()
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = FR.getInventoryWeight(user_id)
            if weight == 0 then return end
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = FR.getPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
            local ndata = FR.getUserDataTable(user_id)
            local stored_inventory = nil;
            TriggerEvent('FR:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    FR.clearInventory(user_id)
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)
local alreadyEquiping = {}

RegisterNetEvent('FR:EquipAll')
AddEventHandler('FR:EquipAll', function()
    local source = source
    local user_id = FR.getUserId(source)
    
    if alreadyEquiping[user_id] then
        FRclient.notify(source, {'~r~You are already equipping all items'})
        return
    end
    
    alreadyEquiping[user_id] = true
    local data = FR.getUserDataTable(user_id)
    local sortedTable = {}
    
    for item, _ in pairs(data.inventory) do
        if string.find(item, 'wbody|') or seizeBullets[item] then
            table.insert(sortedTable, item)
        end
    end
    
    table.sort(sortedTable, function(a, b)
        local aIsWeapon = string.find(a, 'wbody|')
        local bIsWeapon = string.find(b, 'wbody|')
        
        if aIsWeapon and bIsWeapon then
            return a < b
        elseif aIsWeapon then
            return true
        elseif bIsWeapon then
            return false
        else
            return a < b
        end
    end)
    
    for _, item in ipairs(sortedTable) do
        if string.find(item:lower(), 'wbody|') then
            FR.RunInventoryTask(source, item)
        elseif seizeBullets[item] then
            FR.LoadAllTask(source, item)
        end
        Wait(500)
    end
    
    TriggerEvent('FR:RefreshInventory', source)
    alreadyEquiping[user_id] = false
end)
RegisterNetEvent('FR:LootItemAll')
AddEventHandler('FR:LootItemAll', function(inventoryInfo)
    local source = source
    local user_id = FR.getUserId(source)
    local data = FR.getUserDataTable(user_id)
    local weightCalculation = 0
    if not LootBagEntities[inventoryInfo] then 
        FRclient.notify(source, {'~r~This loot bag items are unavailable.'})
        return
    end
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        weightCalculation = weightCalculation + (FR.getItemWeight(itemId) * itemData.amount)
    end
    if weightCalculation > FR.getInventoryMaxWeight(user_id) then
        FRclient.notify(source, {'~r~You do not have enough inventory space.'})
        return
    end
    if InventoryCoolDown[source] then FRclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    InventoryCoolDown[source] = true;
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        local amount = itemData.amount

        if weightCalculation > FR.getInventoryMaxWeight(user_id) and FR.getInventoryWeight(user_id) ~= FR.getInventoryMaxWeight(user_id) then
            amount = math.floor((FR.getInventoryMaxWeight(user_id) - FR.getInventoryWeight(user_id)) / FR.getItemWeight(itemId))
        end

        FR.giveInventoryItem(user_id, itemId, amount, true)
        LootBagEntities[inventoryInfo].Items[itemId] = nil
    end

    local FormattedInventoryData = {}

    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i) * v.amount}
    end
    --TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(LootBagEntities[inventoryInfo].Items), 200)
    TriggerEvent('FR:RefreshInventory', source)
    InventoryCoolDown[source] = false;
    if not next(LootBagEntities[inventoryInfo].Items) then
        CloseInv(source)
    end
end)







RegisterNetEvent('FR:LootBag')
AddEventHandler('FR:LootBag', function(netid)
    local source = source
    FRclient.isInComa(source, {}, function(in_coma) 
        if not in_coma and not tFR.createCamera then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = FR.getUserId(source)
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    if FR.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    FRclient.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                FRclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        FRclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if #LootBagEntities[netid].Items > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                FRclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            FRclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)


Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('FR:CloseLootbag')
AddEventHandler('FR:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('FR:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local user_id = FR.getUserId(source)
    local data = FR.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
        end
        TriggerClientEvent('FR:FetchPersonalInventory', source, FormattedInventoryData, FR.computeItemsWeight(data.inventory), FR.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('FR:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = FR.getItemName(i), Weight = FR.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('FR:SendSecondaryInventoryData', source, FormattedInventoryData, FR.computeItemsWeight(LootBagItems), maxVehKg)
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    LootBagEntities[i] = nil;
                end
            end
        end
    end
end)


local useing = {}

RegisterNetEvent('FR:attemptLockpick')
AddEventHandler('FR:attemptLockpick', function(veh, netveh)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.tryGetInventoryItem(user_id, 'Lockpick', 1, true) then
        local chance = math.random(1,8)
        if chance == 1 then
            TriggerClientEvent('FR:lockpickClient', source, veh, true)
        else
            TriggerClientEvent('FR:lockpickClient', source, veh, false)
        end
    end
end)

RegisterNetEvent('FR:lockpickVehicle')
AddEventHandler('FR:lockpickVehicle', function(spawncode, ownerid)
    local source = source
    local user_id = FR.getUserId(source)
    
end)

RegisterNetEvent('FR:setVehicleLock')
AddEventHandler('FR:setVehicleLock', function(netid)
    local source = source
    local user_id = FR.getUserId(source)
    if usersLockpicking[user_id] then
        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
    end
end)