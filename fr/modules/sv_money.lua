local lang = FR.lang
--Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("FR/money_init_user","INSERT IGNORE INTO fr_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("FR/get_money","SELECT wallet,bank FROM fr_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("FR/set_money","UPDATE fr_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function FR.getMoney(user_id)
  local tmp = FR.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function FR.setMoney(user_id,value)
  local tmp = FR.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = FR.getUserSource(user_id)
  if source ~= nil then
    FRclient.setDivContent(source,{"money",lang.money.display({Comma(FR.getMoney(user_id))})})
    TriggerClientEvent('FR:initMoney', source, FR.getMoney(user_id), FR.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function FR.tryPayment(user_id,amount)
  local money = FR.getMoney(user_id)
  if amount >= 0 and money >= amount then
    FR.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function FR.tryBankPayment(user_id,amount)
  local bank = FR.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    FR.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function FR.giveMoney(user_id,amount)
  local money = FR.getMoney(user_id)
  FR.setMoney(user_id,money+amount)
end

-- get bank money
function FR.getBankMoney(user_id)
  local tmp = FR.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function FR.setBankMoney(user_id,value)
  local tmp = FR.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = FR.getUserSource(user_id)
  if source ~= nil then
    FRclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(FR.getBankMoney(user_id))})})
    TriggerClientEvent('FR:initMoney', source, FR.getMoney(user_id), FR.getBankMoney(user_id))
  end
end

-- give bank money
function FR.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = FR.getBankMoney(user_id)
    FR.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function FR.tryWithdraw(user_id,amount)
  local money = FR.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    FR.setBankMoney(user_id,money-amount)
    FR.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function FR.tryDeposit(user_id,amount)
  if amount > 0 and FR.tryPayment(user_id,amount) then
    FR.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function FR.tryFullPayment(user_id,amount)
  local money = FR.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return FR.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if FR.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return FR.tryPayment(user_id, amount)
    end
  end

  return false
end
function GetProfiles(source)
  local ids = FR.GetPlayerIdentifiers(source)
  local PFPs = {}
  PerformHttpRequest("http://steamcommunity.com/profiles/"..tonumber(ids.steam:gsub("steam:", ""), 16).."/?xml=1", function(err, text, headers)
    local SteamProfileSplitted = stringsplit(text, "\n")
    for i, Line in pairs(SteamProfileSplitted) do
      if Line:match("<avatarFull>") then
        PFPs["Steam"] = Line:gsub("<avatarFull><!%[CDATA%[", ""):gsub("%]%]></avatarFull>", "") or "None"
      end
    end
  end, "GET", "", {["Content-Type"] = 'application/json'})
  PFPs["Discord"] = GetDiscordAvatar(source) or "None"
  PFPs["None"] = "https://cdn.discordapp.com/attachments/1111316733937066055/1161037383232401418/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full-removebg-preview_1.png?ex=6536d753&is=65246253&hm=ab5a7fd4e0f632745aca3b5eea65d06c559162c9901261b393525578c50c8b2a&"
  TriggerClientEvent("FR:setProfilePictures", source, PFPs)
end

local startingCash = 0
local startingBank = 50000000

-- events, init user account if doesn't exist at connection
AddEventHandler("FR:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("FR/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank}, function(affected)
    local tmp = FR.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("FR/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("FR:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = FR.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("FR/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("FR:save", function()
  for k,v in pairs(FR.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("FR/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('FR:giveCashToPlayer')
AddEventHandler('FR:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = FR.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = FR.getUserId(nplayer)
      if nuser_id ~= nil then
        FR.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and FR.tryPayment(user_id,amount) then
            FR.giveMoney(nuser_id,amount)
            FRclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            FRclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            FR.sendWebhook('give-cash', "FR Give Cash Logs", "> Player Name: **"..FR.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..FR.getPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            FRclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        FRclient.notify(source,{lang.common.no_player_near()})
      end
    else
      FRclient.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("FR:takeAmount")
AddEventHandler("FR:takeAmount", function(amount)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.tryFullPayment(user_id,amount) then
      FRclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("FR:bankTransfer")
AddEventHandler("FR:bankTransfer", function(id, amount)
    local source = source
    local user_id = FR.getUserId(source)
    local target_id = tonumber(id)
    local transfer_amount = tonumber(amount)

    if FR.getUserSource(target_id) then
        if FR.tryBankPayment(user_id, transfer_amount) then
            FRclient.notifyPicture(source, {"monzo", "notification", "You have transferred ~g~£"..getMoneyStringFormatted(transfer_amount).."~w~ to ~g~"..FR.getPlayerName(FR.getUserSource(target_id)).."~w~.", "Monzo", "Sent Money"})
            FRclient.notifyPicture(FR.getUserSource(target_id), {"monzo", "notification", "You have received ~g~£"..getMoneyStringFormatted(transfer_amount).."~w~ from ~g~"..FR.getPlayerName(source).."~w~.", "Monzo", "Received Money"})
            TriggerClientEvent("FR:PlaySound", source, "apple")
            TriggerClientEvent("FR:PlaySound", FR.getUserSource(target_id), "apple")
            FR.giveBankMoney(target_id, transfer_amount)
            FR.sendWebhook('bank-transfer', "FR Bank Transfer Logs", "> Player Name: **" .. FR.getPlayerName(source) .. "**\n> Player PermID: **" .. user_id .. "**\n> Target Name: **" .. FR.getPlayerName(FR.getUserSource(target_id)) .. "**\n> Target PermID: **" .. target_id .. "**\n> Amount: **£" .. transfer_amount .. "**")
        else
            FRclient.notifyPicture(source, {"monzo", "notification", "You do not have enough money.", "Monzo", "Error"})
        end
    else
        FRclient.notifyPicture(source, {"monzo", "notification", "Player is not online.", "Monzo", "Error"})
    end
end)


RegisterServerEvent('FR:requestPlayerBankBalance')
AddEventHandler('FR:requestPlayerBankBalance', function()
    local user_id = FR.getUserId(source)
    local bank = FR.getBankMoney(user_id)
    local wallet = FR.getMoney(user_id)
    TriggerClientEvent('FR:setDisplayMoney', source, wallet)
    TriggerClientEvent('FR:setDisplayBankMoney', source, bank)
    TriggerClientEvent('FR:initMoney', source, wallet, bank)
end)

RegisterServerEvent('FR:phonebalance')
AddEventHandler('FR:phonebalance', function()
    local bankM = FR.getBankMoney(user_id)
    TriggerClientEvent('FR:initMoney', source, bankM)
end)

RegisterServerEvent("FR:addbankphone")
AddEventHandler("FR:addbankphone", function(id, amount)
    local source = source
    local user_id = FR.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if FR.getUserSource(id) then
      FR.giveBankMoney(id, amount)
    end
end)

RegisterServerEvent("FR:removebankphone")
AddEventHandler("FR:removebankphone", function(id, amount)
    local source = source
    local user_id = FR.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if FR.getUserSource(id) then
      FR.tryBankPayment(id, amount)
    end
end)