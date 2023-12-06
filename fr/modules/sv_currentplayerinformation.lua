function FR.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(FR.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = FR.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = FR.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("FR:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end


AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
    FR.updateCurrentPlayerInfo()
  end
end)