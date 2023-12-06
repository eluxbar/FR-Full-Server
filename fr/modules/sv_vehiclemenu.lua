-- local price = 2500000

-- local function checkBoot(vehicle, userId, callback)
--     exports['fr']:executeSync('SELECT * FROM fr_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, callback)
-- end

-- local function handleBootCheckResult(source, result)
--     if result and result[1] then
--         if result[1].owned then
--             print("Sending boot data to client")
--             TriggerClientEvent("FR:VehicleBoot:Return", source, true, {})
--         end
--     else
--         TriggerClientEvent("FR:VehicleBoot:Return", source, false, {})
--     end
-- end

-- RegisterServerEvent('FR:VehicleBoot:Check')
-- AddEventHandler("FR:VehicleBoot:Check", function(vehicle)
--     local userId = FR.getUserId(source)
--     exports['fr']:executeSync('SELECT * FROM fr_user_vehicles WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(vehicleCheckResult)
        
--         if vehicleCheckResult and vehicleCheckResult[1] then
--             checkBoot(vehicle, userId, function(bootCheckResult)
--                 handleBootCheckResult(source, bootCheckResult)
--             end)
--         end
--     end)
-- end)

-- RegisterServerEvent('FR:VehicleBoot:Purchase')
-- AddEventHandler("FR:VehicleBoot:Purchase", function(vehicle)
--     local userId = FR.getUserId(source)
--     if FR.tryFullPayment(userId, price) then
--         checkBoot(vehicle, userId, function(result)
--             if not result[1] then
--                 exports['fr']:execute('INSERT INTO fr_user_boot (user_id, vehicle, owned) VALUES (@user_id, @vehicle, @owned)', 
--                     { user_id = userId, vehicle = vehicle, owned = true })

--                 TriggerClientEvent("FR:VehicleBoot:Return", source, true, {})
--                 FRclient.notify(source, {"~g~You have purchased a vehicle boot!"})
--             end
--         end)
--     else
--         FRclient.notify(source, {"~r~You don't have enough money!"})
--     end
-- end)

-- local function updateUserBoot(source, vehicle, userId, target_id, target_name, updateCallback)
--     exports['fr']:execute('SELECT * FROM fr_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(result)
--             if result and result[1] then
--                 local users = json.decode(result[1].users) or {}
--                 updateCallback(users, function(updatedUsers)e
--                     local updatedUsersJson = json.encode(updatedUsers)
--                     exports['fr']:execute('UPDATE fr_user_boot SET users = @users WHERE vehicle = @vehicle AND user_id = @user_id', 
--                         { users = updatedUsersJson, vehicle = vehicle, user_id = userId })
--                     TriggerClientEvent("FR:VehicleBoot:Return", source, true, updatedUsers)
--                 end)
--             else
--                 print("No result found for vehicle: " .. vehicle .. " and user_id: " .. userId)
--             end
--         end)
-- end

-- RegisterServerEvent("FR:VehicleBoot:Add")
-- AddEventHandler("FR:VehicleBoot:Add", function(vehicle)
--     local userId = FR.getUserId(source)
--     FR.prompt(source, "Enter Perm ID", "", function(source, target_id)
--         if FR.getUserSource(target_id) then
--             FRclient.notify(source, {"~r~Player is online!"})
--             return
--         end
--         local target_name = FR.getPlayerName(target_id)
--         if target_name then
--             updateUserBoot(source, vehicle, userId, target_id, target_name, function(users, commitChanges)
--                 if not users[target_id] then
--                     users[target_id] = { name = target_name, user_id = target_id }
--                     commitChanges(users)
--                     print("Added user_id: " .. target_id .. " to vehicle boot.")
--                 else
--                     print("User with ID " .. target_id .. " already exists in vehicle boot.")
--                 end
--             end)
--         else
--             FRclient.notify(source, {"~r~Player not found!"})
--         end
--     end)
-- end)


-- RegisterServerEvent("FR:VehicleBoot:Remove")
-- AddEventHandler("FR:VehicleBoot:Remove", function(vehicle, target_id)
--     local userId = FR.getUserId(source)
--     updateUserBoot(source, vehicle, userId, target_id, function(users, commitChanges)
--         if users[target_id] then
--             users[target_id] = nil
--             commitChanges(users)
--             print("Removed user_id: " .. target_id .. " from vehicle boot.")
--         else
--             print("User with ID " .. target_id .. " not found in vehicle boot.")
--         end
--     end)
-- end)


