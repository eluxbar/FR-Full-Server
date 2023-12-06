
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("FR:buyLicense")
AddEventHandler('FR:buyLicense', function(job, name)
    local source = source
    local user_id = FR.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not FR.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        FRclient.notify(source, {"You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if FR.hasGroup(user_id, job) then 
            FRclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("FR:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if FR.tryFullPayment(user_id, v.price) then
                        FR.addUserGroup(user_id,job)
                        FRclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        FR.sendWebhook('purchases',"FR License Centre Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("FR:PlaySound", source, "playMoney")
                        TriggerClientEvent("FR:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("FR:refreshGunStorePermissions", source)
                    else 
                        FRclient.notify(source, {"You do not have enough money to purchase this license!"})
                        TriggerClientEvent("FR:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("FR:acBan", userid, 11, FR.getPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)

RegisterServerEvent("FR:refundLicense")
AddEventHandler('FR:refundLicense', function(job, name)
    local source = source
    local user_id = FR.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 15.0 then
        local refundPercentage = 0.25
        for k, v in pairs(cfg.licenses) do
            if v.group == job then
                local refundAmount = v.price * refundPercentage
                FR.setBankMoney(user_id, FR.getBankMoney(user_id) + refundAmount)
                FR.removeUserGroup(user_id, job)
                FRclient.notify(source, {"~g~Refunded " .. name .. " for " .. '£' .. tostring(getMoneyStringFormatted(refundAmount))})
                FR.sendWebhook('purchases', "FR License Centre Logs Refund", "> Player Name: **" .. FR.getPlayerName(source) .. "**\n> Player TempID: **" .. source .. "**\n> Player PermID: **" .. user_id .. "**\n> Refund: **" .. name .. "**")
                TriggerClientEvent("FR:PlaySound", source, "playMoney")
                TriggerClientEvent("FR:gotOwnedLicenses", source, getLicenses(user_id))
                TriggerClientEvent("FR:refreshGunStorePermissions", source)
            end
        end
    else 
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger License Menu Refund')
    end
end)







function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if FR.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("FR:GetLicenses")
AddEventHandler("FR:GetLicenses", function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("FR:ReceivedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("FR:getOwnedLicenses")
AddEventHandler("FR:getOwnedLicenses", function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("FR:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)