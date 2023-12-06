licensecentre = module("cfg/cfg_licensecentre")
local a = {}
RMenu.Add(
    "frlicenses",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~" .. "Job Centre",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight(),
        "fr_licenseui",
        "fr_licenseui"
    )
)
RMenu.Add(
    "frlicenses",
    "ownedlicenses",
    RageUI.CreateSubMenu(RMenu:Get("frlicenses", "main", tFR.getRageUIMenuWidth(), tFR.getRageUIMenuHeight()))
)
RMenu.Add(
    "frlicenses",
    "buyconfirm",
    RageUI.CreateSubMenu(
        RMenu:Get("frlicenses", "main"),
        "",
        "Are you sure?",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "frlicenses",
    "refundconfirm",
    RageUI.CreateSubMenu(
        RMenu:Get("frlicenses", "ownedlicenses"),
        "",
        "Are you sure?",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("frlicenses", "main"),
            true,
            false,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Refund Licenses",
                    "Obtain 25% of the license value back.",
                    {RightLabel = "→→→"},
                    true,
                    function(b, c, d)
                    end,
                    RMenu:Get("frlicenses", "ownedlicenses")
                )
                for e, f in pairs(licensecentre.licenses) do
                    local g = not a[f.name]
                    RageUI.Button(
                        f.name .. " (£" .. getMoneyStringFormatted(tostring(f.price)) .. ")",
                        f.notOwned and "" or "You already own this license.",
                        f.notOwned and {RightLabel = "→→→"} or {RightLabel = ""},
                        f.notOwned,
                        function(b, c, d)
                            if d then
                                cGroup = f.group
                                cName = f.name
                            end
                        end,
                        RMenu:Get("frlicenses", "buyconfirm")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frlicenses", "buyconfirm"),
            true,
            true,
            true,
            function()
                for h, i in pairs(licensecentre.licenses) do
                    if i.group == cGroup then
                        RageUI.Separator(i.name .. " Price: £" .. getMoneyStringFormatted(i.price))
                        if i.info ~= nil then
                            for j, k in pairs(i.info) do
                                RageUI.Separator(k)
                            end
                        end
                        RageUI.ButtonWithStyle(
                            "Confirm",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                                if d then
                                    TriggerServerEvent("FR:buyLicense", cGroup, cName)
                                end
                            end,
                            RMenu:Get("frlicenses", "main")
                        )
                        RageUI.ButtonWithStyle(
                            "Decline",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                            end,
                            RMenu:Get("frlicenses", "main")
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frlicenses", "ownedlicenses"),
            true,
            true,
            true,
            function()
                for e, f in pairs(licensecentre.licenses) do
                    local g = a[f.name]
                    if not f.notOwned then
                        RageUI.ButtonWithStyle(
                            "Refund " .. f.name .. " for (£" .. getMoneyStringFormatted(tostring(f.price * 0.25)) .. ")",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(b, c, d)
                                if d then
                                    cGroup = f.group
                                    cName = f.name
                                end
                            end,
                            RMenu:Get("frlicenses", "refundconfirm")
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frlicenses", "refundconfirm"),
            true,
            true,
            true,
            function()
                for h, i in pairs(licensecentre.licenses) do
                    if i.group == cGroup then
                        RageUI.Separator("Refund Amount: £" .. getMoneyStringFormatted(i.price * 0.25))
                        RageUI.ButtonWithStyle(
                            "Confirm",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                                if d then
                                    TriggerServerEvent("FR:refundLicense", cGroup, cName)
                                end
                            end,
                            RMenu:Get("frlicenses", "ownedlicenses")
                        )
                        RageUI.ButtonWithStyle(
                            "Decline",
                            nil,
                            {RightLabel = ""},
                            true,
                            function(b, c, d)
                            end,
                            RMenu:Get("frlicenses", "ownedlicenses")
                        )
                    end
                end
            end,
            function()
            end
        )
    end
)
AddEventHandler(
    "FR:onClientSpawn",
    function(f, l)
        if l then
            local m = function(n)
            end
            local o = function(n)
                RageUI.Visible(RMenu:Get("frlicenses", "main"), false)
                RageUI.Visible(RMenu:Get("frlicenses", "ownedlicenses"), false)
                RageUI.Visible(RMenu:Get("frlicenses", "buyconfirm"), false)
                RageUI.Visible(RMenu:Get("frlicenses", "refundconfirm"), false)
                RageUI.CloseAll()
            end
            local p = function(n)
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("FR:getOwnedLicenses")
                    Wait(500)
                    RageUI.Visible(RMenu:Get("frlicenses", "main"), not RageUI.Visible(RMenu:Get("frlicenses", "main")))
                end
                local i, q, r = table.unpack(GetFinalRenderedCamCoord())
                DrawText3D(
                    licensecentre.location.x,
                    licensecentre.location.y,
                    licensecentre.location.z,
                    "Press [E] to open License Centre",
                    i,
                    q,
                    r
                )
                tFR.addMarker(
                    licensecentre.location.x,
                    licensecentre.location.y,
                    licensecentre.location.z - 0.98,
                    0.7,
                    0.7,
                    0.5,
                    255,
                    255,
                    255,
                    250,
                    50,
                    27,
                    false,
                    false
                )
            end
            tFR.createArea("licensecentre", licensecentre.location, 1.5, 6, m, o, p, {})
            tFR.addBlip(
                licensecentre.location.x,
                licensecentre.location.y,
                licensecentre.location.z,
                525,
                2,
                "License Shop"
            )
        end
    end
)
local j = false
local k = {}
local s = 0.033
local t = 0.033
local u = 0
local v = 0.306
function func_licenseMenuControl()
    if IsControlJustPressed(0, 167) then
        if j then
            j = false
        else
            TriggerServerEvent("FR:GetLicenses")
        end
    end
    if j then
        if tFR.isNewPlayer() then
            drawNativeNotification("Press ~INPUT_SELECT_CHARACTER_FRANKLIN~ to toggle the License Menu.")
        end
        DrawRect(0.50, 0.222, 0.223, 0.075, 16, 86, 229, 255)
        DrawAdvancedText(0.595, 0.213, 0.005, 0.0028, 1.0, "FR Licenses", 255, 255, 255, 255, 1, 0)
        DrawAdvancedText(0.595, 0.275, 0.005, 0.0028, 0.4, "Licenses Owned", 0, 255, 50, 255, 6, 0)
        DrawRect(0.50, 0.272, 0.223, 0.026, 0, 0, 0, 222)
        for w, x in pairs(k) do
            DrawAdvancedText(0.595, v + u * s, 0.005, 0.0028, 0.4, tostring(x), 255, 255, 255, 255, 6, 0)
            DrawRect(0.50, 0.301 + s * u, 0.223, 0.033, 0, 0, 0, 120)
            u = u + 1
        end
        u = 0
    end
end
if not tFR.isPurge() then
    tFR.createThreadOnTick(func_licenseMenuControl)
end
RegisterNetEvent(
    "FR:ReceivedLicenses",
    function(e)
        k = e
        j = true
    end
)
RegisterNetEvent(
    "FR:gotOwnedLicenses",
    function(e)
        for f, g in pairs(licensecentre.licenses) do
            g.notOwned = true
            for h, i in pairs(e) do
                if g.name == i then
                    g.notOwned = false
                end
            end
        end
    end
)
