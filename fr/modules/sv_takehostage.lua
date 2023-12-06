local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("FR:takeHostageSync")
AddEventHandler("FR:takeHostageSync", function(targetSrc)
	local source = source
	TriggerClientEvent("FR:takeHostageSyncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("FR:takeHostageReleaseHostage")
AddEventHandler("FR:takeHostageReleaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("FR:takeHostageReleaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("FR:takeHostageKillHostage")
AddEventHandler("FR:takeHostageKillHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("FR:takeHostageKillHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("FR:takeHostageStop")
AddEventHandler("FR:takeHostageStop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("FR:takeHostageCl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("FR:takeHostageCl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("FR:takeHostageCl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end
	if takenHostage[source] then
		TriggerClientEvent("FR:takeHostageCl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)