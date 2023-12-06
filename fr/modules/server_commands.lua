RegisterCommand('addgroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        FR.addUserGroup(userid,group)
        print('Added Group: ' .. group .. ' to UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('removegroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        FR.removeUserGroup(userid,group)
        print('Removed Group: ' .. group .. ' from UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('ban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local hours = args[2]
        local reason = table.concat(args," ", 3)
        if reason then 
            FR.banConsole(userid,hours,reason)
        else 
            print('Incorrect usage: ban [permid] [hours] [reason]')
        end 
    else 
        print('Incorrect usage: ban [permid] [hours] [reason]')
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        FR.setBanned(userid,false)
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)


RegisterCommand('cashtoall', function(source, args)
    if source ~= 0 then return end;
    if tonumber(args[1])  then
        local amount = tonumber(args[1])
        print('Giving £' .. amount .. ' to all users')
        for k,v in pairs(FR.getUsers()) do
            FRclient.notify(v, {'~g~You have received £' .. getMoneyStringFormatted(amount) .. ' from the server'})
            FR.giveBankMoney(k, amount)
        end
    else 
        print('Incorrect usage: cashtoall [amount]')
    end
end)