
local items = {}
local a = module("fr-assets", "cfg/weapons")

items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["Headbag"] = {"Head Bag","Used to cover someone's head.",nil,0.5}
items["Shaver"] = {"Shaver","Used to shave someone's head.",nil,0.5}
items["handcuffkeys"] = {"Handcuff Keys","Used to uncuff someone.",nil,0.5}
items["handcuff"] = {"Handcuff","Used to cuff someone.",nil,0.5}
items["rock"] = {"Rock","This Is Useless.",nil,0.5}
items["hackingDevice"] = {"Hacking Device", "This Is For Jewelry Hiest",nil,2.5}
items["sapphire"] = {"Sapphire", "",nil,0.5}
items["jewelry_necklace"] = {"Necklace", "",nil,0.5}
items["jewelry_watch"] = {"Watch", "",nil,0.5}
items["jewelry_ring"] = {"Ring", "",nil,0.5}

-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  for k,v in pairs(a.weapons) do
    if k == weapon_id then
      return v.name
    end
  end
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2])
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = FR.getUserId(player)
    if user_id ~= nil then
      if FR.tryGetInventoryItem(user_id, fullidname, 1, true) then
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        for k,v in pairs(a.weapons) do
          if k == args[2] then
            if v.policeWeapon then
              if FR.hasPermission(user_id, 'police.armoury') then
                FRclient.giveWeapons(player, {weapons, false})
              else
                FRclient.notify(player, {'You can not equip this weapon.'})
              end
            else
              FRclient.giveWeapons(player, {weapons, false})
            end
          end
        end
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  for k,v in pairs(a.weapons) do
    for c,d in pairs(args) do
      if k == d then
        if v.class == "Melee" then
          return 1.00
        elseif v.class == "Pistol" then
          return 5.00
        elseif v.class == "SMG" or v.class == "Shotgun" then
          return 7.50
        elseif v.class == "AR" then
          return 10.00
        elseif v.class == "Heavy" or v.class == "LMG" then
          return 15.00
        else
          return 1.00
        end
      end
    end
  end
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local wammo_name = function(args)
  --print('helloo', json.encode(args))
  return args[1]
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]

  choices["Load"] = {function(player,choice)
    local user_id = FR.getUserId(player)
    if user_id ~= nil then
      local amount = FR.getInventoryItemAmount(user_id, fullidname)
      if string.find(fullidname, "Police") and not FR.hasPermission(user_id, 'police.armoury') then
        FRclient.notify(player, {'You cannot load this ammo.'})
        local bulletAmount = FR.getInventoryItemAmount(user_id, fullidname)
        FR.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      FR.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        FRclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  if FR.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = ramount}
                    FRclient.giveWeapons(player, {weapons,false})
                    TriggerEvent('FR:RefreshInventory', player)
                    return
                  end
                end
              end
            end
          end
        end)
      end)
    end
  end}
  choices["LoadAll"] = {function(player,choice)
    local user_id = FR.getUserId(player)
    if user_id ~= nil then
      ramount = parseInt(FR.getInventoryItemAmount(user_id, fullidname))
      if ramount > 250 then ramount = 250 end
      if string.find(fullidname, "Police") and not FR.hasPermission(user_id, 'police.armoury') then
        FRclient.notify(player, {'You cannot load this ammo.'})
        local bulletAmount = FR.getInventoryItemAmount(user_id, fullidname)
        FR.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      FRclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
        for k,v in pairs(a.weapons) do -- goes through new weapons cfg
          for c,d in pairs(uweapons) do -- goes through current weapons
            if k == c then  -- if weapon in new cfg is the same as in current weapons
              if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                if FR.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                  local weapons = {}
                  weapons[k] = {ammo = ramount}
                  FRclient.giveWeapons(player, {weapons,false})
                  TriggerEvent('FR:RefreshInventory', player)
                  return
                end
              end
            end
          end
        end
      end)
    end
  end}
  choices["GiveAll"] = {
    function(idname, player, choice)
        local user_id = FR.getUserId(player)

        if user_id == nil then
            return
        end

        local itemAmount = FR.getInventoryItemAmount(user_id, idname)

        if itemAmount <= 0 then
            FRclient.notify(player, {'You don\'t have any of that item to give!'})
            return
        end

        FRclient.getNearestPlayers(player, {10}, function(nplayers)
            local numPlayers = 0
            local nplayerIds = {}

            for k, _ in pairs(nplayers) do
                numPlayers = numPlayers + 1
                table.insert(nplayerIds, k)
            end

            if numPlayers == 1 then
                local nplayerId = nplayerIds[1]
                local nuser_id = FR.getUserId(nplayerId)

                if nuser_id ~= nil then
                    local inventoryWeight = FR.getInventoryWeight(nuser_id)
                    local itemWeight = FR.getItemWeight(idname)
                    local maxWeight = FR.getInventoryMaxWeight(nuser_id)
                    local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                    local amountToGive = math.min(itemAmount, availableSpace)

                    if amountToGive > 0 then
                        if FR.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                            FR.giveInventoryItem(nuser_id, idname, amountToGive, true)
                            TriggerEvent('FR:RefreshInventory', player)
                            TriggerEvent('FR:RefreshInventory', nplayerId)
                            FRclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                            FRclient.playAnim(nplayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                        else
                            FRclient.notify(player, {'Invalid value.'})
                        end
                    end
                else
                    FRclient.notify(player, {'Invalid Temp ID for Player ' .. nplayerId})
                end
            elseif numPlayers > 1 then
                local usrList = ""

                for k, _ in pairs(nplayers) do
                    usrList = usrList .. "[" .. k .. "]" .. GetPlayerName(k) .. " | "
                end

                FR.prompt(player, "Players Nearby: " .. usrList, "", function(player, nplayer)
                    nplayer = tonumber(nplayer)

                    if nplayer and nplayers[nplayer] then
                        local selectedPlayerId = nplayer
                        local selectedPlayer = nplayers[selectedPlayerId]
                        local nuser_id = FR.getUserId(selectedPlayerId)

                        if nuser_id ~= nil then
                            local inventoryWeight = FR.getInventoryWeight(nuser_id)
                            local itemWeight = FR.getItemWeight(idname)
                            local maxWeight = FR.getInventoryMaxWeight(nuser_id)
                            local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                            local amountToGive = math.min(itemAmount, availableSpace)

                            if amountToGive > 0 then
                                if FR.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                                    FR.giveInventoryItem(nuser_id, idname, amountToGive, true)
                                    TriggerEvent('FR:RefreshInventory', player)
                                    TriggerEvent('FR:RefreshInventory', selectedPlayerId)
                                    FRclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                                    FRclient.playAnim(selectedPlayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                                else
                                    FRclient.notify(player, {'Invalid value.'})
                                end
                            end
                        else
                            FRclient.notify(player, {'Invalid Temp ID for Player ' .. selectedPlayerId})
                        end
                    else
                        FRclient.notify(player, {'Invalid selection or player.'})
                    end
                end)
            else
                FRclient.notify(player, {'No players nearby!'})
            end
        end)
    end
}





  return choices
end

local wammo_weight = function(args)
  return 0.01
end

for i,v in pairs(FRAmmoTypes) do
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
