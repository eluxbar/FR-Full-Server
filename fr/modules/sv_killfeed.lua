local f = module("fr-assets", "cfg/weapons")
f = f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

local function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Mosin Nagant' then
            return 'Heavy'
        elseif weapon == 'Nerf Mosin' then
            return 'Heavy'
        elseif weapon == 'CB Mosin' then
            return 'Heavy'
        elseif weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        elseif weapon == 'Suicide' then
            return 'Suicide'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

local function getweaponnames(weapon)
    for k,v in pairs(f) do
        if v.name == weapon then
            return v.name
        end
    end
    return "Unknown"
end

local function checkIfMosin(weapon)
    for k, v in pairs(f) do
        if v.name == weapon and string.find(weapon, "mosin") then
            return true
        end
    end
end



RegisterNetEvent('FR:onPlayerKilled')
AddEventHandler('FR:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance, combat)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    local killer_id = FR.getUserId(killer)
    if distance ~= nil then
        distance = math.floor(distance)
    end

    if killtype == 'killed' then
        if FR.hasPermission(FR.getUserId(source), 'police.armoury') then
            killedgroup = 'police'
        elseif FR.hasPermission(FR.getUserId(source), 'nhs.menu') then
            killedgroup = 'nhs'
        end

        if FR.hasPermission(FR.getUserId(killer), 'police.armoury') then
            killergroup = 'police'
        elseif FR.hasPermission(FR.getUserId(killer), 'nhs.menu') then
            killergroup = 'nhs'
        end

        if killer ~= nil then
            TriggerClientEvent('FR:newKillFeed', -1, FR.getPlayerName(killer), FR.getPlayerName(source), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup)
            TriggerClientEvent('FR:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
            if FR.isPurge then
                TriggerEvent("FR:AddKill", killer_id)
            end
            if not FR.hasPermission(killer_id,"police.armoury") and not FRclient.isStaffedOn(killer) and not FR.isDevelper(killer_id) then
                FRclient.getPlayerCombatTimer(killer,{},function(timer)
                    if timer < 57 then
                        TriggerClientEvent("FR:takeClientScreenshotAndUpload", killer, FR.getWebhook("trigger-bot"))
                        Citizen.Wait(1500)
                        FR.sendWebhook("trigger-bot", "FR Trigger Bot Logs", "> Player Name: **"..FR.getPlayerName(killer).."**\n> Player User ID: **"..FR.getUserId(killer).."**")
                    end
                end)
            end
            if not FR.isPurge() then
                if not gettingVideo then
                    gettingVideo = true
                    TriggerClientEvent("FR:takeClientVideoAndUpload", killer, FR.getWebhook('killvideo'))
                    gettingVideo = false
                    Wait(19000)
                end
            end
            if FR.getPlayerName(killer) and FR.getPlayerName(source) and FR.getUserId(killer) and FR.getUserId(source) and getweaponnames(weaponhash) and distance then
                FR.sendWebhook('kills', "FR Kill Logs", "> Killer Name: **"..FR.getPlayerName(killer).."**\n> Killer ID: **"..FR.getUserId(killer).."**\n> Weapon: **"..getweaponnames(weaponhash).."**\n> Victim Name: **"..FR.getPlayerName(source).."**\n> Victim ID: **"..FR.getUserId(source).."**\n> Distance: **"..distance.."m**")
            end
        else
            TriggerClientEvent('FR:newKillFeed', -1, FR.getPlayerName(source), FR.getPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
            TriggerClientEvent('FR:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
        end
    end
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
    local user_id = FR.getUserId(sender)
    local name = FR.getPlayerName(sender)
    if ev.weaponDamage ~= 0 then
        if ev.weaponType == 911657153 and not FR.hasPermission(user_id, 'police.armoury') or ev.weaponType == 3452007600 then
            TriggerEvent("FR:acBan", user_id, 8, name, sender, "Using a weapon that is not allowed")
        end
        FR.sendWebhook('damage', "FR Damage Logs", "> Player Name: **"..name.."**\n> Player Temp ID: **"..sender.."**\n> Player Perm ID: **"..user_id.."**\n> Damage: **"..ev.weaponDamage.."**\n> Weapon : **"..getweaponnames(ev.weaponType).."**")
    end
end)