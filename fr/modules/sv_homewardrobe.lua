local outfitCodes = {}

RegisterNetEvent("FR:saveWardrobeOutfit")
AddEventHandler("FR:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id, "FR:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        FRclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            FR.setUData(user_id,"FR:home:wardrobe",json.encode(sets))
            FRclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("FR:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("FR:deleteWardrobeOutfit")
AddEventHandler("FR:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id, "FR:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        FR.setUData(user_id,"FR:home:wardrobe",json.encode(sets))
        FRclient.notify(source,{"Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("FR:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("FR:equipWardrobeOutfit")
AddEventHandler("FR:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id, "FR:home:wardrobe", function(data)
        local sets = json.decode(data)
        FRclient.setCustomization(source, {sets[outfitName]})
        FRclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("FR:initWardrobe")
AddEventHandler("FR:initWardrobe", function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id, "FR:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("FR:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("FR:getCurrentOutfitCode")
AddEventHandler("FR:getCurrentOutfitCode", function()
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.getCustomization(source,{},function(custom)
        FRclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            FRclient.CopyToClipBoard(source, {uuid})
            FRclient.notify(source, {"~g~Outfit code copied to clipboard."})
            FRclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("FR:applyOutfitCode")
AddEventHandler("FR:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = FR.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        FRclient.setCustomization(source, {outfitCodes[outfitCode]})
        FRclient.notify(source, {"~g~Outfit code applied."})
        FRclient.getHairAndTats(source, {})
    else
        FRclient.notify(source, {"Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("FR:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    local permid = tonumber(args[1])
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') then
        FRclient.getCustomization(FR.getUserSource(permid),{},function(custom)
            FRclient.setCustomization(source, {custom})
        end)
    end
end)