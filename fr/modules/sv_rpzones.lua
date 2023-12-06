local rpZones = {}
local numRP = 0
RegisterServerEvent("FR:createRPZone")
AddEventHandler("FR:createRPZone", function(a)
	local source = source
	local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('FR:createRPZone', -1, a)
    end
end)

RegisterServerEvent("FR:removeRPZone")
AddEventHandler("FR:removeRPZone", function(b)
	local source = source
	local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('FR:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('FR:createRPZone', source, v)
        end
    end
end)
