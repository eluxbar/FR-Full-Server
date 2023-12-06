local lang = FR.lang
local cfg = module("fr-assets", "cfg/cfg_garages")
local cfg_inventory = module("fr-assets", "cfg/cfg_inventory")
local vehicle_groups = cfg.garages
local limit = cfg.limit or 100000000
MySQL.createCommand("FR/add_vehicle","INSERT IGNORE INTO fr_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)")
MySQL.createCommand("FR/remove_vehicle","DELETE FROM fr_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("FR/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level, impounded FROM fr_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("FR/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM fr_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("FR/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM fr_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("FR/get_vehicle","SELECT vehicle FROM fr_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("FR/get_vehicle_fuellevel","SELECT fuel_level FROM fr_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("FR/check_rented","SELECT * FROM fr_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("FR/sell_vehicle_player","UPDATE fr_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("FR/rentedupdate", "UPDATE fr_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("FR/fetch_rented_vehs", "SELECT * FROM fr_user_vehicles WHERE rented = 1")
MySQL.createCommand("FR/get_vehicle_count","SELECT * FROM fr_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("FR/get_vehicle_lock_state", "SELECT * FROM fr_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

RegisterServerEvent("FR:spawnPersonalVehicle")
AddEventHandler('FR:spawnPersonalVehicle', function(vehicle)
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FR/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.vehicle == vehicle then
                    if v.impounded then
                        FRclient.notify(source, {'~r~This vehicle is currently impounded.'})
                        return
                    else
                        TriggerClientEvent('FR:spawnPersonalVehicle', source, v.vehicle, user_id, false, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                        return
                    end
                end
            end
        end
    end)
end)

valetCooldown = {}
RegisterServerEvent("FR:valetSpawnVehicle")
AddEventHandler('FR:valetSpawnVehicle', function(spawncode)
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.isPlusClub(source,{},function(plusclub)
        FRclient.isPlatClub(source,{},function(platclub)
            if plusclub or platclub then
                if valetCooldown[source] and not (os.time() > valetCooldown[source]) then
                    return FRclient.notify(source,{"~r~Please wait before using this again."})
                else
                    valetCooldown[source] = nil
                end
                MySQL.query("FR/get_vehicles", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.vehicle == spawncode then
                                TriggerClientEvent('FR:spawnPersonalVehicle', source, v.vehicle, user_id, true, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                                valetCooldown[source] = os.time() + 60
                                return
                            end
                        end
                    end
                end)
            else
                FRclient.notify(source, {"~y~You need to be a subscriber of FR Plus or FR Platinum to use this feature."})
                FRclient.notify(source, {"~y~Available @ store.frstudios.co.uk"})
            end
        end)
    end)
end)

RegisterServerEvent("FR:getVehicleRarity")
AddEventHandler('FR:getVehicleRarity', function(spawncode)
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FR/get_vehicle_lock_state", {user_id = user_id,vehicle = spawncode}, function(results)
        if results ~= nil then
            MySQL.query("FR/get_vehicle_count", {vehicle = spawncode}, function(result)
                if result ~= nil then
                    TriggerClientEvent('FR:setVehicleRarity', source, spawncode,#result,tobool(results[1].locked))
                end
            end)
        end
    end)
end)

RegisterServerEvent("FR:displayVehicleBlip")
AddEventHandler('FR:displayVehicleBlip', function(spawncode)
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FRls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                FRclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['remoteblips'] == 1 then
                            local position = {}
                            position.x, position.y, position.z = x,y,z
                            if next(position) then
                                TriggerClientEvent('FR:displayVehicleBlip', source, position)
                                FRclient.notify(source, {"~g~Vehicle blip enabled."})
                                return
                            end
                        end
                        FRclient.notify(source, {"~r~This vehicle does not have a remote vehicle blip installed."})
                    else
                        FRclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

RegisterNetEvent("FR:logVehicleSpawn")
AddEventHandler("FR:logVehicleSpawn", function(spawncode)
    local source = source
    FR.sendWebhook('spawn-vehicle', "FR Spawn Vehicle Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..FR.getUserId(source).."**\n> Vehicle: **"..spawncode.."**")
end)


RegisterServerEvent("FR:viewRemoteDashcam")
AddEventHandler('FR:viewRemoteDashcam', function(spawncode)
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FRls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                FRclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['dashcam'] == 1 then
                            if next(table.pack(x,y,z)) then
                                for k,v in pairs(netObjects) do
                                    if math.floor(vector3(x,y,z)) == math.floor(GetEntityCoords(NetworkGetEntityFromNetworkId(k))) then
                                        TriggerClientEvent('FR:viewRemoteDashcam', source, table.pack(x,y,z), k)
                                        return
                                    end
                                end
                            end
                        end
                        FRclient.notify(source, {"~r~This vehicle does not have a remote dashcam installed."})
                    else
                        FRclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent("FR:updateFuel")
AddEventHandler('FR:updateFuel', function(vehicle, fuel_level)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("UPDATE fr_user_vehicles SET fuel_level = @fuel_level WHERE user_id = @user_id AND vehicle = @vehicle", {fuel_level = fuel_level, user_id = user_id, vehicle = vehicle}, function() end)
end)

RegisterServerEvent("FR:getCustomFolders")
AddEventHandler('FR:getCustomFolders', function()
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * from `fr_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("FR:sendFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("FR:updateFolders")
AddEventHandler('FR:updateFolders', function(FolderUpdated)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * from `fr_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['fr']:execute("UPDATE fr_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['fr']:execute("INSERT INTO fr_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        MySQL.query('FR/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('FR/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
                  if FR.getUserSource(v.rentedid) ~= nil then
                    FRclient.notify(FR.getUserSource(v.rentedid), {"~r~Your rented vehicle has been returned."})
                  end
               end
            end
        end)
    end
end)

RegisterNetEvent('FR:FetchCars')
AddEventHandler('FR:FetchCars', function(type)
    local source = source
    local user_id = FR.getUserId(source)
    local returned_table = {}
    local fuellevels = {}
    if user_id then
        MySQL.query("FR/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local perms = false
                    local config = vehicle_groups[i]._config
                    if config.type == vehicle_groups[type]._config.type then 
                        local perm = config.permissions or nil
                        if next(perm) then
                            for i, v in pairs(perm) do
                                if FR.hasPermission(user_id, v) then
                                    perms = true
                                end
                            end
                        else
                            perms = true
                        end
                        if perms then 
                            for a, z in pairs(v) do
                                if a ~= "_config" and veh.vehicle == a then
                                    if not returned_table[i] then 
                                        returned_table[i] = {["_config"] = config}
                                    end
                                    if not returned_table[i].vehicles then 
                                        returned_table[i].vehicles = {}
                                    end
                                    returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate, veh.fuel_level}
                                    fuellevels[a] = veh.fuel_level
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('FR:ReturnFetchedCars', source, returned_table, fuellevels)
        end)
    end
end)

RegisterNetEvent('FR:CrushVehicle')
AddEventHandler('FR:CrushVehicle', function(vehicle)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id then 
        MySQL.query("FR/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("FR/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    FRclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    FRclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('FR/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                FR.sendWebhook('crush-vehicle', "FR Crush Vehicle Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Vehicle: **"..vehicle.."**")
                TriggerClientEvent('FR:CloseGarage', source)
            end)
        end)
    end
end)
RegisterNetEvent('FR:SellVehicle')
AddEventHandler('FR:SellVehicle', function(veh)
    local name = veh
    local player = source
    local playerID = FR.getUserId(source)
    if playerID ~= nil then
        FRclient.getNearestPlayers(player, {15}, function(nplayers)
            usrList = ""
            for k, v in pairs(nplayers) do
                usrList = usrList .. "[" .. FR.getUserId(k) .. "]" .. FR.getPlayerName(k) .. " | "
            end
            if usrList ~= "" then
                FR.prompt(player, "Players Nearby: " .. usrList .. "", "", function(player, user_id)
                    user_id = user_id
                    if user_id ~= nil and user_id ~= "" then
                        local target = FR.getUserSource(tonumber(user_id))
                        if target ~= nil then
                            FR.prompt(player, "Price £: ", "", function(player, amount)
                                if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                    MySQL.query("FR/get_vehicle", { user_id = user_id, vehicle = name }, function(pvehicle, affected)
                                        if #pvehicle > 0 then
                                            FRclient.notify(player, {"~r~The player already has this vehicle type."})
                                        else
                                            local tmpdata = FR.getUserTmpTable(playerID)
                                            MySQL.query("FR/check_rented", { user_id = playerID, vehicle = veh }, function(pvehicles)
                                                if #pvehicles > 0 then
                                                    FRclient.notify(player, {"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    FR.prompt(player, "Please replace text with YES or NO to confirm", "Sell Details:\nVehicle: " .. name .. "\nPrice: £" .. getMoneyStringFormatted(amount) .. "\nSelling to player: " .. FR.getPlayerName(target) .. "(" .. FR.getUserId(target) .. ")", function(player, details)
                                                        if string.upper(details) == 'YES' then
                                                            FRclient.notify(player, {'~g~Sell offer sent!'})
                                                            FR.request(target, FR.getPlayerName(player) .. " wants to sell: " .. name .. " Price: £" .. getMoneyStringFormatted(amount), 10, function(target, ok)
                                                                if ok then
                                                                    local pID = FR.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if FR.tryFullPayment(pID, amount) then
                                                                        FRclient.despawnGarageVehicle(player, {'car', 15})
                                                                        FR.getUserIdentity(pID, function(identity)
                                                                            MySQL.execute("FR/sell_vehicle_player", { user_id = user_id, registration = "P " .. identity.registration, oldUser = playerID, vehicle = name })
                                                                        end)
                                                                        FR.giveBankMoney(playerID, amount)
                                                                        FRclient.notify(player, {"~g~You have successfully sold the vehicle to " .. FR.getPlayerName(target) .. " for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        FRclient.notify(target, {"~g~" .. FR.getPlayerName(player) .. " has successfully sold you the car for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        FR.sendWebhook('sell-vehicle', "FR Sell Vehicle Logs", "> Seller Name: **" .. FR.getPlayerName(player) .. "**\n> Seller TempID: **" .. player .. "**\n> Seller PermID: **" .. playerID .. "**\n> Buyer Name: **" .. FR.getPlayerName(target) .. "**\n> Buyer TempID: **" .. target .. "**\n> Buyer PermID: **" .. user_id .. "**\n> Amount: **£" .. getMoneyStringFormatted(amount) .. "**\n> Vehicle: **" .. name .. "**")
                                                                        TriggerClientEvent('FR:CloseGarage', player)
                                                                    else
                                                                        FRclient.notify(player, {"~r~" .. FR.getPlayerName(target) .. " doesn't have enough money!"})
                                                                        FRclient.notify(target, {"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    FRclient.notify(player, {"~r~" .. FR.getPlayerName(target) .. " has refused to buy the car."})
                                                                    FRclient.notify(target, {"~r~You have refused to buy " .. FR.getPlayerName(player) .. "'s car."})
                                                                end
                                                            end)
                                                        else
                                                            FRclient.notify(player, {'~r~Sell offer cancelled!'})
                                                        end
                                                    end)
                                                end
                                            end)
                                        end
                                    end)
                                else
                                    FRclient.notify(player, {"~r~The price of the car has to be a number."})
                                end
                            end)
                        else
                            FRclient.notify(player, {"~r~That ID seems invalid."})
                        end
                    else
                        FRclient.notify(player, {"~r~No player ID selected."})
                    end
                end)
            else
                FRclient.notify(player, {"~r~No players nearby."})
            end
        end)
    end
end)



RegisterNetEvent('FR:RentVehicle')
AddEventHandler('FR:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = FR.getUserId(source)
    if playerID ~= nil then
		FRclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. FR.getUserId(k) .. "]" .. FR.getPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				FR.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = FR.getUserSource(tonumber(user_id))
						if target ~= nil then
							FR.prompt(player,"Price £: ","",function(player,amount)
                                FR.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("FR/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    FRclient.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = FR.getUserTmpTable(playerID)
                                                    MySQL.query("FR/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            return
                                                        else
                                                            FR.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nVehicle: "..name.."\nRent Cost: "..getMoneyStringFormatted(amount).."\nDuration: "..rent.." hours\nRenting to player: "..FR.getPlayerName(target).."("..FR.getUserId(target)..")",function(player,details)
                                                                if string.upper(details) == 'YES' then
                                                                    FRclient.notify(player, {'~g~Rent offer sent!'})
                                                                    FR.request(target,FR.getPlayerName(player).." wants to rent: " ..name.. " Price: £"..getMoneyStringFormatted(amount) .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                        if ok then
                                                                            local pID = FR.getUserId(target)
                                                                            amount = tonumber(amount)
                                                                            if FR.tryFullPayment(pID,amount) then
                                                                                FRclient.despawnGarageVehicle(player,{'car',15}) 
                                                                                FR.getUserIdentity(pID, function(identity)
                                                                                    local rentedTime = os.time()
                                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                                    MySQL.execute("FR/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                                end)
                                                                                FR.giveBankMoney(playerID, amount)
                                                                                FRclient.notify(player,{"~g~You have successfully rented the vehicle to "..FR.getPlayerName(target).." for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                FRclient.notify(target,{"~g~"..FR.getPlayerName(player).." has successfully rented you the car for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                FR.sendWebhook('rent-vehicle', "FR Rent Vehicle Logs", "> Renter Name: **"..FR.getPlayerName(player).."**\n> Renter TempID: **"..player.."**\n> Renter PermID: **"..playerID.."**\n> Rentee Name: **"..FR.getPlayerName(target).."**\n> Rentee TempID: **"..target.."**\n> Rentee PermID: **"..pID.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**\n> Duration: **"..rent.." hours**\n> Vehicle: **"..veh.."**")
                                                                                --TriggerClientEvent('FR:CloseGarage', player)
                                                                            else
                                                                                FRclient.notify(player,{"~r~".. FR.getPlayerName(target).." doesn't have enough money!"})
                                                                                FRclient.notify(target,{"~r~You don't have enough money!"})
                                                                            end
                                                                        else
                                                                            FRclient.notify(player,{"~r~"..FR.getPlayerName(target).." has refused to rent the car."})
                                                                            FRclient.notify(target,{"~r~You have refused to rent "..FR.getPlayerName(player).."'s car."})
                                                                        end
                                                                    end)
                                                                else
                                                                    FRclient.notify(player, {'~r~Rent offer cancelled!'})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            FRclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        FRclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							FRclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						FRclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				FRclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('FR:FetchRented')
AddEventHandler('FR:FetchRented', function()
    local rentedin = {}
    local rentedout = {}
    local source = source
    local user_id = FR.getUserId(source)
    MySQL.query("FR/get_rented_vehicles_in", {user_id = user_id}, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not FR.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not rentedin.vehicles then 
                            rentedin.vehicles = {}
                        end
                        local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                        local minutesLeft = nil
                        if hoursLeft < 1 then
                            minutesLeft = hoursLeft * 60
                            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                            datetime = minutesLeft .. " mins" 
                        else
                            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                            datetime = hoursLeft .. " hours" 
                        end
                        rentedin.vehicles[a] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        MySQL.query("FR/get_rented_vehicles_out", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local config = vehicle_groups[i]._config
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not FR.hasPermission(user_id, v) then
                                break
                            end
                        end
                    end
                    for a, z in pairs(v) do
                        if a ~= "_config" and veh.vehicle == a then
                            if not rentedout.vehicles then 
                                rentedout.vehicles = {}
                            end
                            local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                            local minutesLeft = nil
                            if hoursLeft < 1 then
                                minutesLeft = hoursLeft * 60
                                minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                                datetime = minutesLeft .. " mins" 
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                                datetime = hoursLeft .. " hours" 
                            end
                            rentedout.vehicles[a] = {z[1], datetime, veh.user_id, a}
                        end
                    end
                end
            end
            TriggerClientEvent('FR:ReturnedRentedCars', source, rentedin, rentedout)
        end)
    end)
end)

RegisterNetEvent('FR:CancelRent')
AddEventHandler('FR:CancelRent', function(spawncode, VehicleName, a)
    local source = source
    local user_id = FR.getUserId(source)
    if a == 'owner' then
        exports['fr']:execute("SELECT * FROM fr_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local target = FR.getUserSource(result[i].user_id)
                        if target ~= nil then
                            FR.request(target,FR.getPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('FR/rentedupdate', {id = user_id, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                    FRclient.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    FRclient.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    FRclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            FRclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    elseif a == 'renter' then
        exports['fr']:execute("SELECT * FROM fr_user_vehicles WHERE user_id = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local rentedid = tonumber(result[i].rentedid)
                        local target = FR.getUserSource(rentedid)
                        if target ~= nil then
                            FR.request(target,FR.getPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('FR/rentedupdate', {id = rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = user_id, veh = spawncode})
                                    FRclient.notify(source, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    FRclient.notify(target, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    FRclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            FRclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    end
end)

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = FR.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if FR.tryGetInventoryItem(user_id,"repairkit",1,true) then
      FRclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        FRclient.fixeNearestVehicle(player,{7})
        FRclient.stopAnim(player,{false})
      end)
    end
  end
end

RegisterNetEvent("FR:PayVehicleTax")
AddEventHandler("FR:PayVehicleTax", function()
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        local bank = FR.getBankMoney(user_id)
        local payment = bank / 10000
        if FR.tryBankPayment(user_id, payment) then
            FRclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(math.floor(payment)).." vehicle tax."})
            TriggerEvent('FR:addToCommunityPot', math.floor(payment))
        else
            FRclient.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        end
    end
end)

RegisterNetEvent("FR:refreshGaragePermissions")
AddEventHandler("FR:refreshGaragePermissions",function(src)
    local source=source
    if src then
        source = src
    end
    local garageTable={}
    local user_id = FR.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if json.encode(b.permissions) ~= '[""]' then
                    local hasPermissions = 0
                    for c,d in pairs(b.permissions) do
                        if FR.hasPermission(user_id, d) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #b.permissions then
                        table.insert(garageTable, k)
                    end
                else
                    table.insert(garageTable, k)
                end
            end
        end
    end
    local ownedVehicles = {}
    if user_id then
        MySQL.query("FR/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for k,v in pairs(pvehicles) do
                table.insert(ownedVehicles, v.vehicle)
            end
            TriggerClientEvent('FR:updateOwnedVehicles', source, ownedVehicles)
        end)
    end
    TriggerClientEvent("FR:recieveRefreshedGaragePermissions",source,garageTable)
end)


RegisterNetEvent("FR:getGarageFolders")
AddEventHandler("FR:getGarageFolders",function()
    local source = source
    local user_id = FR.getUserId(source)
    local garageFolders = {}
    local addedFolders = {}
    MySQL.query("FR/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                local spawncode = v.vehicle 
                for a,b in pairs(vehicle_groups) do
                    local hasPerm = true
                    if next(b._config.permissions) then
                        if not FR.hasPermission(user_id, b._config.permissions[1]) then
                            hasPerm = false
                        end
                    end
                    if hasPerm then
                        for c,d in pairs(b) do
                            if c == spawncode and not v.impounded then
                                if not addedFolders[a] then
                                    table.insert(garageFolders, {display = a})
                                    addedFolders[a] = true
                                end
                                for e,f in pairs (garageFolders) do
                                    if f.display == a then
                                        if f.vehicles == nil then
                                            f.vehicles = {}
                                        end
                                        table.insert(f.vehicles, {display = d[1], spawncode = spawncode})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('FR:setVehicleFolders', source, garageFolders)
        end
    end)
end)

local cfg_weapons = module("fr-assets", "cfg/weapons")

RegisterServerEvent("FR:searchVehicle")
AddEventHandler('FR:searchVehicle', function(entity, permid)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        if FR.getUserSource(permid) ~= nil then
            FRclient.getNetworkedVehicleInfos(FR.getUserSource(permid), {entity}, function(owner, spawncode)
                if spawncode and owner == permid then
                    local vehformat = 'chest:u1veh_'..spawncode..'|'..permid
                    FR.getSData(vehformat, function(cdata)
                        if cdata ~= nil then
                            cdata = json.decode(cdata)
                            if next(cdata) then
                                for a,b in pairs(cdata) do
                                    if string.find(a, 'wbody|') then
                                        c = a:gsub('wbody|', '')
                                        cdata[c] = b
                                        cdata[a] = nil
                                    end
                                end
                                for k,v in pairs(cfg_weapons.weapons) do
                                    if cdata[k] ~= nil then
                                        if not v.policeWeapon then
                                            FRclient.notify(source, {'~r~Seized '..v.name..' x'..cdata[k].amount..'.'})
                                            cdata[k] = nil
                                        end
                                    end
                                end
                                for c,d in pairs(cdata) do
                                    if seizeBullets[c] then
                                        FRclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                    if seizeDrugs[c] then
                                        FRclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                end
                                FR.setSData(vehformat, json.encode(cdata))
                                FR.sendWebhook('seize-boot', 'FR Seize Boot Logs', "> Officer Name: **"..FR.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Owner ID: **"..permid.."**")
                            else
                                FRclient.notify(source, {'~r~This vehicle is empty.'})
                            end
                        else
                            FRclient.notify(source, {'~r~This vehicle is empty.'})
                        end
                    end)
                end
            end)
        end
    end
end)


Citizen.CreateThread(function()
    Wait(1500)
    exports['fr']:execute([[
        CREATE TABLE IF NOT EXISTS `fr_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)
