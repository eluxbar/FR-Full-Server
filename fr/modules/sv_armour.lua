RegisterNetEvent("FR:getArmour")
AddEventHandler("FR:getArmour",function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, "police.armoury") then
        if FR.hasPermission(user_id, "police.maxarmour") then
            FRclient.setArmour(source, {100, true})
        elseif FR.hasGroup(user_id, "Inspector Clocked") then
            FRclient.setArmour(source, {75, true})
        elseif FR.hasGroup(user_id, "Senior Constable Clocked") or FR.hasGroup(user_id, "Sergeant Clocked") then
            FRclient.setArmour(source, {50, true})
        elseif FR.hasGroup(user_id, "PCSO Clocked") or FR.hasGroup(user_id, "PC Clocked") then
            FRclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("FR:PlaySound", source, "playMoney")
        FRclient.notify(source, {"~g~You have received your armour."})
    else
        local player = FR.getUserSource(user_id)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)