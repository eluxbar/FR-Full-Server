local verifyCodes = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for k, v in pairs(verifyCodes) do
            if verifyCodes[k] ~= nil then
                verifyCodes[k] = nil
            end
        end
    end
end)

RegisterServerEvent('FR:changeLinkedDiscord', function()
    local source = source
    local user_id = FR.getUserId(source)
    FR.prompt(source, "Enter Discord Id:", "", function(source, discordid)
        if discordid ~= nil then
            TriggerClientEvent('FR:gotDiscord', source)
            generateUUID({"linkcode", 5, "alphanumeric"}, function(code)
                verifyCodes[user_id] = { code = code, discordid = discordid, timestamp = os.time() }
                exports['fr-bot']:dmUser(source, { discordid, code, user_id }, function() end)
            end)
        end
    end)
end)

RegisterServerEvent('FR:enterDiscordCode', function()
    local source = source
    local user_id = FR.getUserId(source)
    local currentTimestamp = os.time()
    local verification = verifyCodes[user_id]

    if verification and currentTimestamp - verification.timestamp <= 300 then
        FR.prompt(source, "Enter Code:", "", function(source, code)
            if code and code ~= "" then
                if verification.code == code then
                    exports['fr']:execute("UPDATE `fr_verification` SET discord_id = @discord_id WHERE user_id = @user_id", { user_id = user_id, discord_id = verification.discordid }, function() end)
                    FRclient.notify(source, { '~g~Your discord has been successfully updated.' })
                else
                    FRclient.notify(source, { '~r~Invalid code.' })
                end
            else
                FRclient.notify(source, { '~r~You need to enter a code!' })
            end
        end)
    else
        FRclient.notify(source, { '~r~Your code has expired.' })
    end
end)
