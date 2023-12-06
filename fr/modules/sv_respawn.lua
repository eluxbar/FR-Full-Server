local cfg=module("cfg/cfg_respawn")

RegisterNetEvent("FR:SendSpawnMenu")
AddEventHandler("FR:SendSpawnMenu",function()
    local source = source
    local user_id = FR.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if FR.hasPermission(FR.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['fr']:execute("SELECT * FROM `fr_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            if FR.isPurge() then
                TriggerClientEvent("FR:purgeSpawnClient",source)
            else
                TriggerClientEvent("FR:OpenSpawnMenu",source,spawnTable)
                FR.clearInventory(user_id) 
                FRclient.setPlayerCombatTimer(source, {0})
            end
        end
    end)
end)