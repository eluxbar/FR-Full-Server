local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id,"DJ") then
        TriggerClientEvent('FR:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('FR:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = FR.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = FR.getPlayerName(source)
    if FR.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('FR:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("FR:adminStopSong")
AddEventHandler("FR:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('FR:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('FR:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("FR:playDjSongServer")
AddEventHandler("FR:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('FR:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("FR:skipServer")
AddEventHandler("FR:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('FR:skipDj', -1,coords,param)
end)
RegisterServerEvent("FR:stopSongServer")
AddEventHandler("FR:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('FR:stopSong', -1,coords)
end)
RegisterServerEvent("FR:updateVolumeServer")
AddEventHandler("FR:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('FR:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("FR:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("FR:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('FR:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("FR:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("FR:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == FR.getUserSource(x) then
            TriggerClientEvent('FR:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
