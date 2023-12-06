local jewelrycfg = module("cfg/cfg_jewelleryheist")
local facilityEmpty = true
local userInFacility = nil
local jewelryHeistReady = false
local isCooldownActive = false
local cooldownStartTime = 0
local cooldownDuration = 3600

AddEventHandler('FR:playerSpawn', function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("FR:jewelrySyncDoor", source, jewelryHeistReady)
        TriggerClientEvent('FR:jewelrySyncSetupReady', source, facilityEmpty)
        if jewelryHeistReady then
            TriggerClientEvent("FR:jewelryHeistReady", source, true)
        end
    end
end)

RegisterNetEvent('FR:jewelrySetupHeistStart')
AddEventHandler('FR:jewelrySetupHeistStart', function()
    local source = source
    local user_id = FR.getUserId(source)
    if userInFacility == nil then
        userInFacility = user_id
        facilityEmpty = false

        TriggerClientEvent('FR:jewelrySyncSetupReady', source, facilityEmpty)
        for k, v in pairs(jewelrycfg.aiSpawnLocs) do
            local pos = v.coords
            local ped = CreatePed(4, "s_m_y_blackops_03", pos.x, pos.y, pos.z, v.heading, false, true)
            GiveWeaponToPed(ped, v.weaponHash, 999, false, true)
            TriggerClientEvent('FR:jewelryMakePedsAttack', source, NetworkGetNetworkIdFromEntity(ped))
        end
        Citizen.Wait(2000)
        for _, pickupLocation in pairs(jewelrycfg.hackingDevicePickupLocs) do
            TriggerClientEvent('FR:jewelryCreateDevicePickup', -1, pickupLocation)
        end
    end
end)

RegisterNetEvent('FR:jewelryCollectDevice')
AddEventHandler('FR:jewelryCollectDevice', function()
    local source = source
    local user_id = FR.getUserId(source)

    TriggerClientEvent('FR:jewelrySyncSetupReady', -1, facilityEmpty)
    TriggerClientEvent('FR:jewelryRemoveDeviceArea', -1)
    FR.giveInventoryItem(user_id, "hackingDevice", 1, true)
end)

RegisterNetEvent('FR:jewelrySetupHeistleave')
AddEventHandler('FR:jewelrySetupHeistLeave', function()
    local source = source
    local user_id = FR.getUserId(source)
    if userInFacility == user_id then
        userInFacility = nil
        facilityEmpty = true
        TriggerClientEvent('FR:jewelrySyncSetupReady', -1, facilityEmpty)
        TriggerClientEvent('FR:jewelryRemoveDeviceArea', -1)
    end
end)


-- RegisterNetEvent("FR:jewelryHackDoor")
-- AddEventHandler('FR:jewelryHackDoor', function()
--     local source = source
--     local user_id = FR.getUserId(source)
--     if FR.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
--         TriggerClientEvent('FR:jewelryStartDoorHackSf', source)
--         TriggerClientEvent("FR:jewelrySoundAlarm", -1, true)
--     else
--         FRclient.notify(source, {'You do not have a Hacking Device.'})
--     end
-- end)

RegisterNetEvent('FR:jewelryHackDoor')
AddEventHandler('FR:jewelryHackDoor', function()
    local source = source
    local user_id = FR.getUserId(source)
    
    if not user_id then
        FRclient.notify(source, {'~r~Unable To Find User ID'})
        return
    end

    if isCooldownActive and os.time() - cooldownStartTime < cooldownDuration then
        local remainingCooldown = cooldownStartTime + cooldownDuration - os.time()
        TriggerClientEvent('chatMessage', source, "^7OOC ^1Jewelry Store Robbery ^7 - Jewelry Store was robbed too recently, "..remainingCooldown.." seconds remaining.", { 128, 128, 128 }, message, "alert")
        return
    end

    if FR.hasPermission(user_id, "police.armoury") then
        FRclient.notify(source, {'~r~You cannot rob a jewelry store as police.'})
    else
        local policeCount = #FR.getUsersByPermission('police.armoury')
        if policeCount > 0 then
            if FR.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
                TriggerClientEvent('FR:jewelryStartDoorHackSf', source)
                TriggerClientEvent("FR:jewelrySoundAlarm", -1, true)  
                for a, b in pairs(FR.getUsers({})) do
                    if FR.hasPermission(a, "police.armoury") then
                        TriggerClientEvent("FR:jewelryAlarmTriggered", a)
                    end
                end
            else
                FRclient.notify(source, {'You do not have a Hacking Device.'})
            end
            TriggerEvent('FR:PDRobberyCall', source, "Jewelry Store", vector3(-623.42156982422, -231.59411621094, 38.057064056396))
        else
            FRclient.notify(source, {'~r~There are not enough police on duty to rob a jewelry store.'})
        end
    end
end)




