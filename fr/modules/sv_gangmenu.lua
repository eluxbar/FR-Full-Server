local gangWithdraw = {}
local gangDeposit = {}
local gangTable = {}
local playerinvites = {}
local fundscooldown = {}
local cooldown = 5
MySQL.createCommand("fr_edituser", "UPDATE fr_user_gangs SET gangname = @gangname WHERE user_id = @user_id")
MySQL.createCommand("fr_adduser", "INSERT IGNORE INTO fr_user_gangs (user_id,gangname) VALUES (@user_id,@gangname)")
RegisterServerEvent('FR:CreateGang', function(gangName)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id,"Gang") then
        local hasgang = FR.getGangName(user_id)
        if hasgang == nil or hasgang == "" then
            exports['fr']:execute("SELECT * FROM fr_user_gangs WHERE gangname = @gang", {gang = gangName}, function(gangData)
                if #gangData <= 0 then
                    local gangTable = {[tostring(user_id)] = {["rank"] = 4,["gangPermission"] = 4,["color"] = "White"}}
                    gangTables = json.encode(gangTable)
                    FRclient.notify(source, {"~g~Gang created."})
                    MySQL.execute("fr_edituser", {user_id = user_id, gangname = gangName})
                    exports['fr']:execute("INSERT INTO fr_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangName,gangmembers=gangTables,funds=0,logs="NOTHING"}, function() end)
                    TriggerClientEvent("FR:gangNameNotTaken",source)
                    TriggerClientEvent("FR:ForceRefreshData",source)
                else
                    FRclient.notify(source, {"~r~Gang already exists."})
                end
            end)
        else
            FRclient.notify(source, {"~r~You already have a gang, If not contact a developer."})
        end
    else
        FRclient.notify(source, {"~r~You do not have gang licence."})
    end
end)

RegisterServerEvent("FR:GetGangData",function()
    local source = source
    local user_id = FR.getUserId(source)
    local gangName = FR.getGangName(user_id)
    if gangName and gangName ~= "" then
        local gangmembers = {}
        local gangData = {}
        local ganglogs = {}
        local memberids = {}
        local gangpermission = {}
        exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(gangInfo)
            local gangInfo = gangInfo[1]
            local gangMembers = json.decode(gangInfo.gangmembers)
            gangData["money"] = math.floor(gangInfo.funds)
            gangData["id"] = gangName
            gangpermission = tonumber(gangMembers[tostring(user_id)].gangPermission)
            ganglogs = json.decode(gangInfo.logs)
            ganglock = tobool(gangInfo.lockedfunds)
            for member_id, member_data in pairs(gangMembers) do
                memberids[#memberids+1] = tostring(member_id)
            end
            local placeholders = string.rep('?,', #memberids):sub(1, -2)
            local playerData = exports['fr']:executeSync('SELECT * FROM fr_users WHERE id IN (' .. placeholders .. ')', memberids)
            local userData = exports['fr']:executeSync('SELECT * FROM fr_user_data WHERE user_id IN (' .. placeholders .. ')', memberids)
            for _,playerRow in ipairs(playerData) do
                local member_id = tonumber(playerRow.id)
                local gangpermission = tonumber(gangMembers[tostring(member_id)].gangPermission)
                local online
                if playerRow.banned then
                    online = '~r~Banned'
                elseif FR.getUserSource(member_id) then
                    online = '~g~Online'
                elseif playerRow.last_login then
                    online = '~y~Offline'
                else
                    online = '~r~Never joined'
                end
                local playtime = 0

                for _, userData in ipairs(userData) do
                    if userData.user_id == member_id and userData.dkey == 'FR:datatable' then
                        local data = json.decode(userData.dvalue)

                        playtime = math.ceil((data.PlayerTime or 0) / 60)
                        if playtime < 1 then
                            playtime = 0
                        end
                        break
                    end
                end
                table.insert(gangmembers,{playerRow.username,member_id,gangpermission,online,playtime})
            end
            for _,member_id in ipairs(memberids) do
                local tempid = FR.getUserSource(tonumber(member_id))
                if tempid then
                    TriggerClientEvent('FR:GotGangData',tempid,gangData,gangmembers,gangpermission,ganglogs,ganglock,false)
                end
            end
        end)
    end
end)



RegisterServerEvent("FR:addUserToGang",function(gangName)
    local source = source
    local user_id = FR.getUserId(source)
    if table.includes(playerinvites[source],gangName) then
        exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname",{gangname = gangName}, function(ganginfo)
            if json.encode(ganginfo) == "[]" and ganginfo == nil and json.encode(ganginfo) == nil then
                FRclient.notify(source, {"~b~Gang no longer exists."})
                return
            end
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(ganginfo) do
                gangmembers[tostring(user_id)] = {["rank"] = 1,["gangPermission"] = 1,["color"] = "White"}
                exports["fr"]:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname",{gangmembers = json.encode(gangmembers),gangname = gangName})
                MySQL.execute("fr_edituser", {user_id = user_id, gangname = gangName})
                TriggerClientEvent("FR:ForceRefreshData",source)
                syncRadio(source)
            end
        end)
    else
        FRclient.notify(source, {"~r~You have not been invited to this gang."})
    end
end)
local colourwait = false
RegisterServerEvent("FR:setPersonalGangBlipColour")
AddEventHandler("FR:setPersonalGangBlipColour", function(color)
    local source = source
    local user_id = FR.getUserId(source)
    local gangName = FR.getGangName(user_id)
    if gangName and gangName ~= "" then
        exports['fr']:execute('SELECT * FROM fr_gangs WHERE gangname = @gangname', {gangname = gangName}, function(gangs)
            if #gangs > 0 then
                local gangmembers = json.decode(gangs[1].gangmembers)
                gangmembers[tostring(user_id)] = {["rank"] = gangmembers[tostring(user_id)].rank, ["gangPermission"] = gangmembers[tostring(user_id)].gangPermission,["color"] = color}
                exports['fr']:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangName})
                TriggerClientEvent("FR:setGangMemberColour",-1,user_id,color)
            end
        end)
    end
