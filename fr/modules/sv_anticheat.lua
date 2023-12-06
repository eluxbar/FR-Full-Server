local a = module("fr-assets", "cfg/weapons")
a = a.weapons
local b = false
local c = {
    {type = 1, desc = "Noclip"},
    {type = 2, desc = "Spawning of Weapon(s)"},
    {type = 3, desc = "Explosion Event"},
    {type = 4, desc = "Blacklisted Event"},
    {type = 5, desc = "Removal of Weapon(s)"},
    {type = 6, desc = "Semi Godmode"},
    {type = 7, desc = "Mod Menu"},
    {type = 8, desc = "Weapon Modifier"},
    {type = 9, desc = "Armour Modifier"},
    {type = 10, desc = "Health Modifier"},
    {type = 11, desc = "Server Trigger"},
    {type = 12, desc = "Vehicle Modifications"},
    {type = 13, desc = "Night Vision"},
    {type = 14, desc = "Model Dimensions"},
    {type = 15, desc = "Godmoding"},
    {type = 16, desc = "Failed Keep Alive (els)"},
    {type = 17, desc = "Spawned Ammo"},
    {type = 18, desc = "Resource Stopper"},
    {type = 19, desc = "Infinite Combat Roll"},
    {type = 20, desc = "Spawning of Weapon(s)"},
    {type = 21, desc = "Teleport to Waypoint"},
    {type = 22, desc = "Vehicle Repair"},
    {type = 23, desc = "Spectate"},
    {type = 24, desc = "Freecam"},
    {type = 25, desc = "Warping into Vehicle"},
    {type = 26, desc = "NUI Tools"},
    {type = 27, desc = "Invisible"},
    {type = 28, desc = "Fast Run"},
}
RegisterServerEvent("FR:acType1")
AddEventHandler(
    "FR:acType1",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        if not table.includes(carrying, source) then
            Wait(500)
            TriggerEvent("FR:acBan", user_id, 1, name, source)
        end
    end
)

RegisterServerEvent("FR:AntiCheatVehicle")
AddEventHandler("FR:AntiCheatVehicle", function(vehicle)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    TriggerClientEvent("FR:takeClientScreenshotAndUpload", source, FR.getWebhook("anticheat"))
    Wait(2000)
    FR.sendWebhook("anticheat","Anticheat Log","> Players Name: **" .. name .. "**\n> Players Perm ID: **" .. user_id .. "**\n> Spawned Vehicle: **" .. vehicle .. "**")
end)

RegisterServerEvent("FR:acType27")
AddEventHandler(
    "FR:acType27",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 27, name, source)
    end
)

RegisterServerEvent("FR:acType28")
AddEventHandler(
    "FR:acType28",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 28, name, source)
    end
)
function table.includes(table, f)
    for g, h in pairs(table) do
        if h == f then
            return true
        end
    end
    return false
end
local i = false
function tFR.isSpectatingEvent()
    return i
end
RegisterServerEvent("FR:acType2")
AddEventHandler(
    "FR:acType2",
    function(j)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        if j ~= "GADGET_PARACHUTE" then
            TriggerEvent("FR:acBan", user_id, 2, name, source, j)
        end
    end
)
RegisterServerEvent("FR:acType20")
AddEventHandler(
    "FR:acType20",
    function(j)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        if not string.match(j, "GADGET_PARACHUTE") then
            TriggerEvent("FR:acBan", user_id, 2, name, source, j)
        end
    end
)
AddEventHandler("clearPedTasksEvent",function(source)
    local source = source
    local user_id = FR.getUserId(source)
    local entity = NetworkGetEntityFromNetworkId(source)
    if DoesEntityExist(entity) then
        if NetworkGetEntityOwner(entity) ~= source then
            CancelEvent()
            local name = FR.getPlayerName(source)
            Wait(500)
            TriggerEvent("FR:acBan", user_id, 25, name, source)
        end
    end
end)
RegisterServerEvent("FR:acType24")
AddEventHandler("FR:acType24",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 24, name, source)
end)
RegisterServerEvent("FR:acType26")
AddEventHandler("FR:acType26",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 26, name, source)
end)
RegisterServerEvent("FR:acType23")
AddEventHandler("FR:acType23",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 23, name, source)
end)
RegisterServerEvent("FR:acType23")
AddEventHandler("FR:acType23",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 23, name, source)
end)
local k = {1, 2, 5, 32, 33, 35, 35, 36, 37, 38, 45}
AddEventHandler(
    "explosionEvent",
    function(source, l)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        for m, n in ipairs(k) do
            if l.explosionType == n then
                l.damagescale = 0.0
                CancelEvent()
                Wait(500)
                TriggerEvent("FR:acBan", user_id, 3, name, source, "Explosion Type: " .. l.explosionType)
            end
        end
    end
)
local o = {
    "esx:getSharedObject",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    "esx_dmvschool:pay"
}
for p, q in ipairs(o) do
    RegisterNetEvent(q)
    AddEventHandler(
        q,
        function()
            local source = source
            local user_id = FR.getUserId(source)
            local name = FR.getPlayerName(source)
            Wait(500)
            TriggerEvent("FR:acBan", user_id, 4, name, source, "Event: " .. q)
        end
    )
