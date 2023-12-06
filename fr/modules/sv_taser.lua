RegisterServerEvent('FR:playTaserSound')
AddEventHandler('FR:playTaserSound', function(coords, sound)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('FR:reactivatePed')
AddEventHandler('FR:reactivatePed', function(id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('FR:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('FR:arcTaser')
AddEventHandler('FR:arcTaser', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
      FRclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = FR.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('FR:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('FR:barbsNoLongerServer')
AddEventHandler('FR:barbsNoLongerServer', function(id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('FR:barbsNoLonger', id)
    end
end)

RegisterServerEvent('FR:barbsRippedOutServer')
AddEventHandler('FR:barbsRippedOutServer', function(id)
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('FR:reloadTaser', source)
  end
end)