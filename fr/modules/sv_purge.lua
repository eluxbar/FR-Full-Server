local weaponcfg = module("fr-assets", "cfg/weapons").weapons
local purgeLB = {}
local weapons = {
    "WEAPON_MK14", "WEAPON_MP5K", "WEAPON_WINCHESTER12", "WEAPON_YELLOWM4A1S", "WEAPON_BOMBGLOCK18C",
    "WEAPON_PYTHON", "WEAPON_REVOLVER357", "WEAPON_TEMPERED", "WEAPON_CQ300",
    "WEAPON_M1911", "WEAPON_CBMOSIN", "WEAPON_MOSIN", "WEAPON_WAZEYCHAINSLMG",
    "WEAPON_BERETTA", "WEAPON_STAC", "WEAPON_GOLDAK", "WEAPON_ROOK", "WEAPON_CBHONEYBADGER",
    "WEAPON_SPAZ", "WEAPON_OLYMPIA", "WEAPON_M4A1SPURPLE", "WEAPON_ANIMEM16",
    "WEAPON_UZI", "WEAPON_UMP45", "WEAPON_AKM", "WEAPON_PUNISHER1911", "WEAPON_SPAR16", "WEAPON_SCORPBLUE",
    "WEAPON_SPACEFLIGHTMP5", "WEAPON_MPX", "WEAPON_M249PLAYMAKER", "WEAPON_AK200", "WEAPON_NERFMOSIN", "WEAPON_MK1EMR", "WEAPON_MXM", "WEAPON_WESTYARES",
    "WEAPON_TEC9", "WEAPON_BLACKICEGLOCK", "WEAPON_SUPDEAGLE"
}

local sniperweapons = {
    "WEAPON_CBMOSIN", "WEAPON_MOSIN", "WEAPON_STAC", "WEAPON_MK14", "WEAPON_NERFMOSIN"
}

local function GenGun()
    return sniperweapons[math.random(1, #sniperweapons)]
end

AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        table.insert(purgeLB, {name = FR.getPlayerName(source), user_id = user_id, kills = 0})
    end
end)

RegisterServerEvent('FR:purgeClientHasSpawned')
AddEventHandler('FR:purgeClientHasSpawned', function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    local gun = tostring(GenGun())
    if FR.isPurge() then
        Wait(100)
        FRclient.giveWeapons(source, {{[gun] = {ammo = 250}}, false})
        TriggerClientEvent("FR:purgeGetWeapon", source)
    else
        TriggerEvent("FR:acBan", user_id, 11, name, source, "Attempting To Trigger FR:purgeClientHasSpawned")
    end
end)

RegisterServerEvent('FR:getTopFraggers')
AddEventHandler('FR:getTopFraggers', function()
    local source = source
    local user_id = FR.getUserId(source)
    TriggerClientEvent('FR:gotTopFraggers', source, purgeLB, GetUserKills(user_id))
end)

RegisterServerEvent('FR:AddKill')
AddEventHandler('FR:AddKill', function(killer)
    if source == '' then
        for _, v in pairs(purgeLB) do
            if v.user_id == killer then
                v.kills = v.kills + 1
                TriggerClientEvent('FR:gotTopFraggers', FR.getUserSource(killer), purgeLB, v.kills)
                break 
            end
        end
    else
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        TriggerEvent("FR:acBan", user_id, 11, name, source, "Attempting To Trigger FR:AddKill")
    end
end)

function GetUserKills(user_id)
    for _, v in pairs(purgeLB) do
        if v.user_id == user_id then
            return v.kills
        end
    end
end


-- Command To Check leaderboard chat message -- top 3
RegisterCommand("purgelb", function(source, args, rawCommand)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    if FR.isPurge() then
        table.sort(
            purgeLB,
            function(a, b)
                return a.kills > b.kills
            end
        )
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Purge", "Top 3 Players"}
        })
        for i = 1, 3 do
            local v = purgeLB[i]
            if v then
                TriggerClientEvent('chat:addMessage', source, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {i .. ". " .. v.name .. " - " .. v.kills .. " Kills"}
                })
            end
        end
    end
end)
