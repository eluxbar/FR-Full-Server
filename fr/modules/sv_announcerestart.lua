RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Lead Developer') or source == '' then
        if args[1] ~= nil then
            timeLeft = args[1]
            local shutdownTime = timeLeft - 10
            print(shutdownTime)
            TriggerClientEvent('FR:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('FR:restartTime', timeLeft)
            TriggerClientEvent('FR:CloseToRestart', -1)
            Online = false
        end
    end
end)
RegisterCommand('consolerestart', function(source, args)
    local source = source
    if source == 0 then
        timeLeft = args[1]
        local shutdownTime = timeLeft - 10
        print('Restarting in ' .. timeLeft .. ' seconds.')
        TriggerClientEvent('FR:announceRestart', -1, tonumber(timeLeft), false)
        TriggerEvent('FR:restartTime', timeLeft)
        TriggerClientEvent('FR:CloseToRestart', -1)
        Online = false
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t") -- 0-23 (24 hour format)
        local hour = tonumber(time["hour"])
        if hour == 10 then
            if tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                TriggerClientEvent('FR:announceRestart', -1, 60, true)
                TriggerEvent('FR:restartTime', 60)
                TriggerClientEvent('FR:CloseToRestart', -1)
                Online = false
            end
        end
    end
end)

RegisterServerEvent("FR:restartTime")
AddEventHandler("FR:restartTime", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(FR.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
