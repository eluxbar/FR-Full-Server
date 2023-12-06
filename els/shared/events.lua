local lookup = {
    ["FRELS:changeStage"] = "FRELS:1",
    ["FRELS:toggleSiren"] = "FRELS:2",
    ["FRELS:toggleBullhorn"] = "FRELS:3",
    ["FRELS:patternChange"] = "FRELS:4",
    ["FRELS:vehicleRemoved"] = "FRELS:5",
    ["FRELS:indicatorChange"] = "FRELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["fr"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end