RegisterServerEvent('FR:setCarDevMode')
AddEventHandler('FR:setCarDevMode', function(status)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and FR.hasPermission(user_id, "cardev.menu") then 
      if status then
        FR.setBucket(source, 333)
      else
        FR.setBucket(source, 0)
      end
    else
      TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)