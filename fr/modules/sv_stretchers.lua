RegisterServerEvent("FR:stretcherAttachPlayer")
AddEventHandler('FR:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("FR:toggleAmbulanceDoors")
AddEventHandler('FR:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("FR:updateHasStretcherInsideDecor")
AddEventHandler('FR:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("FR:updateStretcherLocation")
AddEventHandler('FR:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:FR:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("FR:removeStretcher")
AddEventHandler('FR:removeStretcher', function(stretcher)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("FR:forcePlayerOnToStretcher")
AddEventHandler('FR:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('FR:forcePlayerOnToStretcher', id, stretcher)
    end
end)