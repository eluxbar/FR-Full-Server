local a = module("cfg/cfg_jewelleryHeist")
local b = false
local c = false
local d = false
local e = 0
local f = 0
local g = 0
local h
local i
local j = {}
local k = nil
local l = false
local m = false
local n = {
    {["label"] = "Confirm Selections", ["button"] = "~INPUT_CELLPHONE_EXTRA_OPTION~"},
    {["label"] = "Select", ["button"] = "~INPUT_CELLPHONE_SELECT~"},
    {["label"] = "Next Cell", ["button"] = "~INPUT_CELLPHONE_RIGHT~"},
    {["label"] = "Previous Cell", ["button"] = "~INPUT_CELLPHONE_LEFT~"}
}
local o = {{["label"] = "Select", ["button"] = "~INPUT_ATTACK~"}}
local function p(q)
    local r
    if q == "door" then
        r = n
    else
        r = o
    end
    local s = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(s) do
        Wait(0)
    end
    BeginScaleformMovieMethod(s, "CLEAR_ALL")
    BeginScaleformMovieMethod(s, "TOGGLE_MOUSE_BUTTONS")
    ScaleformMovieMethodAddParamBool(0)
    EndScaleformMovieMethod()
    for t, u in ipairs(r) do
        BeginScaleformMovieMethod(s, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(t - 1)
        ScaleformMovieMethodAddParamPlayerNameString(u["button"])
        ScaleformMovieMethodAddParamTextureNameString(u["label"])
        EndScaleformMovieMethod()
    end
    BeginScaleformMovieMethod(s, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(-1)
    EndScaleformMovieMethod()
    while m do
        Wait(0)
        DrawScaleformMovieFullscreen(s, 255, 255, 255, 255, 0)
    end
    SetScaleformMovieAsNoLongerNeeded(s)
end
RegisterNetEvent(
    "FR:jewelrySyncSetupReady",
    function(v)
        c = v
    end
)
RegisterNetEvent(
    "FR:jewelryCreateDevicePickup",
    function(w)
        f =
            tFR.addMarker(
            w.coords.x,
            w.coords.y,
            w.coords.z - 0.35,
            0.3,
            0.3,
            0.3,
            255,
            255,
            255,
            200,
            30,
            0,
            false,
            true,
            false
        )
        e = AddBlipForRadius(w.coords.x + math.random(-15, 15), w.coords.y + math.random(-15, 15), w.coords.z, 20.0)
        SetBlipColour(e, 1)
        SetBlipAlpha(e, 200)
        enter_collectDevice = function()
            drawNativeNotification("Press ~INPUT_CONTEXT~ to collect the device")
        end
        exit_collectDevice = function()
        end
        ontick_collectDevice = function()
            if IsControlJustPressed(0, 38) and not d then
                tFR.notify("~g~Collecting...")
                d = true
                local x = "anim@heists@ornate_bank@hack"
                RequestAnimDict(x)
                RequestModel("hei_prop_hst_laptop")
                RequestModel("hei_p_m_bag_var22_arm_s")
                RequestModel("hei_prop_heist_card_hack_02")
                while not HasAnimDictLoaded(x) or not HasModelLoaded("hei_prop_hst_laptop") or
                    not HasModelLoaded("hei_p_m_bag_var22_arm_s") or
                    not HasModelLoaded("hei_prop_heist_card_hack_02") do
                    Citizen.Wait(100)
                end
                local y = tFR.getPlayerPed()
                local z, A = vector3(GetEntityCoords(y)), vector3(GetEntityRotation(y))
                local B =
                    GetAnimInitialOffsetPosition(
                    x,
                    "hack_enter",
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    0,
                    2
                )
                local C =
                    GetAnimInitialOffsetPosition(
                    x,
                    "hack_loop",
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    0,
                    2
                )
                local D =
                    GetAnimInitialOffsetPosition(
                    x,
                    "hack_exit",
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    w.coords.x,
                    w.coords.y,
                    w.coords.z + 0.692,
                    0,
                    2
                )
                FreezeEntityPosition(y, true)
                SetEntityHeading(tFR.getPlayerPed(), w.h)
                local E =
                    NetworkCreateSynchronisedScene(B.x, B.y, B.z, A.x, A.y, A.z, 2, false, false, 1065353216, 0, 1.3)
                local F = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), z.x, z.y, z.z, 1, 1, 0)
                local G = CreateObject(GetHashKey("hei_prop_hst_laptop"), z.x, z.y, z.z, 1, 1, 0)
                local H = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), z.x, z.y, z.z, 1, 1, 0)
                SetModelAsNoLongerNeeded("hei_prop_hst_laptop")
                SetModelAsNoLongerNeeded("hei_p_m_bag_var22_arm_s")
                SetModelAsNoLongerNeeded("hei_prop_heist_card_hack_02")
                NetworkAddPedToSynchronisedScene(y, E, x, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(F, E, x, "hack_enter_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(G, E, x, "hack_enter_laptop", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(H, E, x, "hack_enter_card", 4.0, -8.0, 1)
                local I =
                    NetworkCreateSynchronisedScene(C.x, C.y, C.z, A.x, A.y, A.z, 2, false, true, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(y, I, x, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(F, I, x, "hack_loop_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(G, I, x, "hack_loop_laptop", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(H, I, x, "hack_loop_card", 4.0, -8.0, 1)
                local J =
                    NetworkCreateSynchronisedScene(D.x, D.y, D.z, A.x, A.y, A.z, 2, false, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(y, J, x, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(F, J, x, "hack_exit_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(G, J, x, "hack_exit_laptop", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(H, J, x, "hack_exit_card", 4.0, -8.0, 1)
                NetworkStartSynchronisedScene(E)
                NetworkStartSynchronisedScene(I)
                NetworkStartSynchronisedScene(J)
                Citizen.CreateThread(
                    function()
                        Wait(20000)
                        TriggerServerEvent("FR:jewelryCollectDevice")
                        FreezeEntityPosition(tFR.getPlayerPed(), false)
                        ClearPedTasks(tFR.getPlayerPed())
                        tFR.teleport(w.coords.x, w.coords.y, w.coords.z)
                        d = false
                        RemoveAnimDict(x)
                    end
                )
            end
        end
        tFR.createArea(
            "jewelry_collect_device",
            w.coords,
            1.25,
            10,
            enter_collectDevice,
            exit_collectDevice,
            ontick_collectDevice,
            {}
        )
        SetTimeout(
            600000,
            function()
                tFR.removeArea("jewelry_collect_device")
                tFR.removeBlip(e)
            end
        )
    end
)
RegisterNetEvent(
    "FR:jewelryRemoveDeviceArea",
    function()
        tFR.removeArea("jewelry_collect_device")
        tFR.removeMarker(f)
        tFR.removeBlip(e)
    end
)
RegisterCommand(
    "doorhack",
    function()
        if tFR.getUserId() == -1 then
            TriggerEvent("FR:jewelryStartDoorHackSf")
        end
    end
)
RegisterCommand(
    "computerhack",
    function()
        if tFR.getUserId() == -1 then
            TriggerEvent("FR:jewelryStartComputerHackSf")
        end
    end
)
RegisterNetEvent(
    "FR:jewelryStartDoorHackSf",
    function()
        Citizen.CreateThread(
            function()
                Wait(2500)
                m = true
                p()
            end
        )
        TriggerEvent(
            "utk_fingerprint:Start",
            4,
            1,
            2,
            function(K, L)
                if K then
                    tFR.notify("~g~Succesfully hacked!")
                    TriggerServerEvent("FR:jewelryDoorHackSuccess")
                else
                    tFR.notify("~r~Failed. Reason: " .. L)
                end
                m = false
            end
        )
    end
)
RegisterNetEvent(
    "FR:jewelryStartComputerHackSf",
    function()
        Citizen.CreateThread(
            function()
                Wait(2500)
                m = true
                p()
            end
        )
        startDataCrack(
            5,
            function(K)
                if K then
                    TriggerServerEvent("FR:jewelryComputerHackSuccess")
                else
                    TriggerServerEvent("FR:jewelryComputerHackFailed")
                end
                m = false
            end
        )
    end
)
RegisterNetEvent(
    "FR:jewelrySyncDoor",
    function(M)
        while g == 0 do
            Citizen.Wait(0)
        end
        FreezeEntityPosition(g, M)
    end
)
RegisterNetEvent(
    "FR:jewelrySoundAlarm",
    function(N)
        if N then
            PrepareAlarm("JEWEL_STORE_HEIST_ALARMS")
            Citizen.Wait(1000)
            StartAlarm("JEWEL_STORE_HEIST_ALARMS", false)
        else
            StopAlarm("JEWEL_STORE_HEIST_ALARMS", true)
        end
    end
)
RegisterNetEvent(
    "FR:jewelryCreateTimer",
    function()
        local O = true
        local P = 0
        local Q = 0
        SetTimeout(
            600000,
            function()
                O = false
            end
        )
        Citizen.CreateThread(
            function()
                for R = 9, 0, -1 do
                    P = R
                    for S = 59, 0, -1 do
                        Q = S
                        Wait(1000)
                    end
                    Wait(1000)
                end
            end
        )
        while O do
            if Q / 10 < 1 then
                DrawGTATimerBar("TIME TO LOOT:", P .. ":" .. "0" .. Q, 3)
            else
                DrawGTATimerBar("TIME TO LOOT:", P .. ":" .. Q, 3)
            end
            Citizen.Wait(0)
        end
    end
)
RegisterNetEvent(
    "FR:jewelryHeistReady",
    function(T)
        if T then
            h =
                tFR.addMarker(
                a.hackDoorCoords.x,
                a.hackDoorCoords.y,
                a.hackDoorCoords.z,
                0.4,
                0.4,
                0.5,
                200,
                0,
                0,
                255,
                30,
                27,
                false,
                false,
                false
            )
            enter_hackJewelryDoor = function()
                if not globalOnPoliceDuty then
                    drawNativeNotification("Press ~INPUT_CONTEXT~ to hack the keypad")
                end
            end
            exit_hackJewelryDoor = function()
            end
            ontick_hackJewelryDoor = function()
                if not globalOnPoliceDuty then
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("FR:jewelryHackDoor")
                    end
                end
            end
            tFR.createArea(
                "jewelry_hack_door",
                a.hackDoorCoords,
                1.25,
                10,
                enter_hackJewelryDoor,
                exit_hackJewelryDoor,
                ontick_hackJewelryDoor,
                {}
            )
        else
            tFR.removeArea("jewelry_hack_door")
            tFR.removeMarker(h)
        end
    end
)
RegisterNetEvent(
    "FR:jewelryComputerHackArea",
    function(U)
        if U then
            i =
                tFR.addMarker(
                a.hackComputerCoords.x,
                a.hackComputerCoords.y,
                a.hackComputerCoords.z,
                0.4,
                0.4,
                0.5,
                200,
                0,
                0,
                255,
                30,
                27,
                false,
                false,
                false
            )
            enter_hackJewelryComputer = function()
                if not globalOnPoliceDuty then
                    drawNativeNotification("Press ~INPUT_CONTEXT~ to hack the computer")
                end
            end
            exit_hackJewelryComputer = function()
            end
            ontick_hackJewelryComputer = function()
                if not globalOnPoliceDuty then
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("FR:jewelryHackComputer")
                    end
                end
            end
            tFR.createArea(
                "jewelry_hack_computer",
                a.hackComputerCoords,
                1.25,
                10,
                enter_hackJewelryComputer,
                exit_hackJewelryComputer,
                ontick_hackJewelryComputer,
                {}
            )
        else
            tFR.removeArea("jewelry_hack_computer")
            tFR.removeMarker(i)
        end
    end
)
RegisterNetEvent(
    "FR:jewelrySyncLootAreas",
    function(V, U)
        if U then
            createJewelryArea(V)
        else
            tFR.removeArea("break_glass_" .. V)
            tFR.removeMarker(j[V])
        end
    end
)
RegisterNetEvent(
    "FR:jewelrySyncModelSwaps",
    function(V)
        if #(GetEntityCoords(tFR.getPlayerPed()) - a.jewelryCases[V].coords) <= 350 then
            local W =
                GetClosestObjectOfType(
                a.jewelryCases[V].coords.x,
                a.jewelryCases[V].coords.y,
                a.jewelryCases[V].coords.z,
                0.5,
                a.jewelryCases[V].modelHash,
                false,
                true,
                true
            )
            if W ~= nil then
                local newModel
                if a.jewelryCases[V].modelHash == GetHashKey("des_jewel_cab_start") then
                    newModel = GetHashKey("des_jewel_cab_end")
                    RequestModel(newModel)
                    while not HasModelLoaded(newModel) do
                        Citizen.Wait(0)
                    end
                elseif a.jewelryCases[V].modelHash == GetHashKey("des_jewel_cab2_start") then
                    newModel = GetHashKey("des_jewel_cab2_end")
                    RequestModel(newModel)
                    while not HasModelLoaded(newModel) do
                        Citizen.Wait(0)
                    end
                elseif a.jewelryCases[V].modelHash == GetHashKey("des_jewel_cab3_start") then
                    newModel = GetHashKey("des_jewel_cab3_end")
                    RequestModel(newModel)
                    while not HasModelLoaded(newModel) do
                        Citizen.Wait(0)
                    end
                elseif a.jewelryCases[V].modelHash == GetHashKey("des_jewel_cab4_start") then
                    newModel = GetHashKey("des_jewel_cab4_end")
                    RequestModel(newModel)
                    while not HasModelLoaded(newModel) do
                        Citizen.Wait(0)
                    end
                end
                CreateModelSwap(
                    a.jewelryCases[V].coords.x,
                    a.jewelryCases[V].coords.y,
                    a.jewelryCases[V].coords.z,
                    1.25,
                    a.jewelryCases[V].modelHash,
                    newModel,
                    true
                )
                SetModelAsNoLongerNeeded(newModel)
            end
        end
    end
)
function createJewelryArea(V)
    if not j[V] then
        enter_breakJewelryCase = function()
            drawNativeNotification("Press ~INPUT_CONTEXT~ to break the glass")
        end
        exit_breakJewelryCase = function()
        end
        ontick_breakJewelryCase = function(X)
            if IsControlJustPressed(0, 38) and not l and GetEntityHealth(PlayerPedId()) > 102 then
                if not globalOnPoliceDuty then
                    if GetSelectedPedWeapon(tFR.getPlayerPed()) ~= GetHashKey("WEAPON_UNARMED") then
                        RequestScriptAudioBank("DLC_FRHEIST\\GLASS_BREAK", false)
                        local Y = math.random(1, 3)
                        l = true
                        local Z = tFR.getPlayerCoords()
                        local W = GetClosestObjectOfType(Z.x, Z.y, Z.z, 0.5, X.modelHash, false, true, true)
                        FreezeEntityPosition(tFR.getPlayerPed(), true)
                        if W ~= 0 then
                            local _ = GetEntityCoords(W)
                            RequestAnimDict("missheist_jewel")
                            while not HasAnimDictLoaded("missheist_jewel") do
                                Citizen.Wait(0)
                            end
                            if X.modelHash == GetHashKey("des_jewel_cab_start") then
                                newModel = GetHashKey("des_jewel_cab_end")
                                RequestModel(newModel)
                                while not HasModelLoaded(newModel) do
                                    Citizen.Wait(0)
                                end
                            elseif X.modelHash == GetHashKey("des_jewel_cab2_start") then
                                newModel = GetHashKey("des_jewel_cab2_end")
                                RequestModel(newModel)
                                while not HasModelLoaded(newModel) do
                                    Citizen.Wait(0)
                                end
                            elseif X.modelHash == GetHashKey("des_jewel_cab3_start") then
                                newModel = GetHashKey("des_jewel_cab3_end")
                                RequestModel(newModel)
                                while not HasModelLoaded(newModel) do
                                    Citizen.Wait(0)
                                end
                            elseif X.modelHash == GetHashKey("des_jewel_cab4_start") then
                                newModel = GetHashKey("des_jewel_cab4_end")
                                RequestModel(newModel)
                                while not HasModelLoaded(newModel) do
                                    Citizen.Wait(0)
                                end
                            end
                            RequestNamedPtfxAsset("scr_jewelheist")
                            while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                Citizen.Wait(0)
                            end
                            UseParticleFxAsset("scr_jewelheist")
                            StartParticleFxNonLoopedOnEntity(
                                "scr_jewel_cab_smash",
                                GetCurrentPedWeaponEntityIndex(tFR.getPlayerPed()),
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                1065353216,
                                0,
                                0,
                                0
                            )
                            CreateModelSwap(_.x, _.y, _.z, 1.25, X.modelHash, newModel, true)
                            SetEntityHeading(tFR.getPlayerPed(), a.jewelryCases[V].heading)
                            SetModelAsNoLongerNeeded(newModel)
                            RemoveNamedPtfxAsset("scr_jewelheist")
                        end
                        local a0
                        local a1 = math.random(1, 2)
                        if a1 == 1 then
                            a0 = coolCameraThingOne
                        elseif a1 == 2 then
                            a0 = coolCameraThingTwo
                        end
                        local a2 = tFR.getPlayerCoords()
                        PlaySoundFromCoord(
                            -1,
                            "glass_break_" .. Y,
                            a2.x,
                            a2.y,
                            a2.z,
                            "dlc_frheist_soundset",
                            false,
                            20.0,
                            false
                        )
                        if X.modelHash == GetHashKey("des_jewel_cab4_start") then
                            TaskPlayAnim(
                                tFR.getPlayerPed(),
                                "missheist_jewel",
                                "smash_case_necklace_skull",
                                1000.0,
                                -4.0,
                                -1,
                                1,
                                1148846080,
                                0,
                                false,
                                false
                            )
                            a0(tFR.getPlayerPed(), tFR.getPlayerCoords(), true)
                        else
                            TaskPlayAnim(
                                tFR.getPlayerPed(),
                                "missheist_jewel",
                                "smash_case",
                                1000.0,
                                -4.0,
                                -1,
                                1,
                                1148846080,
                                0,
                                false,
                                false
                            )
                            a0(tFR.getPlayerPed(), tFR.getPlayerCoords(), false)
                        end
                        FreezeEntityPosition(tFR.getPlayerPed(), false)
                        TriggerServerEvent("FR:jewelryGrabLoot", X.caseId)
                        Citizen.Wait(1000)
                        SetModelAsNoLongerNeeded("prop_jewel_04a")
                        RemoveAnimDict("missheist_jewel")
                        l = false
                    else
                        tFR.notify("~r~You must be holding a weapon to smash the glass!")
                    end
                else
                    TriggerServerEvent("FR:jewelryPoliceSeizeLoot", X.caseId)
                    tFR.removeArea("break_glass_" .. X.caseId)
                end
            end
        end
        j[V] =
            tFR.addMarker(
            a.jewelryCases[V].coords.x,
            a.jewelryCases[V].coords.y,
            a.jewelryCases[V].coords.z - 0.35,
            0.2,
            0.2,
            0.2,
            255,
            255,
            0,
            200,
            30,
            0,
            false,
            true,
            false
        )
        tFR.createArea(
            "break_glass_" .. V,
            a.jewelryCases[V].coords,
            1.25,
            10,
            enter_breakJewelryCase,
            exit_breakJewelryCase,
            ontick_breakJewelryCase,
            {
                caseId = V,
                modelHash = a.jewelryCases[V].modelHash,
                heading = a.jewelryCases[V].heading,
                caseCoords = a.jewelryCases[V].coords
            }
        )
    end
end
AddEventHandler(
    "FR:onClientSpawn",
    function(a3, a4)
        if a4 then
            enter_jewelryTeleporterEnter = function()
                drawNativeNotification("Press ~INPUT_CONTEXT~ to exit via the roof")
            end
            exit_jewelryTeleporterEnter = function()
            end
            ontick_jewelryTeleporterEnter = function()
                if IsControlJustPressed(0, 38) then
                    SetEntityHeading(tFR.getPlayerPed(), 217.38)
                    tFR.teleport(a.exitTeleporterCoords.x, a.exitTeleporterCoords.y, a.exitTeleporterCoords.z)
                end
            end
            tFR.addBlip(
                a.enterTeleporterCoords.x,
                a.enterTeleporterCoords.y,
                a.enterTeleporterCoords.z,
                617,
                0,
                "Jewelry Store",
                0.7
            )
            tFR.addMarker(
                a.enterTeleporterCoords.x,
                a.enterTeleporterCoords.y,
                a.enterTeleporterCoords.z - 1,
                0.4,
                0.4,
                0.5,
                255,
                255,
                255,
                255,
                30,
                27,
                false,
                false,
                false
            )
            tFR.createArea(
                "jewelry_teleport",
                a.enterTeleporterCoords,
                1.25,
                10,
                enter_jewelryTeleporterEnter,
                exit_jewelryTeleporterEnter,
                ontick_jewelryTeleporterEnter
            )
            enter_jewelryTeleporterExit = function()
                drawNativeNotification("Press ~INPUT_CONTEXT~ to enter the jewelry store")
            end
            exit_jewelryTeleporterExit = function()
            end
            ontick_jewelryTeleporterExit = function()
                if IsControlJustPressed(0, 38) then
                    SetEntityHeading(tFR.getPlayerPed(), 217.38)
                    tFR.teleport(a.enterTeleporterCoords.x, a.enterTeleporterCoords.y, a.enterTeleporterCoords.z)
                end
            end
            tFR.addMarker(
                a.exitTeleporterCoords.x,
                a.exitTeleporterCoords.y,
                a.exitTeleporterCoords.z - 1,
                0.4,
                0.4,
                0.5,
                255,
                255,
                255,
                255,
                30,
                27,
                false,
                false,
                false
            )
            tFR.createArea(
                "jewelry_teleport2",
                a.exitTeleporterCoords,
                1.25,
                10,
                enter_jewelryTeleporterExit,
                exit_jewelryTeleporterExit,
                ontick_jewelryTeleporterExit
            )
        end
    end
)
AddEventHandler(
    "FR:onClientSpawn",
    function(a3, a4)
        if a4 then
            enter_aiMissionTeleporterEnter = function()
                drawNativeNotification("Press ~INPUT_CONTEXT~ to enter the facility")
            end
            exit_aiMissionTeleporterEnter = function()
            end
            ontick_aiMissionTeleporterEnter = function()
                if IsControlJustPressed(0, 38) then
                    if c then
                        tFR.teleport(
                            a.aiMissionTeleporterExit.x,
                            a.aiMissionTeleporterExit.y,
                            a.aiMissionTeleporterExit.z
                        )
                        b = true
                        Citizen.Wait(1000)
                        TriggerServerEvent("FR:jewelrySetupHeistStart")
                    else
                        tFR.notify("~r~You cannot enter right now.")
                    end
                end
            end
            tFR.addBlip(
                a.aiMissionTeleporterEnter.x,
                a.aiMissionTeleporterEnter.y,
                a.aiMissionTeleporterEnter.z,
                619,
                3,
                "Jewelry Store Setup",
                0.7
            )
            tFR.addMarker(
                a.aiMissionTeleporterEnter.x,
                a.aiMissionTeleporterEnter.y,
                a.aiMissionTeleporterEnter.z - 0.35,
                0.3,
                0.3,
                0.3,
                255,
                255,
                255,
                200,
                30,
                0,
                false,
                true,
                false
            )
            tFR.createArea(
                "ai_mission_teleport",
                a.aiMissionTeleporterEnter,
                3.0,
                10,
                enter_aiMissionTeleporterEnter,
                exit_aiMissionTeleporterEnter,
                ontick_aiMissionTeleporterEnter
            )
            enter_aiMissionTeleporterExit = function()
                drawNativeNotification("Press ~INPUT_CONTEXT~ to exit the facility")
            end
            exit_aiMissionTeleporterExit = function()
            end
            ontick_aiMissionTeleporterExit = function()
                if IsControlJustPressed(0, 38) then
                    tFR.teleport(
                        a.aiMissionTeleporterEnter.x,
                        a.aiMissionTeleporterEnter.y,
                        a.aiMissionTeleporterEnter.z
                    )
                    b = false
                    TriggerServerEvent("FR:jewelrySetupHeistLeave")
                end
            end
            tFR.addMarker(
                a.aiMissionTeleporterExit.x,
                a.aiMissionTeleporterExit.y,
                a.aiMissionTeleporterExit.z - 0.35,
                0.3,
                0.3,
                0.3,
                255,
                255,
                255,
                200,
                30,
                0,
                false,
                true,
                false
            )
            tFR.createArea(
                "ai_mission_teleport2",
                a.aiMissionTeleporterExit,
                3.0,
                10,
                enter_aiMissionTeleporterExit,
                exit_aiMissionTeleporterExit,
                ontick_aiMissionTeleporterExit
            )
        end
    end
)
AddEventHandler(
    "FR:onClientSpawn",
    function(a3, a4)
        if a4 then
            AddRelationshipGroup("aiHeist")
            Citizen.Wait(10000)
            g =
                GetClosestObjectOfType(
                a.hackDoorCoords.x,
                a.hackDoorCoords.y,
                a.hackDoorCoords.z,
                2.0,
                "v_ilev_j2_door",
                false,
                false,
                false
            )
        end
    end
)
AddEventHandler(
    "FR:onPlayerKilled",
    function(q)
        if q == "killed" then
            if b then
                TriggerServerEvent("FR:jewelrySetupHeistLeave")
                TriggerEvent("FR:jewelryRemoveDeviceArea")
                b = false
            end
        end
    end
)
RegisterNetEvent(
    "FR:jewelryMakePedsAttack",
    function(a5)
        while not NetworkDoesEntityExistWithNetworkId(a5) do
            Citizen.Wait(0)
        end
        local y = tFR.getObjectId(a5)
        SetPedRelationshipGroupHash(y, "aiHeist")
        SetRelationshipBetweenGroups(5, "aiHeist", GetPedRelationshipGroupHash(GetPlayerPed(-1)))
        SetPedDropsWeaponsWhenDead(y, false)
        TaskCombatPed(y, tFR.getPlayerPed(), 0, 0)
        SetPedAccuracy(y, 30)
    end
)
function coolCameraThingOne(W, _, a6)
    local a7 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    local a8 = GetOffsetFromEntityInWorldCoords(W, 1.5, 0.0, 1.0)
    local a9 = GetOffsetFromEntityInWorldCoords(W, 0.0, 1.0, 1.5)
    SetCamCoord(a7, a8.x, a8.y, a8.z)
    PointCamAtCoord(a7, tFR.getPlayerCoords().x, tFR.getPlayerCoords().y, tFR.getPlayerCoords().z)
    SetCamActive(a7, true)
    RenderScriptCams(true, true, 0, 1, 0)
    RequestModel("prop_jewel_04a")
    while not HasModelLoaded("prop_jewel_04a") do
        Citizen.Wait(0)
    end
    Citizen.Wait(1500)
    SetCamCoord(a7, a9.x, a9.y, a9.z)
    PointCamAtCoord(a7, tFR.getPlayerCoords().x, tFR.getPlayerCoords().y, tFR.getPlayerCoords().z)
    if a6 then
        Citizen.Wait(1250)
    else
        Citizen.Wait(2700)
    end
    RenderScriptCams(false, true, 400, 1, 0)
    DestroyCam(a7, false)
    ClearPedTasks(tFR.getPlayerPed())
end
function coolCameraThingTwo(W, _, a6)
    local a7 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    local aa = GetOffsetFromEntityInWorldCoords(W, 2.5, 1.0, 1.5)
    SetCamCoord(a7, aa.x, aa.y, aa.z)
    SetCamFov(a7, 35.2071)
    local ab = tFR.getPlayerCoords()
    PointCamAtCoord(a7, ab.x, ab.y, ab.z)
    SetCamActive(a7, true)
    RenderScriptCams(true, true, 3000, 1, 0)
    RequestModel("prop_jewel_04a")
    while not HasModelLoaded("prop_jewel_04a") do
        Citizen.Wait(0)
    end
    if a6 then
        Citizen.Wait(2900)
    else
        Citizen.Wait(3700)
    end
    RenderScriptCams(false, true, 400, 1, 0)
    DestroyCam(a7, false)
    ClearPedTasks(tFR.getPlayerPed())
end
RegisterNetEvent(
    "FR:jewelryAlarmTriggered",
    function()
        tFR.announceMpSmallMsg("ALERT", "An alarm has been triggered at the jewelry store", 9, 10000)
    end
)
RegisterCommand(
    "startjews",
    function()
        print("Starting Jewelry Heist")
        TriggerServerEvent("FR:jewelryComputerHackSuccess")
    end
)
