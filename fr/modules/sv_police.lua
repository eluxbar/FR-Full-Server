
-- this module define some police tools and functions
local lang = FR.lang
local a = module("fr-assets", "cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = FR.getUserId(player)
    local data = FR.getUserDataTable(user_id)
    FRclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
        FR.getSubscriptions(user_id, function(cb, plushours, plathours)
          if cb then
            local maxWeight = 30
            if user_id == -1 then
              maxWeight = 1000
            elseif plathours > 0 then
              maxWeight = 50
            elseif plushours > 0 then
              maxWeight = 40
            end
            if FR.getInventoryWeight(user_id) <= maxWeight then
              isStoring[player] = true
              FRclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                  if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                    FR.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                      for i,c in pairs(a.weapons) do
                        if i == k and c.class ~= 'Melee' then
                          if v.ammo > 250 then
                            v.ammo = 250
                          end
                          FR.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                        end   
                      end
                    end
                  end
                end
                FRclient.notify(player,{"~g~Weapons Stored"})
                TriggerEvent('FR:RefreshInventory', player)
                FRclient.ClearWeapons(player,{})
                data.weapons = {}
                SetTimeout(3000,function()
                    isStoring[player] = nil 
                end)
              end)
            else
              FRclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
          end
        end)
      end 
    end)
end

local cooldowns = {}

