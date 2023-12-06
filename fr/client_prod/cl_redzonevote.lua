local a = ""
local b = {h = 12, m = 0, s = 0}
local c = false
local function d(e)
    a = e
    ClearOverrideRedzone()
    ClearRedzoneTypePersist()
    SetRedzoneTypePersist(a)
    SetRedzoneTypeNow(a)
    SetRedzoneTypeNowPersist(a)
    if a == "" then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end
function tFR.setTime(f, g, h)
    b = {h = f, m = g, s = h}
end
function tFR.overrideTime(f, g, h)
    b.h = f
    b.m = g
    b.s = h
    c = true
end
function tFR.cancelOverrideTimeRedzone()
    c = false
end
function tFR.setRedzone(i)
    a = i
end
function func_manageTimeAndRedzone()
    NetworkOverrideClockTime(b.h, b.m, b.s)
    d(a)
end
tFR.createThreadOnTick(func_manageTimeAndRedzone)
RegisterNetEvent(
    "FR:setTime",
    function(f, g, h)
        tFR.setTime(f, g, h)
    end
)
RegisterNetEvent(
    "FR:setRedzone",
    function(i)
        tFR.setRedzone(i)
    end
)
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            b.s = b.s + 10
            if b.s == 60 then
                b.s = 0
                b.m = b.m + 1
            end
            if b.m == 60 then
                b.m = 0
                b.h = b.h + 1
            end
            if b.h == 24 then
                b.h = 0
            end
            if not c then
                tFR.setTime(b.h, b.m, b.s)
            end
        end
    end
)
local j = false
local k = false
local l = 60
local m = {
    ["CLEAR"] = 0,
    ["EXTRASUNNY"] = 0,
    ["CLOUDS"] = 0,
    ["OVERCAST"] = 0,
    ["RAIN"] = 0,
    ["THUNDER"] = 0,
    ["HALLOWEEN"] = 0,
    ["SMOG"] = 0,
    ["FOGGY"] = 0,
    ["XMAS"] = 0,
    ["SNOWLIGHT"] = 0,
    ["BLIZZARD"] = 0
}
local function n(o, p, q, f, r, s, t, u, v, w, x, y)
    SetTextFont(x)
    SetTextScale(r, r)
    SetTextJustification(y)
    SetTextColour(t, u, v, w)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(s)
    EndTextCommandDisplayText(o - 0.1 + q, p - 0.02 + f)
