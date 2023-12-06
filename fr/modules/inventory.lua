local lang = FR.lang
local cfg = module("cfg/cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

FR.items = {}

function FR.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  FR.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = FR.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      FR.prompt(player,lang.inventory.trash.prompt({FR.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if FR.tryGetInventoryItem(user_id,idname,amount,false) then
          FRclient.notify(player,{lang.inventory.trash.done({FR.getItemName(idname),amount})})
          FRclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          FRclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end
function ch_give(idname, player, choice)
  local user_id = FR.getUserId(player)
  if user_id ~= nil then
    FRclient.getNearestPlayers(player, {10}, function(nplayers) --get nearest players
      local numPlayers = 0
      local nplayerId = nil
      for k, v in pairs(nplayers) do
        numPlayers = numPlayers + 1
        nplayerId = k -- Store the last playerId in case there's only one nearby
      end

      if numPlayers == 1 then
        -- If there's only one player nearby, directly prompt for the amount
        FR.prompt(player, lang.inventory.give.prompt({FR.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
          local amount = parseInt(amount)
          local nplayer = nplayerId
          local nuser_id = FR.getUserId(nplayer)

          if nuser_id ~= nil then
            local itemAmount = FR.getInventoryItemAmount(user_id, idname)
            local inventoryWeight = FR.getInventoryWeight(nuser_id)
            local itemWeight = FR.getItemWeight(idname)

            -- Calculate new weight after giving items
            local newWeight = inventoryWeight + itemWeight * amount

            if newWeight <= FR.getInventoryMaxWeight(nuser_id) then
              if FR.tryGetInventoryItem(user_id, idname, amount, true) then
                FR.giveInventoryItem(nuser_id, idname, amount, true)
                TriggerEvent('FR:RefreshInventory', player)
                TriggerEvent('FR:RefreshInventory', nplayer)
                FRclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
                FRclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
              else
                FRclient.notify(player, { lang.common.invalid_value() })
              end
            else
              FRclient.notify(player, { lang.inventory.full() })
            end
          else
            FRclient.notify(player, { 'Invalid Temp ID.' })
          end
        end)
      elseif numPlayers > 1 then
        -- If there are multiple players nearby, show the player list
        usrList = ""
        for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. FR.getPlayerName(k) .. " | "
        end

        FR.prompt(player, "Players Nearby: " .. usrList, "", function(player, nplayer)
          nplayer = nplayer
          if nplayer ~= nil and nplayer ~= "" then
            local selectedPlayerId = tonumber(nplayer)
            if nplayers[selectedPlayerId] then
                FR.prompt(player, lang.inventory.give.prompt({FR.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
                local amount = parseInt(amount)
                local nplayer = selectedPlayerId
                local nuser_id = FR.getUserId(nplayer)

                if nuser_id ~= nil then
                  local itemAmount = FR.getInventoryItemAmount(user_id, idname)
                  local inventoryWeight = FR.getInventoryWeight(nuser_id)
                  local itemWeight = FR.getItemWeight(idname)
                  local newWeight = inventoryWeight + itemWeight * amount
                  if newWeight <= FR.getInventoryMaxWeight(nuser_id) then
                    if FR.tryGetInventoryItem(user_id, idname, amount, true) then
                      FR.giveInventoryItem(nuser_id, idname, amount, true)
                      TriggerEvent('FR:RefreshInventory', player)
                      TriggerEvent('FR:RefreshInventory', nplayer)
                      FRclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
                      FRclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
                    else
                      FRclient.notify(player, { lang.common.invalid_value() })
                    end
                  else
                    FRclient.notify(player, { lang.inventory.full() })
                  end
                else
                  FRclient.notify(player, { 'Invalid Temp ID.' })
                end
              end)
            else
              FRclient.notify(player, { 'Invalid Temp ID.' })
            end
          else
            FRclient.notify(player, { lang.common.no_player_near() })
          end
        end)
      else
        FRclient.notify(player, { "~r~No players nearby!" }) --no players nearby
      end
    end)
  end
end
-- trash action
function ch_trash(idname, player, choice)
  local user_id = FR.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    if FR.getInventoryItemAmount(user_id,idname) > 1 then 
      FR.prompt(player,lang.inventory.trash.prompt({FR.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if FR.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerEvent('FR:RefreshInventory', player)
          FRclient.notify(player,{lang.inventory.trash.done({FR.getItemName(idname),amount})})
          FRclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          FRclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    else
      if FR.tryGetInventoryItem(user_id,idname,1,false) then
        TriggerEvent('FR:RefreshInventory', player)
        FRclient.notify(player,{lang.inventory.trash.done({FR.getItemName(idname),1})})
        FRclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        FRclient.notify(player,{lang.common.invalid_value()})
      end
    end
  end
end

function FR.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function FR.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function FR.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function FR.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function FR.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function FR.getItemDefinition(idname)
  local args = FR.parseItem(idname)
  local item = FR.items[args[1]]
  if item ~= nil then
    return FR.computeItemName(item,args), FR.computeItemDescription(item,args), FR.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function FR.getItemName(idname)
  local args = FR.parseItem(idname)
  local item = FR.items[args[1]]
  if item ~= nil then return FR.computeItemName(item,args) end
  return args[1]
end

function FR.getItemDescription(idname)
  local args = FR.parseItem(idname)
  local item = FR.items[args[1]]
  if item ~= nil then return FR.computeItemDescription(item,args) end
  return ""
end

function FR.getItemChoices(idname)
  local args = FR.parseItem(idname)
  local item = FR.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = FR.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function FR.getItemWeight(idname)
  local args = FR.parseItem(idname)
  local item = FR.items[args[1]]
  if item ~= nil then return FR.computeItemWeight(item,args) end
  return 1
end

-- compute weight of a list of items (in inventory/chest format)
function FR.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = FR.getItemWeight(k)
    if iweight ~= nil then
      weight = weight+iweight*v.amount
    end
  end

  return weight
end

-- add item to a connected user inventory
function FR.giveInventoryItem(user_id,idname,amount,notify)
  local player = FR.getUserSource(user_id)
  if notify == nil then notify = true end -- notify by default

  local data = FR.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = FR.getUserSource(user_id)
      if player ~= nil then
        FRclient.notify(player,{lang.inventory.give.received({FR.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('FR:RefreshInventory', player)
end


function FR.RunTrashTask(source, itemName)
    local choices = FR.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = FR.getUserId(source)
        local data = FR.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
    end
    TriggerEvent('FR:RefreshInventory', source)
end


function FR.RunGiveTask(source, itemName)
    local choices = FR.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('FR:RefreshInventory', source)
end
function FR.RunGiveAllTask(source, itemName)
  local choices = FR.getItemChoices(itemName)
  if choices['GiveAll'] then
      choices['GiveAll'][1](itemName, source)
  end
  TriggerEvent('FR:RefreshInventory', source)
end

function FR.RunInventoryTask(source, itemName)
    local choices = FR.getItemChoices(itemName)
    if choices['Use'] then 
        choices['Use'][1](source)
    elseif choices['Drink'] then
        choices['Drink'][1](source)
    elseif choices['Load'] then
        choices['Load'][1](source)
    elseif choices['Eat'] then
        choices['Eat'][1](source)
    elseif choices['Equip'] then 
        choices['Equip'][1](source)
    elseif choices['Take'] then 
        choices['Take'][1](source)
    end
    TriggerEvent('FR:RefreshInventory', source)
end

function FR.LoadAllTask(source, itemName)
  local choices = FR.getItemChoices(itemName)
  choices['LoadAll'][1](source)
  TriggerEvent('FR:RefreshInventory', source)
end

function FR.EquipTask(source, itemName)
  local choices = FR.getItemChoices(itemName)
  choices['Equip'][1](source)
  TriggerEvent('FR:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function FR.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = FR.getUserSource(user_id)

  local data = FR.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = FR.getUserSource(user_id)
        if player ~= nil then
          FRclient.notify(player,{lang.inventory.give.given({FR.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('FR:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = FR.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          FRclient.notify(player,{lang.inventory.missing({FR.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function FR.getInventoryItemAmount(user_id,idname)
  local data = FR.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function FR.getInventoryWeight(user_id)
  local data = FR.getUserDataTable(user_id)
  if data and data.inventory then
    return FR.computeItemsWeight(data.inventory)
  end
  return 0
end

function FR.getInventoryMaxWeight(user_id)
  local data = FR.getUserDataTable(user_id)
  if data.invcap ~= nil then
    return data.invcap
  end
  return 30
end


-- clear connected user inventory
function FR.clearInventory(user_id)
  local data = FR.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end


AddEventHandler("FR:playerJoin", function(user_id,source,name,last_login)
  local data = FR.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


RegisterCommand("storebackpack", function(source, args)
  local source = source
  local user_id = FR.getUserId(source)
  local data = FR.getUserDataTable(user_id)

  FR.getSubscriptions(user_id, function(cb, plushours, plathours)
      if cb then
          local invcap = 30
          if user_id == -1 then
              invcap = 1000
          end
      elseif plathours > 0 then
          invcap = invcap + 20
      elseif plushours > 0 then
          invcap = invcap + 10
      end

      if invcap == 30 then
          FRclient.notify(source, {"You do not have a backpack equipped."})
          return
      end

      if data.invcap - 15 == invcap then
          FR.giveInventoryItem(user_id, "offwhitebag", 1, false)
      elseif data.invcap - 20 == invcap then
          FR.giveInventoryItem(user_id, "guccibag", 1, false)
      elseif data.invcap - 30 == invcap then
          FR.giveInventoryItem(user_id, "nikebag", 1, false)
      elseif data.invcap - 35 == invcap then
          FR.giveInventoryItem(user_id, "huntingbackpack", 1, false)
      elseif data.invcap - 40 == invcap then
          FR.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
      elseif data.invcap - 70 == invcap then
          FR.giveInventoryItem(user_id, "rebelbackpack", 1, false)
      end

      FR.updateInvCap(user_id, invcap)
      FRclient.notify(source, {"~g~Backpack Stored"})
      TriggerClientEvent('FR:removeBackpack', source)
  end)

  if not cb and FR.getInventoryWeight(user_id) + 5 > FR.getInventoryMaxWeight(user_id) then
      FRclient.notify(source, {"You do not have enough room to store your backpack"})
  end
end)
