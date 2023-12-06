loadouts = {
    ['Basic'] = {
        permission = "police.armoury",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_G36K",
        },
    },
    ['CTSFO'] = {
        permission = "police.maxarmour",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_SPAR17",
            "WEAPON_REMINGTON700",
            "WEAPON_FLASHBANG",
        },
    },
    ['Tom'] = {
        permission = "group.add.founder",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_NOVESKENSR9",
            "WEAPON_AX50",
            "WEAPON_NONMP5",
            "WEAPON_FLASHBANG",
        },
    },
}


RegisterNetEvent('FR:getPoliceLoadouts')
AddEventHandler('FR:getPoliceLoadouts', function()
    local source = source
    local user_id = FR.getUserId(source)
    local loadoutsTable = {}
    if FR.hasPermission(user_id, 'police.armoury') then
        for k,v in pairs(loadouts) do
            v.hasPermission = FR.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('FR:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('FR:selectLoadout')
AddEventHandler('FR:selectLoadout', function(loadout)
    local source = source
    local user_id = FR.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if FR.hasPermission(user_id, 'police.armoury') and FR.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    FRclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                    FRclient.setArmour(source, {100, true})
                end
                FRclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                FRclient.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)