end
local z = 0.1
local A = 0.005
local B = 0.02
Citizen.CreateThread(
    function()
        while true do
            if j then
                n(z + 0.265, 0.96, 0.005, 0.0028, 0.30, "Time Left:", 0, 208, 104, 255, 4, 1)
                n(z + 0.295, 0.96, 0.005, 0.0028, 0.275, tostring(l), 255, 74, 53, 255, 0, 1)
                n(z + 0.29, 0.827, 0.005, 0.0028, 0.38, "Redzone Voter", 0, 208, 104, 255, 4, 1)
                n(z + 0.2645, 0.848, 0.005, 0.0028, 0.30, "Clear", 255, 255, 255, 255, 4, 1)
                n(z + 0.2645, 0.866, 0.005, 0.0028, 0.30, "ExtraSunny", 255, 255, 255, 255, 4, 1)
                n(z + 0.2645, 0.884, 0.005, 0.0028, 0.30, "Cloudy", 255, 255, 255, 255, 4, 1)
                n(z + 0.2645, 0.902, 0.005, 0.0028, 0.30, "Overcast", 255, 255, 255, 255, 4, 1)
                n(z + 0.2645, 0.920, 0.005, 0.0028, 0.30, "Rain", 255, 255, 255, 255, 4, 1)
                n(z + 0.2645, 0.938, 0.005, 0.0028, 0.30, "Thunder", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.293, 0.848, 0.005, 0.0028, 0.25, tostring(m["CLEAR"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.293, 0.866, 0.005, 0.0028, 0.25, tostring(m["EXTRASUNNY"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.293, 0.884, 0.005, 0.0028, 0.25, tostring(m["CLOUDS"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.293, 0.902, 0.005, 0.0028, 0.25, tostring(m["OVERCAST"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.293, 0.920, 0.005, 0.0028, 0.25, tostring(m["RAIN"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.293, 0.938, 0.005, 0.0028, 0.25, tostring(m["THUNDER"]), 255, 74, 53, 255, 0, 1)
                n(z + A + 0.315, 0.848, 0.005, 0.0028, 0.30, "Halloween", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.315, 0.866, 0.005, 0.0028, 0.30, "Smog", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.315, 0.884, 0.005, 0.0028, 0.30, "Snow", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.315, 0.902, 0.005, 0.0028, 0.30, "Blizzard", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.315, 0.920, 0.005, 0.0028, 0.30, "Snowlight", 255, 255, 255, 255, 4, 1)
                n(z + A + 0.315, 0.938, 0.005, 0.0028, 0.30, "Foggy", 255, 255, 255, 255, 4, 1)
                n(z + B + 0.333, 0.848, 0.005, 0.0028, 0.25, tostring(m["HALLOWEEN"]), 255, 74, 53, 255, 0, 1)
                n(z + B + 0.333, 0.866, 0.005, 0.0028, 0.25, tostring(m["SMOG"]), 255, 74, 53, 255, 0, 1)
                n(z + B + 0.333, 0.884, 0.005, 0.0028, 0.25, tostring(m["XMAS"]), 255, 74, 53, 255, 0, 1)
                n(z + B + 0.333, 0.902, 0.005, 0.0028, 0.25, tostring(m["BLIZZARD"]), 255, 74, 53, 255, 0, 1)
                n(z + B + 0.333, 0.920, 0.005, 0.0028, 0.25, tostring(m["SNOWLIGHT"]), 255, 74, 53, 255, 0, 1)
                n(z + B + 0.333, 0.938, 0.005, 0.0028, 0.25, tostring(m["FOGGY"]), 255, 74, 53, 255, 0, 1)
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if j then
                l = l - 1
                if l == 0 then
                    j = false
                    l = 60
                    k = false
                    resetVotes()
                end
            end
            Wait(1000)
        end
    end
)
function voteRedzone(C)
    if j then
        if not k then
            TriggerServerEvent("FR:vote", C)
            k = true
            tFR.notify("~g~Vote sent!")
        else
            tFR.notify("You have already voted!")
        end
    else
        tFR.notify("Vote not in progress, start a vote with /voteredzone!")
    end
end
function resetVotes()
    m = {
        ["Heroin"] = 0,
        ["Rebel"] = 0,
        ["LSD"] = 0,
        ["LargeArms"] = 0,
        ["Coke"] = 0,
        ["ChickenFactory"] = 0,
        ["OLDLSD"] = 0,
        ["NewRebel"] = 0,
        ["PIER"] = 0,
        ["MiliBase"] = 0,
        ["BackGarage"] = 0,
        ["Humane"] = 0
    }
end
RegisterNetEvent(
    "FR:startRedzoneVote",
    function()
        j = true
        TriggerEvent(
            "chatMessage",
            "Redzone vote has started! Type /[redzone] e.g /rebel or /rebel to vote.",
            {0, 250, 50}
        )
        TriggerEvent("chatMessage", "Redzone types are in bottom left & /voteredzone to start a vote", {0, 250, 50})
    end
)
RegisterNetEvent(
    "FR:voteStateChange",
    function(D)
        m[D] = m[D] + 1
    end
)
RegisterCommand(
    "voteredzone",
    function()
        TriggerServerEvent("FR:tryStartRedzoneVote")
    end,
    false
)
RegisterCommand(
    "humane",
    function()
        voteRedzone("Humane")
    end,
    false
)
RegisterCommand(
    "garage",
    function()
        voteRedzone("BackGarage")
    end,
    false
)
RegisterCommand(
    "mili",
    function()
        voteRedzone("MiliBase")
    end,
    false
)
RegisterCommand(
    "pier",
    function()
        voteRedzone("PIER")
    end,
    false
)
RegisterCommand(
    "chicken",
    function()
        voteRedzone("ChickenFactory")
    end,
    false
)
RegisterCommand(
    "coke",
    function()
        voteRedzone("Coke")
    end,
    false
)
RegisterCommand(
    "oldlsd",
    function()
        voteRedzone("OldLSD")
    end,
    false
)
RegisterCommand(
    "lsd",
    function()
        voteRedzone("LSD")
    end,
    false
)
RegisterCommand(
    "oldrebel",
    function()
        voteRedzone("Rebel")
    end,
    false
)
RegisterCommand(
    "rebel",
    function()
        voteRedzone("NewRebel")
    end,
    false
)
RegisterCommand(
    "heroin",
    function()
        voteRedzone("Heroin")
    end,
    false
) --- not finished, working from /voteweather due to it being very similar
