RegisterNetEvent("FR:mutePlayers",function(a)for b,c in pairs(a)do exports["fr"]:mutePlayer(c,true)end end)RegisterNetEvent("FR:mutePlayer",function(c)exports["fr"]:mutePlayer(c,true)end)RegisterNetEvent("FR:unmutePlayer",function(c)exports["fr"]:mutePlayer(c,false)end)RegisterNetEvent("FR:ToggleMutePlayer",function(c)exports["fr"]:mutePlayer(c,true)Citizen.Wait(60000)exports["fr"]:mutePlayer(c,false)end)function unmute(c)MumbleSetActive(false)end