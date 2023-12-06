RegisterServerEvent("FR:adminTicketFeedback")
AddEventHandler("FR:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    local AdminID = FR.getUserId(AdminID)
    local AdminSource = FR.getSourceFromUserId(AdminID)
    local AdminName = FR.getPlayerName(AdminSource)

    local FeedBackType = FeedBackType
    local PlayerName = FR.getPlayerName(source) -- source now refers to the player
    local PlayerID = FR.getUserId(source) -- source now refers to the player

    -- Check and replace nil values with "N/A" for local variables
    local AdminID = AdminID or "N/A"
    local AdminName = AdminName or "N/A"
    local PlayerName = PlayerName or "N/A"
    local PlayerID = PlayerID or "N/A"
    local FeedBackType = FeedBackType or "N/A"

    if Message == "" then
        Message = "No Feedback Provided."
    end

    local feedbackInfo = "> Player Name: **" .. PlayerName .. "**\n" ..
                         "> Player PermID: **" .. PlayerID .. "**\n" ..
                         "> Feedback Type: **" .. FeedBackType .. "**\n" ..
                         "> Admin Perm ID**: " .. AdminID .. "**\n" ..
                         "> Admin Name**: " .. AdminName .. "**\n" ..
                         "> Message: **" .. Message .. "**\n"

    FR.sendWebhook('feedback', 'FR Feedback Logs', feedbackInfo)

    if FeedBackType == "good" then
        FR.giveBankMoney(AdminID, 25000)
        FRclient.notify(AdminSource, {"~g~You have received £25000 for a good feedback."})
        FRclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        FR.giveBankMoney(AdminID, 10000)
        FRclient.notify(AdminSource, {"~g~You have received £10000 for a neutral feedback."})
        FRclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        FR.giveBankMoney(AdminID, 5000)
        FRclient.notify(AdminSource, {"~g~You have received £5000 for a bad feedback."})
        FRclient.notify(source, {"~r~You have given a Bad feedback."})
    end
end)



RegisterServerEvent("FR:adminTicketNoFeedback")
AddEventHandler("FR:adminTicketNoFeedback", function(PlayerSource, AdminPermID)
    if PlayerSource == nil then
        return
    end
    local PlayerName = FR.getPlayerName(PlayerSource)
    local AdminID = FR.getUserId(source) -- 'source' here is the admin who receives the feedback
    local AdminName = FR.getPlayerName(AdminID)
    local AdminPermID = FR.getUserId(AdminID)
    local PlayerID = FR.getUserId(PlayerSource)
    if FeedBackType == "good" then
        FR.giveBankMoney(AdminPermID, 25000)
        FRclient.notify(AdminID, {"~g~You have received £25000 for a good feedback."})
        FRclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        FR.giveBankMoney(AdminPermID, 10000)
        FRclient.notify(AdminID, {"~g~You have received £10000 for a good feedback."})
        FRclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        FR.giveBankMoney(AdminPermID, 5000)
        FRclient.notify(AdminID, {"~g~You have received £5000 for a good feedback."})
        FRclient.notify(source, {"~r~You have given a Bad feedback."})
    end
    FR.sendWebhook('feedback', 'FR Feedback Logs', "> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> **Feedback Type**"..FeedbackType.."\n> **Admin Perm ID: **"..AdminPermID)
end)