end
local blacklistedprops = {
    'prop_cs_dildo_01',
    'prop_speaker_05',
    'prop_speaker_01',
    'prop_speaker_03',
    'surano',
    'ar_prop_ar_bblock_huge_01',
    'dt1_05_build1_damage',
    'prop_juicestand',
    'prop_knife',
    'p_bloodsplat_s',
    'p_spinning_anus_s',
    'dt1_lod_slod3',
    'prop_xmas_tree_int',
    'prop_cs_cardbox_01',
    'prop_alien_egg_01',
    'prop_tv_03',
    'prop_beach_fire',
    'prop_windmill_01_l1',
    'stt_prop_stunt_track_start',
    'stt_prop_stunt_track_start_02',
    'apa_prop_flag_mexico_yt',
    'apa_prop_flag_us_yt',
    'apa_prop_flag_uk_yt',
    'prop_jetski_ramp_01',
    'prop_const_fence03b_cr',
    'prop_fnclink_03gate5',
    'ind_prop_firework_03',
    'prop_weed_01',
    'prop_weed_01',
    'xs_prop_hamburgher_wl',
    'prop_container_01a',
    'prop_contnr_pile_01a',
    'ce_xr_ctr2',
    'stt_prop_ramp_jump_xxl',
    'hei_prop_carrier_jet',
    'prop_parking_hut_2',
    'csx_seabed_rock3_',
    'db_apart_03_',
    'db_apart_09_',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'sr_prop_spec_tube_xxs_01a',
    'prop_air_bigradar',
    'p_tram_crash_s',
    'prop_fnclink_03a',
    'prop_fnclink_05crnr1',
    'xs_prop_plastic_bottle_wl',
    'prop_windmill_01',
    'prop_gold_cont_01',
    'p_cablecar_s',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'prop_ld_ferris_wheel',
    'prop_ferris_car_01',
    'p_ferris_car_01',
    'stt_prop_ramp_spiral_l',
    'stt_prop_ramp_spiral_l_l',
    'stt_prop_ramp_multi_loop_rb',
    'stt_prop_ramp_spiral_l_xxl',
    'stt_prop_ramp_spiral_xxl',
    'stt_prop_stunt_bblock_huge_01',
    'stt_prop_stunt_bblock_huge_02',
    'stt_prop_stunt_bblock_huge_03',
    'stt_prop_stunt_bblock_huge_04',
    'stt_prop_stunt_bblock_huge_05',
    'stt_prop_stunt_bblock_hump_01',
    'stt_prop_stunt_bblock_qp',
    'stt_prop_stunt_bblock_qp2',
    'stt_prop_stunt_jump_loop',
    'stt_prop_stunt_landing_zone_01',
    'stt_prop_stunt_track_dwslope45',
    'stt_prop_stunt_track_dwturn',
    'stt_prop_stunt_track_dwslope30',
    'stt_prop_stunt_track_dwsh15',
    'stt_prop_stunt_track_dwshort',
    'stt_prop_stunt_track_dwslope15',
    'stt_prop_stunt_track_dwuturn',
    'stt_prop_stunt_track_exshort',
    'stt_prop_stunt_track_fork',
    'stt_prop_stunt_track_funlng',
    'stt_prop_stunt_track_funnel',
    'stt_prop_stunt_track_hill',
    'stt_prop_stunt_track_slope15',
    'stt_prop_stunt_track_slope30',
    'stt_prop_stunt_track_slope45',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_gas_pump_1d',
    'prop_rock_1_a',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'apa_mp_h_acc_box_trinket_01',
    'prop_roundbailer02',
    'prop_roundbailer01',
    'prop_container_05a',
    'stt_prop_stunt_bowling_ball',
    'apa_mp_h_acc_rugwoolm_03',
    'prop_container_ld2',
    'p_ld_stinger_s',
    'hei_prop_carrier_cargo_02a',
    'p_cablecar_s',
    'p_ferris_car_01',
    'prop_rock_4_big2',
    'prop_steps_big_01',
    'v_ilev_lest_bigscreen',
    'prop_carcreeper',
    'apa_mp_h_bed_double_09',
    'apa_mp_h_bed_wide_05',
    'prop_cattlecrush',
    'prop_cs_documents_01',
    'prop_construcionlamp_01',
    'prop_fncconstruc_01d',
    'prop_fncconstruc_02a',
    'p_dock_crane_cabl_s',
    'prop_dock_crane_01',
    'prop_dock_crane_02_cab',
    'prop_dock_float_1',
    'prop_dock_crane_lift',
    'apa_mp_h_bed_wide_05',
    'apa_mp_h_bed_double_08',
    'apa_mp_h_bed_double_09',
    'csx_seabed_bldr4_',
    'imp_prop_impexp_sofabed_01a',
    'apa_mp_h_yacht_bed_01',
    'cs4_lod_04_slod2',
    'dt1_05_build1_damage',
    'po1_lod_slod4',
    'id2_lod_slod4',
    'ap1_lod_slod4',
    'sm_lod_slod2_22',
    'prop_ld_ferris_wheel',
    'prop_container_05a',
    'prop_gas_tank_01a',
    'p_crahsed_heli_s',
    'prop_gas_pump_1d',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'prop_gascyl_01a',
    'prop_ld_toilet_01',
    'prop_ld_bomb_anim',
    'prop_ld_farm_couch01',
    'prop_beachflag_le',
    'stt_prop_stunt_track_uturn',
    'stt_prop_stunt_track_turnice',
    'cargoplane',
    `prop_beach_fire`,
    `xs_prop_hamburgher_wl`,
    `prop_fnclink_05crnr1`,
    -1207431159,
    -145066854,
    `stt_prop_stunt_soccer_ball`,
    `sr_prop_spec_tube_xxs_01a`
}

