local a = {}
local b = {}
RMenu.Add(
    "FR",
    "admindailyboot",
    RageUI.CreateMenu("", "Daily Boot", tFR.getRageUIMenuWidth(), tFR.getRageUIMenuHeight(), "fr_adminui", "fr_adminui")
)
RMenu.Add("FR", "subadmindailyboot", RageUI.CreateSubMenu(RMenu:Get("FR", "admindailyboot"), "", "Daily Boot"))
RMenu.Add("FR", "weaponadmindailyboot", RageUI.CreateSubMenu(RMenu:Get("FR", "subadmindailyboot"), "", "Daily Boot"))
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("FR", "admindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    if next(a) ~= nil then
                        RageUI.Separator("Claimed: " .. tostring("~g~" .. a.claimed))
                        RageUI.Separator(
                            "Redeem Time: " ..
                                string.format("%02d:%02d", tonumber(a.time.hour), tonumber(a.time.minute))
                        )
                        RageUI.Separator("Reward: £" .. getMoneyStringFormatted("~g~" .. a.money))
                        RageUI.Separator("Reward Items: ")
                        for c, d in pairs(a.items) do
                            RageUI.Separator(c .. " x" .. d)
                        end
                        RageUI.Button(
                            "Change Information",
                            "",
                            {},
                            true,
                            function(e, f, g)
                            end,
                            RMenu:Get("FR", "subadmindailyboot")
                        )
                    else
                        RageUI.Separator("Loading...")
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("FR", "subadmindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.ButtonWithStyle(
                        "Redeem Time",
                        "Change the time the daily boot is redeemable",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("FR:RequestChange", "openingtime")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Reward Money",
                        "Change the reward of the daily boot",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("FR:RequestChange", "moneyreward")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Reward Items",
                        "Change the reward items of the daily boot",
                        {},
                        true,
                        function(e, f, g)
                        end,
                        RMenu:Get("FR", "weaponadmindailyboot")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("FR", "weaponadmindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    for c, d in pairs(weaponlist.weapons) do
                        print(d.wepname)
                        print(d.weight)
                        print(d.checked)
                    end
                    RageUI.ButtonWithStyle(
                        "Cancel",
                        "",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                for c, d in pairs(weaponlist) do
                                    b[c] = false
                                end
                            end
                        end,
                        RMenu:Get("FR", "subadmindailyboot")
                    )
                    RageUI.ButtonWithStyle(
                        "Confirm",
                        "",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("FR:RequestChange", "rewarditems", b)
                                b = {}
                            end
                        end
                    )
                end
            )
        end
    end
)
RegisterNetEvent(
    "FR:ReturnAdminBootTable",
    function(h, i)
        weaponlist = i
        a = h
        RageUI.Visible(RMenu:Get("FR", "admindailyboot"), not RageUI.Visible(RMenu:Get("FR", "admindailyboot")))
    end
)
RegisterNetEvent(
    "FR:RefreshBootData",
    function(h)
        a = h
    end
)
