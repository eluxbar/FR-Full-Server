RegisterNetEvent("FR:tchat_receive")
AddEventHandler("FR:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("FR:tchat_channel")
AddEventHandler("FR:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('FR:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('FR:tchat_channel', data.channel)
end)
