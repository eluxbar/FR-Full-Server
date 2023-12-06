RegisterNetEvent("FR:saveFaceData")
AddEventHandler("FR:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = FR.getUserId(source)
    FR.setUData(user_id,"FR:Face:Data",json.encode(faceSaveData))
end)

RegisterNetEvent("FR:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("FR:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = FR.getUserId(source)
    local facesavedata = {}
    FR.getUData(user_id, "FR:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            FR.setUData(user_id,"FR:Face:Data",json.encode(facesavedata))
        end
    end)
end)

RegisterNetEvent("FR:getPlayerHairstyle")
AddEventHandler("FR:getPlayerHairstyle", function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.getUData(user_id,"FR:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("FR:setHairstyle", source, json.decode(data))
        end
    end)
end)

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = FR.getUserId(source)
        FR.getUData(user_id,"FR:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("FR:setHairstyle", source, json.decode(data))
            end
        end)
    end)
end)