end)

RegisterServerEvent("FR:depositGangBalance",function(gangname, amount)
    local source = source
    local user_id = FR.getUserId(source)
    exports['fr']:execute('SELECT * FROM fr_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        FRclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(FR.getBankMoney(user_id)) < tonumber(amount) then
                        FRclient.notify(source,{"~r~Not enough Money."})
                    else
                        FR.setBankMoney(user_id, (FR.getBankMoney(user_id))-tonumber(amount))
                        FRclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        addGangLog(FR.getPlayerName(source),user_id,"Deposited","£"..getMoneyStringFormatted(amount))
                        exports['fr']:execute("UPDATE fr_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(amount)+tonumber(funds), gangname = gangname})
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("FR:depositAllGangBalance", function()
    local source = source
    local user_id = FR.getUserId(source)
    local gangName = exports['fr']:executeSync("SELECT * FROM fr_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()

    if gangName and gangName ~= "" then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            local bank = FR.getBankMoney(user_id)
            exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(bank) < 0 then
                                FRclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            FR.setBankMoney(user_id, 0)
                            FRclient.notify(source, {"~g~Deposited £" .. getMoneyStringFormatted(bank) .. "\n£" .. getMoneyStringFormatted(tonumber(bank) * 0.02) .. " tax paid."})
                            addGangLog(FR.getPlayerName(source), user_id, "Deposited", "£" .. getMoneyStringFormatted(bank))
                            local newbal = tonumber(bank) + tonumber(gangfunds) - tonumber(bank) * 0.02
                            exports["fr"]:execute("UPDATE fr_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tostring(newbal), gangname = gangName})
                        end
                    end
                end
            end)
        else
            FRclient.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[source])) .. " seconds"})
        end
    end
end)

RegisterServerEvent("FR:withdrawAllGangBalance", function()
    local source = source
    local user_id = FR.getUserId(source)
    local gangName = exports['fr']:executeSync("SELECT * FROM fr_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()
    if gangName and gangName ~= "" then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(gangfunds) < 0 then
                                FRclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            FR.setBankMoney(user_id, (FR.getBankMoney(user_id)) + tonumber(gangfunds))
                            FRclient.notify(source, {"~g~Withdrew £" .. getMoneyStringFormatted(gangfunds)})
                            addGangLog(FR.getPlayerName(source), user_id, "Withdrew", "£" .. getMoneyStringFormatted(gangfunds))
                            exports["fr"]:execute("UPDATE fr_gangs SET funds = @funds WHERE gangname = @gangname", {funds = 0, gangname = gangName})
                        end
                    end
                end
            end)
        else
            FRclient.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[source])) .. " seconds"})
        end
    end
end)



