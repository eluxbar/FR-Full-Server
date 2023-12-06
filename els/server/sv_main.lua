RegisterNetEvent("FRELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('FRELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("FRELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('FRELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("FRELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('FRELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("FRELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('FRELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("FRELS:vehicleRemoved", function(stage)
	TriggerClientEvent('FRELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("FRELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('FRELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)