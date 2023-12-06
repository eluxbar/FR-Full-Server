spawning = true
local a = {}
local b = false
local c = 0
local d = 300
local e = false
local f = 100
local g = false
local h
local i = GetGameTimer()
local j = 0
local k = 102
local l = 0
WeaponNames = {}
local m = module("fr-assets", "cfg/weapons")
local n = module("cfg/cfg_respawn")
local o = {}
local p = {}
Citizen.CreateThread(
    function()
        p = m.nativeWeaponModelsToNames
        for q, r in pairs(m.weapons) do
            p[q] = r.name
        end
        for q, s in pairs(p) do
            WeaponNames[GetHashKey(q)] = s
            o[GetHashKey(q)] = q
        end
        local t = module("cfg/cfg_housing")
        for u, v in pairs(t.homes) do
            n.spawnLocations[u] = {
                name = u,
                coords = vector3(v.entry_point[1], v.entry_point[2], v.entry_point[3]),
                permission = {},
                image = v.image or "https://cdn.cmg.city/content/fivem/houses/citysmallhome.png",
                price = 5000
            }
        end
    end
)
local w = -1
RegisterNetEvent(
    "FR:setNHSCallerId",
    function(x)
        w = x
    end
)
AddEventHandler(
    "FR:countdownEnded",
    function()
        e = true
    end
)
Citizen.CreateThread(
    function()
        while true do
            if IsDisabledControlJustPressed(0, 38) then
                if b and not g then
                    local y = GetEntityCoords(GetPlayerPed(-1))
                    if not tFR.isPlayerInRedZone() and not tFR.isPlayerInTurf() then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        TriggerServerEvent("FR:NHSComaCall")
                        TriggerEvent("FR:DEATH_SCREEN_NHS_CALLED")
                    end
                    g = true
                elseif e and b then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    TriggerEvent("FR:CLOSE_DEATH_SCREEN")
                    tFR.respawnPlayer()
                    g = false
                    if w ~= -1 then
                        TriggerServerEvent("FR:endNHSCall", w)
                    end
                    TriggerEvent("FR:respawnKeyPressed")
                    TriggerServerEvent("FR:SendSpawnMenu")
                end
                Wait(1000)
            end
            Wait(0)
        end
    end
)
local function z()
    local A = tFR.getPlayerCoords()
    for B, C in pairs(GetGamePool("CPed")) do
        if IsEntityDead(C) and not IsPedAPlayer(C) and #(GetEntityCoords(C, true) - A) < 25.0 then
            local D = GetEntityModel(C)
            if D == "mp_m_freemode_01" or D == "mp_f_freemode_01" then
                DeleteEntity(C)
            end
        end
    end
