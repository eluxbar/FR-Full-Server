RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    TriggerClientEvent('FR:sendLocalChat', -1, source, FR.getPlayerName(source), text)
end)