AddEventHandler("entityCreated", function(entity)
    if DoesEntityExist(entity) then
        local entityOwner = NetworkGetEntityOwner(entity)
        if blacklistedprops[entity] then
            DeleteEntity(entity)
        end
    end
end)
AddEventHandler(
    "removeWeaponEvent",
    function(r, s)
        CancelEvent()
        local source = r
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 5, name, source)
    end
)
AddEventHandler(
    "giveWeaponEvent",
    function(source)
        CancelEvent()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 2, name, source)
    end
)
AddEventHandler(
    "loadModel",
    function(source)
        CancelEvent()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 5, name, source)
    end
)
AddEventHandler(
    "spawnVehicle",
    function(source)
        CancelEvent()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 5, name, source)
    end
)
AddEventHandler(
    "GetAmmoInPedWeapon",
    function(source)
        CancelEvent()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 5, name, source)
    end
)
AddEventHandler(
    "removeAllWeaponsEvent",
    function(source)
        CancelEvent()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 5, name, source)
    end
)
RegisterServerEvent("FR:acType6")
AddEventHandler(
    "FR:acType6",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 6, name, source)
    end
)
RegisterServerEvent("FR:acType7")
AddEventHandler(
    "FR:acType7",
    function(t)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 7, name, source, t)
    end
)
RegisterServerEvent("FR:acType8")
AddEventHandler(
    "FR:acType8",
    function(u)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 8, name, source, u)
    end
)
RegisterServerEvent("FR:acType9")
AddEventHandler(
    "FR:acType9",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 9, name, source)
    end
)
RegisterServerEvent("FR:acType10")
AddEventHandler(
    "FR:acType10",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 10, name, source)
    end
)
RegisterServerEvent("FR:acType11")
AddEventHandler(
    "FR:acType11",
    function(u)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 11, name, source, u)
    end
)
RegisterServerEvent("FR:acType12")
AddEventHandler(
    "FR:acType12",
    function(u)
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 12, name, source, u)
    end
)
RegisterServerEvent("FR:acType13")
AddEventHandler(
    "FR:acType13",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 13, name, source)
    end
)
RegisterServerEvent("FR:acType14")
AddEventHandler(
    "FR:acType14",
    function()
        local source = source
        local user_id = FR.getUserId(source)
        local name = FR.getPlayerName(source)
        Wait(500)
        TriggerEvent("FR:acBan", user_id, 14, name, source)
    end
)
RegisterServerEvent("FR:acType15")
AddEventHandler("FR:acType15",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 15, name, source)
end)
RegisterServerEvent("FR:acType16")
AddEventHandler("FR:acType16",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    TriggerEvent("FR:acBan", user_id, 16, name, source)
end)
RegisterServerEvent("FR:sendVelocityLimit")
AddEventHandler("FR:sendVelocityLimit",function(x, y)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    
    if #(x - vector3(196.24597167969, 7397.2084960938, 14.497759819031)) < 150.0 or
        #(y - vector3(196.24597167969, 7397.2084960938, 14.497759819031)) < 150.0 or
        FR.hasPermission(user_id, "admin.tickets") then
        return
    end
    TriggerEvent("FR:acBan", user_id, 21, name, source, "1st: "..x.."  |  2nd: "..y.."")
end)

