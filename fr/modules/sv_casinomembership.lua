RegisterNetEvent('FR:purchaseHighRollersMembership')
AddEventHandler('FR:purchaseHighRollersMembership', function()
    local source = source
    local user_id = FR.getUserId(source)
    if not FR.hasGroup(user_id, 'Highroller') then
        if FR.tryFullPayment(user_id,10000000) then
            FR.addUserGroup(user_id, 'Highroller')
            FRclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            FR.sendWebhook('purchase-highrollers',"FR Purchased Highrollers Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            FRclient.notify(source, {'You do not have enough money to purchase this membership.'})
        end
    else
        FRclient.notify(source, {"You already have High Roller's License."})
    end
end)

RegisterNetEvent('FR:removeHighRollersMembership')
AddEventHandler('FR:removeHighRollersMembership', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Highroller') then
        FR.removeUserGroup(user_id, 'Highroller')
    else
        FRclient.notify(source, {"You do not have High Roller's License."})
    end
end)