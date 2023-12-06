local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("FR:getAnnounceMenu")
AddEventHandler("FR:getAnnounceMenu", function()
    local source = source
    local user_id = FR.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if FR.hasPermission(user_id, v.permission) or FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Lead Developer') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("FR:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("FR:serviceAnnounce")
AddEventHandler("FR:serviceAnnounce", function(announceType)
    local source = source
    local user_id = FR.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if FR.hasPermission(user_id, v.permission) or FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') then
                if FR.tryFullPayment(user_id, v.info.price) then
                    FR.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('FR:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            FRclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                            FR.sendWebhook('announce', "FR Announcement Logs", "```"..data.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        else
                            FRclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                            FR.sendWebhook('announce', "FR Announcement Logs", "```"..data.."```".."\n> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        end
                    end)
                else
                    FRclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)



RegisterCommand("consoleannounce", function(source, args)
    local source = source
    if source == 0 then
        local data = table.concat(args, " ")
        print("[FR Announcement] "..data)
        TriggerClientEvent('FR:serviceAnnounceCl', -1, 'https://i.imgur.com/FZMys0F.png', data)
        FR.sendWebhook('announce', "FR Announcement Logs", "```"..data.."```")
    else
        FRclient.notify(source, {"~r~You do not have permission to do this."})
    end
end)