RegisterServerEvent("FR:acType18")
AddEventHandler("FR:acType18",function(z)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    if z == "fr" then
        return
    end
    TriggerEvent("FR:acBan", user_id, 18, name, source, z)
end)
RegisterServerEvent("FR:acType19")
AddEventHandler("FR:acType19",function()
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    Wait(500)
    TriggerEvent("FR:acBan", user_id, 19, name, source)
end)
RegisterServerEvent("FR:acBan")
AddEventHandler(
    "FR:acBan",
    function(d, A, e, B, u)
        local C = ""
        local D = ""
        if u == nil then
            u = "None"
        end
        if d == 0 or d == 1 or d == 2 then
            print("Ban Type: " .. A, "Name: " .. e, "Extra: " .. u)
            return
        end
        if source == "" then
            if not b then
                for m, n in pairs(c) do
                    if A == n.type then
                        D = "Type #" .. A
                        C = n.desc
                    end
                end
                print("Ban Type: " .. A, "Name: " .. e, "Extra: " .. u)
                b = true
                TriggerClientEvent("FR:takeClientScreenshotAndUpload", B, FR.getWebhook("anticheat"))
                Wait(2000)
                b = false
                FR.sendWebhook(
                    "anticheat",
                    "Anticheat Ban",
                    "> Players Name: **" ..
                        e ..
                            "**\n> Players Perm ID: **" ..
                                d ..
                                    "**\n> Reason: **" ..
                                        D .. "**\n> Type Meaning: **" .. C .. "**\n> Extra Info: **" .. u .. "**"
                )
                TriggerClientEvent(
                    "chatMessage",
                    -1,
                    "^7^*[FR Anticheat]",
                    {180, 0, 0},
                    e .. " ^7 Was Banned | Reason: Cheating " .. D,
                    "alert"
                )
                FR.banConsole(d, "perm", "Cheating " .. D)
                exports["fr"]:execute(
                    "INSERT INTO `fr_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);",
                    {user_id = d, username = e, reason = D, extra = u},
                    function()
                    end
                )
            end
        end
    end
)
RegisterServerEvent("FR:sendVehicleStats",function(Afterbodyhealth,previousbodyhealth,Afterenginehealth,previousenginehealth,Afterpetroltankhealth,previouspetroltankhealth,Afterentityhealth,previousentityhealth,passangers,vehiclehash)
    local source = source
    local user_id = FR.getUserId(source)
    local name = FR.getPlayerName(source)
    TriggerEvent("FR:acBan", user_id, 22, name, source, "**\n> Spawn Code: **"..vehiclehash.."**\n> Body Health: **"..previousbodyhealth.."**\n> Engine Health: **"..previousenginehealth.."**\n> Petrol Tank Health: **"..previouspetroltankhealth.."**\n> Entity Health: **"..previousentityhealth.."**\n> After Body Health: **"..Afterbodyhealth.."**\n> After Engine Health: **"..Afterenginehealth.."**\n> After Petrol Tank Health: **"..Afterpetroltankhealth.."**\n> After Entity Health: **"..Afterentityhealth.."****")
end)

