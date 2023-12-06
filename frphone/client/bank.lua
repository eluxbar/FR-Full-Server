
inMenu = true
local bank = 0
function setBankBalance (value)
    bank = value
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent("FR:initMoney")
AddEventHandler("FR:initMoney", function(cashMoney,bankMoney)
    setBankBalance(bankMoney)
end)

RegisterNetEvent("FR:setDisplayBankMoney", function(value)
    setBankBalance(value)
end)

RegisterNUICallback("bank_transfer", function(data)
    TriggerServerEvent("FR:bankTransfer", data.user_id, data.amount)
end)