end
Citizen.CreateThread(
    function()
        Wait(500)
        setAutoSpawn(false)
        while true do
            Wait(0)
            local C = GetPlayerPed(-1)
            local E = GetEntityHealth(C)
            if IsEntityDead(GetPlayerPed(-1)) and not b then
                pbCounter = 100
                local F = GetEntityCoords(GetPlayerPed(-1), true)
                if currentBackpack then
                    TriggerEvent("FR:removeBackpack")
                end
                if not tFR.globalOnPoliceDuty() then
                    TriggerServerEvent("FR:forceStoreWeapons")
                end
                tFR.ejectVehicle()
                b = true
                h = F
                TriggerServerEvent("FR:getNumOfNHSOnline")
                tFR.setArmour(0)
                tFR.updateHealth(true)
                Wait(250)
            end
            if f <= 0 then
                f = 100
                local G = GetEntityHealth(GetPlayerPed(-1))
                while G <= 100 do
                    Wait(0)
                    local H = tFR.getPosition()
                    local I = PlayerPedId()
                    tFR.setHealth(200)
                    NetworkResurrectLocalPlayer(H.x, H.y, H.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
                    DeleteEntity(I)
                    G = GetEntityHealth(GetPlayerPed(-1))
                end
                tFR.setHealth(102)
                SetEntityInvincible(GetPlayerPed(-1), true)
                a = getRandomComaAnimation()
                tFR.loadAnimDict(a.dict)
                TaskPlayAnim(GetPlayerPed(-1), a.dict, a.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0)
                RemoveAnimDict(a.dict)
                z()
            end
            if E > k and b then
                if IsEntityDead(GetPlayerPed(-1)) then
                    local H = tFR.getPosition()
                    local I = PlayerPedId()
                    tFR.setHealth(200)
                    NetworkResurrectLocalPlayer(H.x, H.y, H.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
                    DeleteEntity(I)
                    Wait(0)
                end
                TriggerEvent("FR:CLOSE_DEATH_SCREEN")
                c = 0
                pbCounter = 100
                e = false
                tFR.disableComa()
                f = 100
                SetEntityInvincible(GetPlayerPed(-1), false)
                ClearPedSecondaryTask(GetPlayerPed(-1))
                Citizen.CreateThread(
                    function()
                        Wait(500)
                        ClearPedSecondaryTask(GetPlayerPed(-1))
                        ClearPedTasks(GetPlayerPed(-1))
                    end
                )
            end
            local E = GetEntityHealth(GetPlayerPed(-1))
            if E <= k and not b then
                tFR.setHealth(0)
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if b then
                local I = PlayerPedId()
                if not IsEntityDead(I) then
                    if a.dict == nil then
                        a = getRandomComaAnimation()
                    end
                    if not IsEntityPlayingAnim(I, a.dict, a.anim, 3) and not tFR.isUsingStretcher() then
                        if a.dict ~= nil then
                            tFR.loadAnimDict(a.dict)
                            TaskPlayAnim(I, a.dict, a.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0)
                            RemoveAnimDict(a.dict)
                        end
                    end
                end
                if GetEntityHealth(I) > k then
                    tFR.disableComa()
                    if IsEntityDead(I) then
                        local H = tFR.getPosition()
                        local J = PlayerPedId()
                        tFR.setHealth(200)
                        NetworkResurrectLocalPlayer(H.x, H.y, H.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
                        DeleteEntity(J)
                        Wait(0)
                    end
                    c = 0
                    pbCounter = 100
                    tFR.disableComa()
                    f = 100
                    SetEntityInvincible(I, false)
                    ClearPedSecondaryTask(I)
                end
            end
            Wait(0)
        end
    end
)
function tFR.RevivePlayer()
    local C = GetPlayerPed(-1)
    if IsEntityDead(C) then
        local H = tFR.getPosition()
        local I = PlayerPedId()
        tFR.setHealth(200)
        NetworkResurrectLocalPlayer(H.x, H.y, H.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
        DeleteEntity(I)
        Citizen.Wait(0)
    end
    local K = PlayerId()
    SetPlayerControl(K, true, false)
    if not IsEntityVisible(C) then
        SetEntityVisible(C, true)
    end
    if not IsPedInAnyVehicle(C) then
        SetEntityCollision(C, true)
    end
    FreezeEntityPosition(C, false)
    SetPlayerInvincible(K, false)
    tFR.setHealth(200)
    tFR.disableComa()
    f = 100
    local C = GetPlayerPed(-1)
    SetEntityInvincible(C, false)
    ClearPedSecondaryTask(GetPlayerPed(-1))
    Citizen.CreateThread(
        function()
            Wait(500)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            ClearPedTasks(GetPlayerPed(-1))
        end
    )
    TriggerEvent("FR:CLOSE_DEATH_SCREEN")
    if w ~= -1 then
        TriggerServerEvent("FR:endNHSCall", w)
    end
end
RegisterNetEvent(
    "FR:getNumberOfDocsOnline",
    function(L)
        if not tFR.isPurge() then
            if tFR.isPlayerInRedZone() or tFR.isPlayerInTurf() then
                bleedoutDuration = 50000
            elseif L >= 3 and L <= 5 and not globalNHSOnDuty then
                bleedoutDuration = 170000
            elseif L >= 3 and not globalNHSOnDuty then
                bleedoutDuration = 290000
            else
                bleedoutDuration = 50000
            end
            c = bleedoutDuration + 10000
        else
            c = 5000
        end
        d = c / 1000
        f = 10
        i = GetGameTimer()
        j = c
        local M = false
        if not tFR.isPurge() then
            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                M = true
            else
                TriggerEvent("FR:IsInMoneyComa", true)
                ExecuteCommand("storeallweapons")
                if not tFR.globalOnPoliceDuty() then
                    TriggerServerEvent("FR:InComa")
                end
                FRserver.MoneyDrop()
            end
        end
        CreateThread(
            function()
                local N = GetGameTimer()
                while tFR.getKillerInfo().ready == nil do
                    Wait(0)
                end
                local O = tFR.getKillerInfo()
                local P = false
                if O.name == nil then
                    P = true
                end
                e = false
                TriggerEvent("FR:SHOW_DEATH_SCREEN", d, O.name or "N/A", O.user_id or "N/A", O.weapon or "N/A", P)
            end
        )
        if not tFR.isPurge() then
            while f <= 10 and f >= 0 do
                Wait(1000)
                f = f - 1
            end
            if M then
                TriggerEvent("FR:IsInMoneyComa", true)
                ExecuteCommand("storeallweapons")
                if not tFR.globalOnPoliceDuty() then
                    TriggerServerEvent("FR:InComa")
                end
                FRserver.MoneyDrop()
            end
        end
    end
)
local Q = 0
RegisterNetEvent(
    "FR:OpenSpawnMenu",
    function(R)
        DoScreenFadeIn(1000)
        TriggerScreenblurFadeIn(100.0)
        tFR.hideUI()
        SetPlayerControl(PlayerId(), false, 0)
        local I = PlayerPedId()
        local S = tFR.getPlayerCoords()
        FreezeEntityPosition(I, true)
        SetEntityCoordsNoOffset(I, S.x, S.y, -100.0, false, false, false)
        TriggerEvent("FR:removeBackpack")
        Q =
            CreateCameraWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            675.57568359375,
            1107.1724853516,
            375.29666137695,
            0.0,
            0.0,
            0.0,
            65.0,
            0,
            2
        )
        SetCamActive(Q, true)
        RenderScriptCams(true, true, 0, true, false)
        SetCamParams(Q, -1024.6506347656, -2712.0234375, 79.889106750488, 0.0, 0.0, 0.0, 65.0, 250000, 0, 0, 2)
        local T = {}
        for B, u in pairs(R) do
            if n.spawnLocations[u] then
                table.insert(T, n.spawnLocations[u])
            end
        end
        TriggerEvent("FRDEATHUI:openSpawnMenu", T)
    end
)
AddEventHandler(
    "FR:respawnButtonClicked",
    function(U, V)
        if V and V > 0 then
            TriggerServerEvent("FR:takeAmount", V)
        end
        local W = n.spawnLocations[U].coords
        TriggerEvent("FR:playGTAIntro")
        allowedWeapons = {}
        if tFR.isHandcuffed() then
            TriggerEvent("FR:toggleHandcuffs", false)
        end
        SetEntityCoords(PlayerPedId(), W)
        SetEntityVisible(PlayerPedId(), true, 0)
        SetPlayerControl(PlayerId(), true, 0)
        SetFocusPosAndVel(W.x, W.y, W.z + 1000)
        DestroyCam(Q)
        local X = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", W.x, W.y, W.z + 1000.0, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActive(X, true)
        RenderScriptCams(true, true, 0, true, false)
        SetCamParams(X, W.x, W.y, W.z, 0.0, 0.0, 0.0, 65.0, 5000, 0, 0, 2)
        Wait(2500)
        ClearFocus()
        Wait(2000)
        FreezeEntityPosition(PlayerPedId(), false)
        DestroyCam(X)
        RenderScriptCams(false, true, 2000, false, false)
        TriggerScreenblurFadeOut(2000.0)
        tFR.showUI()
        ClearFocus()
    end
)
function tFR.respawnPlayer()
    DoScreenFadeOut(1000)
    c = 0
    pbCounter = 100
    e = false
    SetEntityInvincible(PlayerPedId(), false)
    Wait(1000)
    local I = PlayerPedId()
    local y = GetEntityCoords(I)
    SetEntityCoordsNoOffset(I, y.x, y.y, y.z, false, false, false)
    tFR.setHealth(200)
    NetworkResurrectLocalPlayer(y.x, y.y, y.z, 0.0, true, true)
    DeleteEntity(I)
    ClearPedTasksImmediately(I)
    RemoveAllPedWeapons(I)
    TriggerServerEvent("FR:playerRespawned")
    MumbleSetActive(true)
    if GetConvar("voice_externalAddress", "") ~= "" and GetConvarInt("voice_externalPort", 0) ~= 0 then
        MumbleSetServerAddress(GetConvar("voice_externalAddress", ""), GetConvarInt("voice_externalPort", 0))
        while not MumbleIsConnected() do
            Wait(250)
        end
    end
end
function tFR.disableComa()
    b = false
    g = false
end
function tFR.isInComa()
    return b
end
local Y = false
function tFR.isTazed(Z)
    return Y or IsPedBeingStunned(PlayerPedId(), 0) or tFR.isPedBeingTackled() or
        isInGreenzone and not globalOnPoliceDuty and not Z
end
function tFR.isTazedByRevive()
    return Y
end
RegisterNetEvent(
    "TriggerTazer",
    function()
        Y = true
        tFR.setCanAnim(false)
        local I = PlayerPedId()
        tFR.loadClipSet("move_m@drunk@verydrunk")
        SetPedMinGroundTimeForStungun(I, 15000)
        SetPedMovementClipset(I, "move_m@drunk@verydrunk", 1.0)
        RemoveClipSet("move_m@drunk@verydrunk")
        SetTimecycleModifier("spectator5")
        SetPedIsDrunk(I, true)
        Wait(15000)
        Y = false
        tFR.setCanAnim(true)
        SetPedMotionBlur(I, true)
        Wait(60000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(I, 0)
        SetPedIsDrunk(I, false)
        SetPedMotionBlur(I, false)
    end
)
function getRandomComaAnimation()
    local _ = {
        {"combat@damage@writheidle_a", "writhe_idle_a"},
        {"combat@damage@writheidle_a", "writhe_idle_b"},
        {"combat@damage@writheidle_a", "writhe_idle_c"},
        {"combat@damage@writheidle_b", "writhe_idle_d"},
        {"combat@damage@writheidle_b", "writhe_idle_e"},
        {"combat@damage@writheidle_b", "writhe_idle_f"},
        {"combat@damage@writheidle_c", "writhe_idle_g"},
        {"combat@damage@rb_writhe", "rb_writhe_loop"},
        {"combat@damage@writhe", "writhe_loop"}
    }
    local a0 = {}
    local a1, a2 = table.unpack(_[math.random(1, #_)])
    a0["dict"] = a1
    a0["anim"] = a2
    return a0
end
local O = {}
function tFR.getKillerInfo()
    return O
end
Citizen.CreateThread(
    function()
        Wait(10000)
        local a3, a4, a5, a6, q
        while true do
            Citizen.Wait(0)
            if IsEntityDead(PlayerPedId()) and not tFR.isPedScriptGuidChanging() then
                Citizen.Wait(500)
                local a7 = GetPedSourceOfDeath(PlayerPedId())
                a5 = GetPedCauseOfDeath(PlayerPedId())
                a6 = WeaponNames[a5]
                q = o[a5]
                if IsEntityAPed(a7) and IsPedAPlayer(a7) then
                    a4 = NetworkGetPlayerIndexFromPed(a7)
                elseif
                    IsEntityAVehicle(a7) and IsEntityAPed(GetPedInVehicleSeat(a7, -1)) and
                        IsPedAPlayer(GetPedInVehicleSeat(a7, -1))
                 then
                    a4 = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(a7, -1))
                end
                local a8 = tFR.getPedServerId(a7)
                if inOrganHeist then
                    TriggerServerEvent("FR:diedInOrganHeist", a8)
                    tFR.setDeathInOrganHeist()
                end
                local a9 = false
                local aa = 0
                if a4 == PlayerId() or a4 == nil then
                    a9 = true
                else
                    local ab = tFR.getPlayerName(a4)
                    O.name = ab
                    aa = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(a7))
                end
                O.source = a8
                O.user_id = tFR.getUserId(a8)
                O.weapon = tostring(a6)
                O.ready = true
                if GetGameTimer() < i + 10000 then
                    local a8 = tFR.getPedServerId(a7)
                    TriggerServerEvent("FR:onPlayerKilled", "killed", a8, a6, a9, aa)
                    l = 0
                elseif GetGameTimer() < i + j then
                    local a8 = tFR.getPedServerId(a7)
                    j = 0
                    TriggerServerEvent("FR:onPlayerKilled", "finished off", a8, a6)
                    l = 0
                end
                a4 = nil
                a3 = nil
                a5 = nil
                a6 = nil
            end
            while IsEntityDead(PlayerPedId()) do
                Citizen.Wait(0)
            end
            O = {}
        end
    end
)
function tFR.varyHealth(ac)
    local C = PlayerPedId()
    local ad = math.floor(GetEntityHealth(C) + ac)
    tFR.setHealth(ad)
end
function tFR.setFriendlyFire(ae)
    NetworkSetFriendlyFireOption(ae)
    SetCanAttackFriendly(GetPlayerPed(-1), ae, ae)
end
AddEventHandler(
    "FR:onClientSpawn",
    function(af, ag)
        if ag then
            local K = PlayerId()
            SetPoliceIgnorePlayer(K, true)
            SetDispatchCopsForPlayer(K, false)
            tFR.setFriendlyFire(true)
        end
    end
)
