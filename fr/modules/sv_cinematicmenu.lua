RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('FR:openCinematicMenu', source)
    end
end)