local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('FR:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('FR:trainingWorldOpen', source, FR.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("FR:trainingWorldCreate")
AddEventHandler("FR:trainingWorldCreate", function()
    local source = source
    local user_id = FR.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    FR.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        FRclient.notify(source, {"This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        FRclient.notify(source, {"You already have a world, please delete it first."})
                        return
                    end
                end
            end
            FR.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = FR.getPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                FR.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('FR:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                FRclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            FRclient.notify(source, {"Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("FR:trainingWorldRemove")
AddEventHandler("FR:trainingWorldRemove", function(world)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('FR:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = FR.getUserSource(v)
                if memberSource ~= nil then
                    FR.setBucket(memberSource, 0)
                    FRclient.notify(memberSource, {"~w~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("FR:trainingWorldJoin")
AddEventHandler("FR:trainingWorldJoin", function(world)
    local source = source
    local user_id = FR.getUserId(source)
    FR.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            FRclient.notify(source, {"Invalid Password."})
            return
        else
            FR.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            FRclient.notify(source, {"~w~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("FR:trainingWorldLeave")
AddEventHandler("FR:trainingWorldLeave", function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.setBucket(source, 0)
    FRclient.notify(source, {"~w~You have left the training world."})
end)

