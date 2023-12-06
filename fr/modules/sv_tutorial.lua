RegisterNetEvent('FR:checkTutorial')
AddEventHandler('FR:checkTutorial', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'TutorialDone') or FR.isPurge() then
        TriggerClientEvent('FR:setCompletedTutorial', source)
    else  
        TriggerClientEvent('FR:playTutorial', source)
        FR.setBucket(source, user_id)
        TriggerClientEvent('FR:setBucket', source, user_id)
        TriggerClientEvent('FR:setIsNewPlayer', source)
    end
end)

RegisterNetEvent('FR:setCompletedTutorial')
AddEventHandler('FR:setCompletedTutorial', function()
    local source = source
    local user_id = FR.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(-566.48754882812,-194.36938476562,39.146049499512)) <= 50.0 then
        if not FR.hasGroup(user_id, 'TutorialDone') then
            FR.addUserGroup(user_id, 'TutorialDone')
            FR.addUserGroup(user_id, 'NewPlayer')
            FR.setBucket(source, 0)
            TriggerClientEvent('FR:setBucket', source, 0)
        end
    else
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger Tutorial Done'.. ' | ' ..playerCoords)
    end
end)