RegisterServerEvent("FR:withdrawGangBalance",function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local gangName = FR.getGangName(user_id)
    if gangName and gangName ~= "" then
        if not gangWithdraw[source] then
            gangWithdraw[source] = true
            exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A,B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(amount) < 0 then
                                FRclient.notify(source,{"~r~Invalid Amount"})
                                return
                            end
                            if tonumber(gangfunds) < tonumber(amount) then
                                FRclient.notify(source,{"~r~Not enough Money."})
                            else
                                FR.setBankMoney(user_id, (FR.getBankMoney(user_id))+tonumber(amount))
                                FRclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                                addGangLog(FR.getPlayerName(source),user_id,"Withdrew","£"..getMoneyStringFormatted(amount))
                                exports["fr"]:execute("UPDATE fr_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(gangfunds)-tonumber(amount), gangname = gangName})
                            end
                        end
                    end
                    gangWithdraw[source] = false
                end
            end)
        end
    end
end)

RegisterServerEvent("FR:PromoteUser",function(gangname,memberid)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(memberid)].rank
                        local gangpermission = gangmembers[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            FRclient.notify(source, {"~r~Only the leader can promote."})
                            return
                        end
                        if gangmembers[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == A then
                            FRclient.notify(source, {"~r~There can only be one leader."})
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            FRclient.notify(source, {"~r~You are already the highest rank."})
                            return
                        end
                        gangmembers[tostring(memberid)].rank = tonumber(rank) + 1
                        gangmembers[tostring(memberid)].gangPermission = tonumber(gangpermission) + 1
                        FRclient.notify(source, {"~g~Promoted User."})
                        addGangLog(FR.getPlayerName(source),user_id,"Promoted","ID: "..memberid)
                        exports["fr"]:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:DemoteUser", function(gangname,member)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gang WHERE gangname = @gangname", {gangname = gangname},function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(member)].rank
                        local gangpermission = gangmembers[tostring(member)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            FRclient.notify(source, {"~r~Only the leader can demote."})
                            return
                        end
                        if gangmembers[tostring(member)].rank == 1 and gangpermission == 1 and tostring(user_id) == A then
                            FRclient.notify(source, {"~r~There can only be one leader."})
                        end
                        if tonumber(member) == tonumber(user_id) and rank == 1 and gangpermission == 1 then
                            FRclient.notify(source, {"~r~You are already the lowest rank."})
                            return
                        end
                        gangmembers[tostring(member)].rank = tonumber(rank)-1
                        gangmembers[tostring(member)].gangPermission = tonumber(gangpermission)-1
                        gangmembers = json.encode(gangmembers)
                        FRclient.notify(source, {"~g~Demoted User."})
                        addGangLog(FR.getPlayerName(source),user_id,"Demoted","ID: "..member)
                        exports["fr"]:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = gangmembers, gangname = gangname})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:KickUser",function(gangname,member)
    local source = source
    local user_id = FR.getUserId(source)
    local membersource = FR.getUserSource(member)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    local memberrank = gangmembers[tostring(member)].rank
                    local leaderrank = gangmembers[tostring(user_id)].rank
                    if B.rank >= 3 then
                        if tonumber(member) == tonumber(user_id) then
                            FRclient.notify(source, {"~r~You cannot kick yourself."})
                            return
                        end
                        if tonumber(memberrank) >= leaderrank then
                            FRclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                            return
                        end
                        gangmembers[tostring(member)] = nil
                        addGangLog(FR.getPlayerName(source),user_id,"Kicked","ID: "..member)
                        exports["fr"]:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                        MySQL.execute("fr_edituser", {user_id = member, gangname = nil})
                        if membersource then
                            FRclient.notify(membersource, {"~r~You have been kicked from the gang."})
                            syncRadio(membersource)
                            TriggerClientEvent("FR:disbandedGang",membersource)
                        end
                    else
                        FRclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:LeaveGang", function(gangname)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        FRclient.notify(source, {"~r~You cannot leave the gang as you are the leader."})
                        return
                    end
                    gangmembers[tostring(user_id)] = nil
                    exports["fr"]:execute("UPDATE fr_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    MySQL.execute("fr_edituser", {user_id = user_id, gangname = nil})
                    if FR.getUserSource(user_id) ~= nil then
                        FRclient.notify(source, {"~r~You have left the gang."})
                        syncRadio(source)
                        TriggerClientEvent("FR:disbandedGang",source)
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:InviteUser",function(gangname,playerid)
    local source = source
    local user_id = FR.getUserId(source)
    local playersource = FR.getUserSource(tonumber(playerid))
    if source ~= playersource then
        if playersource == nil then
            FRclient.notify(source, {"~r~Player is not online."})
            return
        else
            table.insert(playerinvites[playersource],gangname)
            addGangLog(FR.getPlayerName(source),user_id,"Invited","ID: "..playerid)
            TriggerClientEvent("FR:InviteReceived",playersource,"~g~Gang invite received from: " ..FR.getPlayerName(source),gangname)
            FRclient.notify(source, {"~g~Successfully invited " ..FR.getPlayerName(playersource).. " to the gang."})
        end
    else
        FRclient.notify(source, {"~r~You cannot invite yourself."})
    end
end)