RegisterServerEvent("FR:forceStoreSingleWeapon")
AddEventHandler("FR:forceStoreSingleWeapon", function(model)
    local source = source
    local user_id = FR.getUserId(source)
    local currentTime = os.time()
    
    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        FRclient.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        cooldowns[source] = currentTime

        if model ~= nil then
            FRclient.getWeapons(source, {}, function(weapons)
                for k, v in pairs(weapons) do
                    if k == model then
                        local new_weight = FR.getInventoryWeight(user_id) + FR.getItemWeight(model)
                        if new_weight <= FR.getInventoryMaxWeight(user_id) then
                            RemoveWeaponFromPed(GetPlayerPed(source), k)
                            FRclient.removeWeapon(source, {k})
                            FR.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                            if v.ammo > 0 then
                                for i, c in pairs(a.weapons) do
                                    if i == model and c.class ~= 'Melee' then
                                        FR.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterCommand('storeallweapons', function(source)
    local source = source
    local currentTime = os.time()

    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        FRclient.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        choice_store_weapons(source)
        cooldowns[source] = currentTime
    end
end)

RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') then
    TriggerClientEvent('FR:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  FRclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      FRclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and FR.hasPermission(user_id, 'admin.tickets')) or FR.hasPermission(user_id, 'police.armoury') then
          FRclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = FR.getUserId(nplayer)
              if (not FR.hasPermission(nplayer_id, 'police.armoury') or FR.hasPermission(nplayer_id, 'police.undercover')) then
                FRclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('FR:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('FR:unHandcuff', source, false)
                  else
                    TriggerClientEvent('FR:arrestCriminal', nplayer, source)
                    TriggerClientEvent('FR:arrestFromPolice', source)
                  end
                  TriggerClientEvent('FR:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('FR:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              FRclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  FRclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      FRclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and FR.hasPermission(user_id, 'admin.tickets')) or FR.hasPermission(user_id, 'police.armoury') then
          FRclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = FR.getUserId(nplayer)
              if (not FR.hasPermission(nplayer_id, 'police.armoury') or FR.hasPermission(nplayer_id, 'police.undercover')) then
                FRclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('FR:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('FR:unHandcuff', source, true)
                  else
                    TriggerClientEvent('FR:arrestCriminal', nplayer, source)
                    TriggerClientEvent('FR:arrestFromPolice', source)
                  end
                  TriggerClientEvent('FR:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('FR:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              FRclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function FR.handcuffKeys(source)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    FRclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = FR.getUserId(nplayer)
        FRclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            FR.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('FR:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('FR:unHandcuff', source, false)
            TriggerClientEvent('FR:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('FR:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        FRclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

function FR.handcuff(source)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.getInventoryItemAmount(user_id, 'handcuff') >= 1 then
    FRclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = FR.getUserId(nplayer)
        FRclient.isHandcuffed(nplayer,{},function(handcuffed)
          if not handcuffed then
            FR.tryGetInventoryItem(user_id, 'handcuff', 1)
            TriggerClientEvent('FR:toggleHandcuffs', nplayer, true)
            TriggerClientEvent('FR:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        FRclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("FR:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            FRclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('FR:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('FR:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('FR:dragPlayer')
AddEventHandler('FR:dragPlayer', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and (FR.hasPermission(user_id, "police.armoury") or FR.hasPermission(user_id, "hmp.menu")) then
      if playersrc ~= nil then
        local nuser_id = FR.getUserId(playersrc)
          if nuser_id ~= nil then
            FRclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("FR:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("FR:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    FRclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              FRclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          FRclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('FR:putInVehicle')
AddEventHandler('FR:putInVehicle', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and FR.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        FRclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            FRclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            FRclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('FR:ejectFromVehicle')
AddEventHandler('FR:ejectFromVehicle', function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and FR.hasPermission(user_id, "police.armoury") then
      FRclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = FR.getUserId(nplayer)
        if nuser_id ~= nil then
          FRclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              FRclient.ejectVehicle(nplayer, {})
            else
              FRclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          FRclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("FR:Knockout")
AddEventHandler('FR:Knockout', function()
    local source = source
    local user_id = FR.getUserId(source)
    FRclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = FR.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('FR:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('FR:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("FR:KnockoutNoAnim")
AddEventHandler('FR:KnockoutNoAnim', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Founder') or FR.hasGroup(user_id, 'Developer') or FR.hasGroup(user_id, 'Lead Developer') then
      FRclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = FR.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('FR:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('FR:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("FR:requestPlaceBagOnHead")
AddEventHandler('FR:requestPlaceBagOnHead', function()
    local source = source
    local user_id = FR.getUserId(source)
    if FR.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      FRclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = FR.getUserId(nplayer)
          if nuser_id ~= nil then
              FR.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('FR:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('FR:gunshotTest')
AddEventHandler('FR:gunshotTest', function(playersrc)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and FR.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        FRclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            FRclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            FRclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('FR:tryTackle')
AddEventHandler('FR:tryTackle', function(id)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') or FR.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('FR:playTackle', source)
        TriggerClientEvent('FR:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasGroup(user_id, 'Drone Trained') or FR.hasGroup(user_id, 'Lead Developer') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('FR:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('FR:startThrowSmokeGrenade')
AddEventHandler('FR:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('FR:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('FR:breathalyserCommand', source)
  end
end)

RegisterServerEvent('FR:breathalyserRequest')
AddEventHandler('FR:breathalyserRequest', function(temp)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('FR:beingBreathalysed', temp)
      TriggerClientEvent('FR:breathTestResult', source, math.random(0, 100), FR.getPlayerName(temp))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
  ['5.56mm NATO'] = true,
}

RegisterServerEvent('FR:seizeWeapons')
AddEventHandler('FR:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
      FRclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = FR.getUserId(playerSrc)
          local cdata = FR.getUserDataTable(player_id)
          for a,b in pairs(cdata.inventory) do
              if string.find(a, 'wbody|') then
                  c = a:gsub('wbody|', '')
                  cdata.inventory[c] = b
                  cdata.inventory[a] = nil
              end
          end
          for k,v in pairs(a.weapons) do
              if cdata.inventory[k] ~= nil then
                  if not v.policeWeapon then
                    cdata.inventory[k] = nil
                  end
              end
          end
          for c,d in pairs(cdata.inventory) do
              if seizeBullets[c] then
                cdata.inventory[c] = nil
              end
          end
          TriggerEvent('FR:RefreshInventory', playerSrc)
          FRclient.notify(source, {'Seized weapons.'})
          FRclient.notify(playerSrc, {'Your weapons have been seized.'})
        end
      end)
    end
end)

seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('FR:seizeIllegals')
AddEventHandler('FR:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') then
      local player_id = FR.getUserId(playerSrc)
      local cdata = FR.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('FR:RefreshInventory', playerSrc)
      FRclient.notify(source, {'~r~Seized illegals.'})
      FRclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("FR:newPanic")
AddEventHandler("FR:newPanic", function(a,b)
	local source = source
	local user_id = FR.getUserId(source)
    if FR.hasPermission(user_id, 'police.armoury') or FR.hasPermission(user_id, 'hmp.menu') or FR.hasPermission(user_id, 'nhs.menu') or FR.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("FR:returnPanic", -1, nil, a, b)
        FR.sendWebhook(getPlayerFaction(user_id)..'-panic', 'FR Panic Logs', "> Player Name: **"..FR.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("FR:flashbangThrown")
AddEventHandler("FR:flashbangThrown", function(coords)   
    TriggerClientEvent("FR:flashbangExplode", -1, coords)
end)

RegisterNetEvent("FR:updateSpotlight")
AddEventHandler("FR:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("FR:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') then
    FRclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        FRclient.getPoliceCallsign(source, {}, function(callsign)
          FRclient.getPoliceRank(source, {}, function(rank)
            FRclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            FRclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..FR.getPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('FR:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  if FR.hasPermission(user_id, 'police.armoury') then
    FRclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        FRclient.getPoliceCallsign(source, {}, function(callsign)
          FRclient.getPoliceRank(source, {}, function(rank)
            FRclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            FRclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('FR:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