function tFR.checkid(d, Q)
    if Q == 0 then
        return
    end
    if d ~= Q then
        FR.sendWebhook(
            "multi-account",
            "FR Multi Account Logs",
            "> Player Current Perm ID: **" .. d .. "**\n> Player Other Perm ID: **" .. Q .. "**"
        )
    end
    FR.isBanned(
        Q,
        function(R)
            if R then
                --FR.banConsole(d, "perm", "1.11 Ban Evading")
                FR.sendWebhook(
                    "ban-evaders",
                    "FR Ban Evade Logs",
                    "> Player Name: **"..e.."**\n> Player Current Perm ID: **" .. d .. "**\n> Player Banned Perm ID: **" .. Q .. "**"
                )
            end
        end
    )
end
decor = {}
decor = generateUUID("decor", 15, "alphanumeric")
Citizen.CreateThread(
    function()
        Wait(2500)
        exports["fr"]:execute(
            [[
    CREATE TABLE IF NOT EXISTS `fr_anticheat` (
    `ban_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(100) NOT NULL,
    `extra` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ban_id`)
    );]]
        )
    end
)


RegisterCommand("crashplayer", function(source, args)
    local user_id = FR.getUserId(source)
    if source == 0 or user_id == 0 then
        if args[1] ~= nil then
            print("FR - Crashing Player: "..args[1])
            FRclient.isPlayerLoading(FR.getUserSource(tonumber(args[1])), {})
        end
    else
        print("FR - Crashing Player: "..user_id)
        FRclient.isPlayerLoading(source, {})
    end
end)

        
AddEventHandler("fg:BanHandler", function(BanId, data, additional_info, screenshot_url)
    local license = data.license
    exports['fr']:execute('SELECT * FROM fr_users WHERE license = @license', {['@license'] = license}, function(result)
        if result and #result > 0 then
            local userInfo = result[1]
            local user_id = userInfo.id
            local username = userInfo.username
            local reason = "Cheating Five Guard"
            local extra = additional_info
            local date = os.date("%c")
            if extra == nil then
                extra = "None"
            end
            if screenshot_url == nil then
                screenshot_url = "None"
            end
            FR.setBanned(user_id, true, "perm", reason, "Five Gaurd AntiCheat", extra)
            exports['fr-ac']:UnbanId(BanId)
            exports['fr']:execute('INSERT INTO `fr_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);', {
                ['user_id'] = user_id,
                ['username'] = username,
                ['reason'] = reason,
                ['extra'] = extra
            }, function()
            end)
            FR.sendWebhook("anticheat","Anticheat Ban","> Players Name: **" .. username .."**\n> Players Perm ID: **" .. user_id .."**\n> Reason: **" .. data.reason .. "**\n> Extra Info: **" .. extra .. "**")
            PerformHttpRequest(FR.getWebhook("anticheat"),function(N, O, P)end,"POST",json.encode({username = "FR Anticheat", content = screenshot_url}),{["Content-Type"] = "application/json"})
            TriggerClientEvent("chatMessage", -1, "^7^*[FR Anticheat]", {180, 0, 0}, username.." ^7Was Banned | Reason: Cheating Five Guard", "alert")
        end
    end)
end)
