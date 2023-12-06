local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
	"nigger",
	"cunt",
	"faggot",
	"fuck",
	"fucker",
	"fucking",
	"anal",
	"stupid",
	"damn",
	"cock",
	"cum",
	"dick",
	"dipshit",
	"dildo",
	"douchbag",
	"douch",
	"kys",
	"jerk",
	"jerkoff",
	"gay",
	"homosexual",
	"lesbian",
	"suicide",
	"mothafucka",
	"negro",
	"pussy",
	"queef",
	"queer",
	"weeb",
	"retard",
	"masterbate",
	"suck",
	"tard",
	"allahu akbar",
	"terrorist",
	"twat",
	"vagina",
	"wank",
	"whore",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"free up mandem",
	"nazi",
	"hitler",
	"cheater",
	"cheating",
}

MySQL.createCommand("FR/update_numplate","UPDATE fr_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("FR/check_numplate","SELECT * FROM fr_user_vehicles WHERE vehicle_plate = @plate")

RegisterNetEvent('FR:getCars')
AddEventHandler('FR:getCars', function()
    local cars = {}
    local source = source
    local user_id = FR.getUserId(source)
    exports['fr']:execute("SELECT * FROM `fr_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('FR:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("FR:ChangeNumberPlate")
AddEventHandler("FR:ChangeNumberPlate", function(vehicle)
	local source = source
    local user_id = FR.getUserId(source)
	FR.prompt(source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		exports['fr']:execute("SELECT * FROM `fr_user_vehicles` WHERE vehicle_plate = @plate", {plate = plateName}, function(result)
            if next(result) then 
                FRclient.notify(source,{"This plate is already taken."})
                return
			else
				for name in pairs(forbiddenNames) do
					if plateName == forbiddenNames[name] then
						FRclient.notify(source,{"You cannot have this plate."})
						return
					end
				end
				if FR.tryFullPayment(user_id,500000) then
					FRclient.notify(source,{"~g~Changed plate of "..vehicle.." to "..plateName})
					MySQL.execute("FR/update_numplate", {user_id = user_id, registration = plateName, vehicle = vehicle})
					TriggerClientEvent("FR:RecieveNumberPlate", source, plateName)
					TriggerClientEvent("FR:PlaySound", source, "apple")
					TriggerEvent('FR:getCars')
				else
					FRclient.notify(source,{"You don't have enough money!"})
				end
            end
        end)
	end)
end)

RegisterNetEvent("FR:checkPlateAvailability")
AddEventHandler("FR:checkPlateAvailability", function(plate)
	local source = source
    local user_id = FR.getUserId(source)
	MySQL.query("FR/check_numplate", {plate = plate}, function(result)
		if #result > 0 then 
			FRclient.notify(source, {"The plate "..plate.." is already taken."})
		else
			FRclient.notify(source, {"~g~The plate "..plate.." is available."})
		end
	end)
end)
