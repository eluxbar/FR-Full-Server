Citizen.CreateThread(function()
  while true do
      for k,v in pairs(FR.getUsers()) do
        FRclient.copBlips(v, {}, function(blipsEnabled)
          if blipsEnabled then
            local emergencyblips = {}
            if FR.hasGroup(k, 'polblips') and (FR.hasPermission(k, 'police.armoury') or FR.hasPermission(k, 'nhs.menu')) then
              for a,b in pairs(FR.getUsers()) do
                local dead = 0
                local health = GetEntityHealth(GetPlayerPed(b))
                local colour = nil
                if health > 102 then
                  dead = 0
                else
                  dead = 1
                end
                if FR.hasPermission(a, 'police.armoury') then
                  colour = 3
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour, bucket = GetPlayerRoutingBucket(b)})
                elseif FR.hasPermission(a, 'nhs.menu') then
                  colour = 2
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour, bucket = GetPlayerRoutingBucket(b)})
                end
              end
            end
            TriggerClientEvent('FR:sendFarBlips', v, emergencyblips)
          end
        end)
      end
      Citizen.Wait(10000)
  end
end)
