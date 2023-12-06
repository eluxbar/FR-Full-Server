grindBoost = 2.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(15000*grindBoost),
    ["LSDSouth"] = math.floor(15000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(6000*grindBoost),
}

function FR.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function FR.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function FR.updateTraderInfo()
    TriggerClientEvent('FR:updateTraderCommissions', -1, 
    FR.getCommission('Weed'),
    FR.getCommission('Cocaine'),
    FR.getCommission('Meth'),
    FR.getCommission('Heroin'),
    FR.getCommission('LargeArms'),
    FR.getCommission('LSDNorth'),
    FR.getCommission('LSDSouth'))
    TriggerClientEvent('FR:updateTraderPrices', -1, 
    FR.getCommissionPrice('Weed'), 
    FR.getCommissionPrice('Cocaine'),
    FR.getCommissionPrice('Meth'),
    FR.getCommissionPrice('Heroin'),
    FR.getCommissionPrice('LSDNorth'),
    FR.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('FR:requestDrugPriceUpdate')
AddEventHandler('FR:requestDrugPriceUpdate', function()
    local source = source
	local user_id = FR.getUserId(source)
    FR.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        FRclient.notify(source, {'You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('FR:sellCopper')
AddEventHandler('FR:sellCopper', function()
    local source = source
	local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Copper') > 0 then
            FR.tryGetInventoryItem(user_id, 'Copper', 1, false)
            FRclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            FR.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            FRclient.notify(source, {'You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('FR:sellLimestone')
AddEventHandler('FR:sellLimestone', function()
    local source = source
	local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            FR.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            FRclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            FR.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            FRclient.notify(source, {'You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('FR:sellGold')
AddEventHandler('FR:sellGold', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Gold') > 0 then
            FR.tryGetInventoryItem(user_id, 'Gold', 1, false)
            FRclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            FR.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            FRclient.notify(source, {'You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('FR:sellDiamond')
AddEventHandler('FR:sellDiamond', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            FR.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            FRclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            FR.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            FRclient.notify(source, {'You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('FR:sellWeed')
AddEventHandler('FR:sellWeed', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Weed') > 0 then
            FR.tryGetInventoryItem(user_id, 'Weed', 1, false)
            FRclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(FR.getCommissionPrice('Weed'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('Weed'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('Weed'), 'Weed')
        else
            FRclient.notify(source, {'You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('FR:sellCocaine')
AddEventHandler('FR:sellCocaine', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            FR.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            FRclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(FR.getCommissionPrice('Cocaine'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('Cocaine'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('Cocaine'), 'Cocaine')
        else
            FRclient.notify(source, {'You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('FR:sellMeth')
AddEventHandler('FR:sellMeth', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Meth') > 0 then
            FR.tryGetInventoryItem(user_id, 'Meth', 1, false)
            FRclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(FR.getCommissionPrice('Meth'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('Meth'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('Meth'), 'Meth')
        else
            FRclient.notify(source, {'You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('FR:sellHeroin')
AddEventHandler('FR:sellHeroin', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            FR.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            FRclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(FR.getCommissionPrice('Heroin'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('Heroin'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('Heroin'), 'Heroin')
        else
            FRclient.notify(source, {'You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('FR:sellLSDNorth')
AddEventHandler('FR:sellLSDNorth', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'LSD') > 0 then
            FR.tryGetInventoryItem(user_id, 'LSD', 1, false)
            FRclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(FR.getCommissionPrice('LSDNorth'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('LSDNorth'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('LSDNorth'), 'LSDNorth')
        else
            FRclient.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('FR:sellLSDSouth')
AddEventHandler('FR:sellLSDSouth', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        if FR.getInventoryItemAmount(user_id, 'LSD') > 0 then
            FR.tryGetInventoryItem(user_id, 'LSD', 1, false)
            FRclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(FR.getCommissionPrice('LSDSouth'))})
            FR.giveMoney(user_id, FR.getCommissionPrice('LSDSouth'))
            FR.turfSaleToGangFunds(FR.getCommissionPrice('LSDSouth'), 'LSDSouth')
        else
            FRclient.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('FR:sellAll')
AddEventHandler('FR:sellAll', function()
    local source = source
    local user_id = FR.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if FR.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = FR.getInventoryItemAmount(user_id, k)
                    FR.tryGetInventoryItem(user_id, k, amount, false)
                    FRclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    FR.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if FR.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = FR.getInventoryItemAmount(user_id, 'Processed Diamond')
                    FR.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    FRclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    FR.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)