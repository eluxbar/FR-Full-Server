local cfg = module("cfg/survival")
local lang = FR.lang


-- handlers

-- init values
AddEventHandler("FR:playerJoin", function(user_id, source, name, last_login)
    local data = FR.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = FR.getUserId(player)
    if user_id ~= nil then
        FRclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = FR.getUserId(nplayer)
            if nuser_id ~= nil then
                FRclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if FR.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            FRclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                FRclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        FRclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                FRclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('FR:SearchForPlayer')
AddEventHandler('FR:SearchForPlayer', function()
    TriggerClientEvent('FR:ReceiveSearch', -1, source)
end)