RegisterServerEvent("FR:DeleteGang",function(gangname)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        exports["fr"]:execute("DELETE FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname})
                        for A,B in pairs(gangmembers) do
                            MySQL.execute("fr_edituser", {user_id = A, gangname = nil})
                            if FR.getUserSource(tonumber(A)) ~= nil then
                                syncRadio(FR.getUserSource(tonumber(A)))
                                TriggerClientEvent("FR:disbandedGang",FR.getUserSource(tonumber(A)))
                            else
                                print("User is not online, unable to disbanded gang for them.")
                            end
                        end
                        
                        FRclient.notify(source, {"~r~You have disbanded the gang."})
                    else
                        FRclient.notify(source, {"~r~You do not have permission to disband this gang."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:RenameGang", function(gangname,newname)
    local source = source
    local user_id = FR.getUserId(source)
    local gangnamecheck = exports["fr"]:scalarSync("SELECT gangname FROM fr_gangs WHERE gangname = @gangname", {gangname = newname})
    if gangnamecheck == nil then
        exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local gangmembers = json.decode(ganginfo[1].gangmembers)
                for A,B in pairs(gangmembers) do
                    if tostring(user_id) == A then
                        if B.rank == 4 then
                            exports["fr"]:execute("UPDATE fr_gangs SET gangname = @gangname WHERE gangname = @oldgangname", {gangname = newname, oldgangname = gangname})
                            for A,B in pairs(gangmembers) do
                                MySQL.execute("fr_edituser", {user_id = A, gangname = newname})
                                syncRadio(FR.getUserSource(tonumber(A)))
                            end
                            FRclient.notify(source, {"~g~You have renamed the gang to: " ..newname})
                        else
                            FRclient.notify(source, {"~r~You do not have permission to rename this gang."})
                        end
                    end
                end
            end
        end)
    else
        FRclient.notify(source, {"~r~Gang name is already taken."})
        return
    end
end)

RegisterServerEvent("FR:SetGangWebhook")
AddEventHandler("FR:SetGangWebhook", function(gangid)
    local source = source 
    local user_id = FR.getUserId(source)
    exports['fr']:execute('SELECT * FROM fr_gangs WHERE gangname = @gangname', {gangname = gangid}, function(G)
        for K, V in pairs(G) do
            local array = json.decode(V.gangmembers) -- Convert the JSON string to a table
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L["rank"] == 4 then
                        FR.prompt(source, "Webhook (Enter the webhook here): ", "", function(source, webhook)
                            local pattern = "^https://discord.com/api/webhooks/%d+/%S+$"
                            if webhook ~= nil and string.match(webhook, pattern) then 
                                exports['fr']:execute("UPDATE fr_gangs SET webhook = @webhook WHERE gangname = @gangname", {gangname = gangid, webhook = webhook}, function(gotGangs) end)
                                FRclient.notify(source, {"~g~Webhook set."})
                                TriggerClientEvent('FR:ForceRefreshData', -1)
                            else
                                FRclient.notify(source, {"~r~Invalid value."})
                            end
                        end)
                    else
                        FRclient.notify(source, {"~r~you do not have permission."})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("FR:LockGangFunds", function(gangname)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        local newlocked = not tobool(ganginfo[1].lockedfunds)
                        exports["fr"]:execute("UPDATE fr_gangs SET lockedfunds = @lockedfunds WHERE gangname = @gangname", {lockedfunds = newlocked, gangname = gangname}) 
                        FRclient.notify(source, {"~g~You have " ..(newlocked and "locked" or "unlocked") .." the gang funds."})
                        TriggerClientEvent("FR:ForceRefreshData",source)
                    else
                        FRclient.notify(source, {"~r~You do not have permission to lock the gang funds."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:sendGangMarker",function(Gangname,coords)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = Gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    for C,D in pairs(gangmembers) do
                        local temp = FR.getUserSource(tonumber(C))
                        if temp ~= nil then
                            TriggerClientEvent("FR:drawGangMarker",temp,FR.getPlayerName(source),coords)
                        end
                    end
                    break
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:setGangFit",function(gangName)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        FRclient.getCustomization(source,{},function(customization)
                            exports["fr"]:execute("UPDATE fr_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangfit = json.encode(customization), gangname = gangName})
                            FRclient.notify(source, {"~g~You have set the gang fit."})
                            TriggerClientEvent("FR:ForceRefreshData",source)
                        end)
                    else
                        FRclient.notify(source, {"~r~You do not have permission to set the gang fit."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("FR:applyGangFit", function(gangName)
    local source = source
    local user_id = FR.getUserId(source)
    exports["fr"]:execute("SELECT gangfit FROM fr_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            FRclient.setCustomization(source, {json.decode(ganginfo[1].gangfit)}, function()
                FRclient.notify(source, {"~g~You have applied the gang fit."})
            end)
        end
    end)
end)

AddEventHandler("FR:playerSpawn", function(user_id,source,fspawn)
    if fspawn then
        playerinvites[source] = {}
        exports["fr"]:execute("INSERT IGNORE INTO fr_user_gangs (user_id) VALUES (@user_id)", {user_id = user_id})
    end
end)

function addGangLog(playername,userid,action,actionvalue)
    local gangname = FR.getGangName(userid)
    if gangname and gangname ~= "" then
        exports["fr"]:execute("SELECT * FROM fr_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local ganglogs = {}
                if ganginfo[1].logs == "NOTHING" then
                    ganglogs = {}
                else
                    ganglogs = json.decode(ganginfo[1].logs)
                end
                if ganginfo[1].webhook then
                    FR.sendWebhook(ganginfo[1].webhook, gangname.."Gang Logs", "**Name:** " ..playername.. "**\n**User ID:** " ..userid.. "\n**Action:** " ..actionvalue)
                end
                table.insert(ganglogs,1,{playername,userid,os.date("%d/%m/%Y at %X"),action,actionvalue})
                exports["fr"]:execute("UPDATE fr_gangs SET logs = @logs WHERE gangname = @gangname", {logs = json.encode(ganglogs), gangname = gangname})
                TriggerClientEvent("FR:ForceRefreshData",FR.getUserSource(userid))
            end
        end)
    end
end

function FR.getGangName(user_id)
    return exports["fr"]:scalarSync("SELECT gangname FROM fr_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end
RegisterServerEvent("FR:newGangPanic")
AddEventHandler("FR:newGangPanic", function(a,playerName)
    local source = source
    local user_id = FR.getUserId(source)   
    local peoplesids = {}
    local gangmembers = {}
    exports['fr']:execute('SELECT * FROM fr_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['fr']:execute('SELECT * FROM fr_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = FR.getUserSource(tonumber(G.id))
                                if player ~= nil then
                                    TriggerClientEvent("FR:returnPanic", player, player, a, playerName)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)


local gangtable = {}
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        for _,a in pairs(GetPlayers()) do
            local user_id = FR.getUserId(a)
            if user_id ~= nil then
                gangtable[user_id] = {health = GetEntityHealth(GetPlayerPed(a)), armor = GetPedArmour(GetPlayerPed(a))}
            end
        end
        TriggerClientEvent("FR:sendGangHPStats", -1, gangtable)
    end
end)
Citizen.CreateThread(function()
    Wait(2500)
    exports['fr']:execute([[
    CREATE TABLE IF NOT EXISTS `fr_user_gangs` (
    `user_id` int(11) NOT NULL,
    `gangname` VARCHAR(100) NULL,
    PRIMARY KEY (`user_id`)
    );]])
end)


RegisterCommand("gangconvert",function(source)
    if source == 0 then
        exports['fr']:execute("SELECT * FROM fr_gangs",{},function(gangs)
            for A,B in pairs(gangs) do
                local gangmembers = json.decode(B.gangmembers)
                for C,D in pairs(gangmembers) do
                    print("Setting gang for user: "..C.." to "..B.gangname)
                    MySQL.execute("fr_adduser", {user_id = C, gangname = B.gangname})
                end
            end
        end)
    end
end)