RegisterNetEvent('FR:jewelryDoorHackSuccess')
AddEventHandler('FR:jewelryDoorHackSuccess', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent("FR:jewelrySyncDoor", -1, false)
        TriggerClientEvent("FR:jewelryComputerHackArea", -1, true)
        FRclient.notify(source, {'~g~Now Go Hack The Computer!'})
    else
        FRclient.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("FR:jewelryHackComputer")
AddEventHandler('FR:jewelryHackComputer', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent('FR:jewelryStartComputerHackSf', source)
    else
        FRclient.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("FR:heiststarten")
AddEventHandler('FR:heiststarten', function()
    TriggerClientEvent('FR:jewelryCreateTimer', -1)
    for caseID, caseData in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseID, U)
    end
    SetTimeout(600000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseID, U)
        end
    end)
end)
RegisterNetEvent("FR:jewelryComputerHackSuccess")
AddEventHandler('FR:jewelryComputerHackSuccess', function()
    local sourceCoords = GetEntityCoords(GetPlayerPed(-1))
    local storeMiddle = vector3(-623.42156982422, -231.59411621094, 38.057064056396)
    local radius = 9.086
    for i = 1, 31 do
        local targetCoords = GetEntityCoords(GetPlayerPed(i))
        local distance = #(storeMiddle - targetCoords)
        if distance <= radius then
            TriggerClientEvent('FR:jewelryCreateTimer', i)
        end
    end

    for caseID, _ in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseID, U)
    end

    SetTimeout(100000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseID, U)
        end
        jewelryHeistReady = false
        TriggerClientEvent("FR:jewelryHeistReady", -1, false)
        TriggerClientEvent("FR:jewelrySyncDoor", -1, true)
    end)

    local user_id = FR.getUserId(source)
    cooldownStartTime = os.time()
    isCooldownActive = true
    FR.tryGetInventoryItem(user_id, 'hackingDevice', 1, false)
    SetTimeout(300000, function()
        TriggerClientEvent("FR:jewelryHeistReady", -1, true)
    end)
end)

function getRandomJewelryItem()
    local randNum = math.random(1, 100)
    if randNum <= 10 then
        return { spawnName = "sapphire", itemCount = 1 }
    elseif randNum <= 30 then
        local itemCount = math.random(1, 2)
        return { spawnName = "jewelry_necklace", itemCount = itemCount }
    elseif randNum <= 70 then
        local itemCount = math.random(1, 5)
        return { spawnName = "jewelry_watch", itemCount = itemCount }
    else
        local itemCount = math.random(2, 10)
        return { spawnName = "jewelry_ring", itemCount = itemCount }
    end
end


RegisterNetEvent("FR:jewelryGrabLoot")
AddEventHandler('FR:jewelryGrabLoot', function(caseId)
    local jewelryItem = getRandomJewelryItem()

    if not jewelryItem then
        return
    end

    local user_id = FR.getUserId(source)
    local spawnName = jewelryItem.spawnName
    local ItemWeight = FR.getItemWeight(spawnName)

    if not caseId or not jewelrycfg.jewelryCases[caseId] then
        return
    end

    local itemCount = jewelryItem.itemCount or 1

    if FR.hasPermission(userid, "police") then
        FRclient.notify(playerSource, { "Not enough space in inventory." })
    else
        local U = false
        TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseId, U)
        FR.giveInventoryItem(user_id, spawnName, itemCount, true)
        FR.notify(playerSource, { "You have recived " .. itemCount .. " " .. spawnName .. "!" })
    end
end)



RegisterNetEvent("FR:jewelryPoliceSeizeLoot")
AddEventHandler('FR:jewelryPoliceSeizeLoot', function(caseId)
    local U = false
    TriggerClientEvent("FR:jewelrySyncLootAreas", -1, caseId, U)
    FRclient.notify(source, {"~g~Recovered Jewelry"})
end)

local function checkBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        FRclient.notify(source, {'You cannot sell in this bucket.'})
        return false
    end
    return true
end


RegisterNetEvent('FR:sellJewelry')
AddEventHandler('FR:sellJewelry', function(spawnName, sellPrice, itemName)
    local source = source
    local user_id = FR.getUserId(source)
    if checkBucket(source) then
        if FR.getInventoryItemAmount(user_id, spawnName) > 0 then
            FR.tryGetInventoryItem(user_id, spawnName, 1, false)
            FRclient.notify(source, {itemName .. '~g~ Sold For £' .. getMoneyStringFormatted(sellPrice)})
            FR.giveBankMoney(user_id, sellPrice)
        else
            FRclient.notify(source, {'You don\'t have ' .. itemName})
        end
    end
end)