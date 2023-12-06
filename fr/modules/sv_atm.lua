local cfg = module("cfg/atms")
local organcfg = module("cfg/cfg_organheist")
local lang = FR.lang

RegisterServerEvent("FR:Withdraw")
AddEventHandler('FR:Withdraw', function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if FR.tryWithdraw(user_id, amount) then
                    FRclient.notify(source, {"You have withdrawn £"..getMoneyStringFormatted(amount)})
                else 
                    FRclient.notify(source, {"You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)
RegisterServerEvent("FR:Deposit")
AddEventHandler('FR:Deposit', function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if FR.tryDeposit(user_id, amount) then
                    FRclient.notify(source, {"You have deposited £"..getMoneyStringFormatted(amount)})
                else 
                    FRclient.notify(source, {"You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

RegisterServerEvent("FR:WithdrawAll")
AddEventHandler('FR:WithdrawAll', function()
    local source = source
    local user_id = FR.getUserId(source)
    local amount = FR.getBankMoney(FR.getUserId(source))
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if FR.tryWithdraw(user_id, amount) then
                    FRclient.notify(source, {"You have withdrawn £"..getMoneyStringFormatted(amount)})
                else 
                    FRclient.notify(source, {"You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)

RegisterServerEvent("FR:DepositAll")
AddEventHandler('FR:DepositAll', function()
    local source = source
    local user_id = FR.getUserId(source)
    local amount = FR.getMoney(FR.getUserId(source))
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if FR.tryDeposit(user_id, amount) then
                    FRclient.notify(source, {"You have deposited £"..getMoneyStringFormatted(amount)})
                else 
                    FRclient.notify(source, {"You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

function CloseToATM(coords)
    local checks = 0
    for _, location in ipairs(cfg.atms) do
        if #(coords - location) <= 15.0 then
            checks = checks + 1
        end
    end
    for _, location in ipairs(organcfg.locations) do
        if #(coords - location.atmLocation) <= 15.0 then
            checks = checks + 1
        end
    end
    return checks >= 1
end
