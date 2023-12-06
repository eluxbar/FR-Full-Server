voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("FR:vote") 
AddEventHandler("FR:vote", function(weatherType)
    TriggerClientEvent("FR:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("FR:tryStartWeatherVote")
AddEventHandler("FR:tryStartWeatherVote", function()
    local source = source
    local user_id = FR.getUserId(source)
    
    if weatherVoterCooldown >= voteCooldown then
        TriggerClientEvent("FR:startWeatherVote", -1)
        weatherVoterCooldown = 0
    else
        TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown - weatherVoterCooldown) .. " seconds!", {255, 0, 0})
    end

    if hasPermission(source) then
        FRclient.notify(source, {'You do not have permission for this.'})
    end
end)


RegisterServerEvent("FR:getCurrentWeather") 
AddEventHandler("FR:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("FR:voteFinished",source,currentWeather)
end)

RegisterServerEvent("FR:setCurrentWeather")
AddEventHandler("FR:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)