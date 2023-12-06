local Tunnel = module("fr", "lib/Tunnel")
local Proxy = module("fr", "lib/Proxy")
local htmlEntities = module("lib/htmlEntities")

FR = Proxy.getInterface("FR")
FRclient = Tunnel.getInterface("FR", "gcphone")

math.randomseed(os.time()) 

function getPhoneRandomNumber()
    return '0' .. math.random(600000000,699999999)
end


--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    return FR.getUserSource({identifier})
end
function getNumberPhone(identifier)
    local result = exports["fr"]:executeSync("SELECT phone FROM fr_user_identities WHERE user_id = @user_id", { user_id = identifier })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = exports["fr"]:executeSync("SELECT user_id FROM fr_user_identities WHERE phone = @phone", { phone = phone_number })
    if result[1] ~= nil then
        return result[1].user_id
    end
    return nil
end


function getPlayerID(source)
    local player = FR.getUserId({source})
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        exports["fr"]:executeSync("UPDATE fr_user_identities SET phone = @phone WHERE user_id = @user_id", { user_id = identifier, phone = myPhoneNumber }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = exports['fr']:executeSync("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier", { ['@identifier'] = identifier })
    return result
end
function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    exports['fr']:executeSync("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier AND phone_users_contacts.number = @number", { ['@identifier'] = identifier, ['@number'] = number }, function (result)
        if result[1] == nil then
            MySQL.Async.insert("INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
                ['@identifier'] = identifier,
                ['@number'] = number,
                ['@display'] = display,
            },function()
                notifyContactChange(sourcePlayer, identifier)
            end)
        end
    end)
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    exports['fr']:executeSync("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier AND phone_users_contacts.number = @number AND phone_users_contacts.id != @id", { ['@identifier'] = identifier, ['@number'] = number, ['@id'] = id }, function (result)
        if result[1] == nil then
            exports['fr']:executeSync("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
                ['@number'] = number,
                ['@display'] = display,
                ['@id'] = id,
            },function()
                notifyContactChange(sourcePlayer, identifier)
            end)
        end
    end)
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    exports['fr']:executeSync("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier AND phone_users_contacts.id = @id", { ['@identifier'] = identifier, ['@id'] = id }, function (result)
        if result[1] ~= nil then
            exports['fr']:executeSync("DELETE FROM phone_users_contacts WHERE id = @id", { id = id }, function ()
                notifyContactChange(sourcePlayer, identifier)
            end)
        end
    end)
end
function deleteAllContact(identifier)
    exports['fr']:executeSync("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", { ['@identifier'] = identifier })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("FR:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('FR:addContact')
AddEventHandler('FR:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('FR:updateContact')
AddEventHandler('FR:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('FR:deleteContact')
AddEventHandler('FR:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = exports['fr']:executeSync("SELECT * FROM phone_messages WHERE phone_messages.receiver = @identifier", { ['@identifier'] = identifier })
    return result
end

RegisterServerEvent('FR:_internalAddMessage')
AddEventHandler('FR:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil and FR.getUserSource({otherIdentifier}) ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        TriggerClientEvent("FR:receiveMessage", tonumber(FR.getUserSource({otherIdentifier})), tomess)
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("FR:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('FR:sendMessage')
AddEventHandler('FR:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('FR:deleteMessage')
AddEventHandler('FR:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('FR:deleteMessageNumber')
AddEventHandler('FR:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("FR:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('FR:deleteAllMessage')
AddEventHandler('FR:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('FR:setReadMessageNumber')
AddEventHandler('FR:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('FR:deleteALL')
AddEventHandler('FR:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("FR:contactList", sourcePlayer, {})
    TriggerClientEvent("FR:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

AddEventHandler('FR:deleteALLFRIdentity', function(src,user_id,num)
    deleteAllMessage(user_id)
    deleteAllContact(user_id)
    appelsDeleteAllHistorique(user_id)
    TriggerClientEvent("FR:contactList", src, {})
    TriggerClientEvent("FR:allMessage", src, {})
    TriggerClientEvent("appelsDeleteAllHistorique", src, {})
    TriggerClientEvent("FR:myPhoneNumber", src, num) -- update phonenumber
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = exports['fr']:executeSync("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('FR:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('FR:getHistoriqueCall')
AddEventHandler('FR:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)


RegisterServerEvent('FR:internal_startCall')
AddEventHandler('FR:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if Config.FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }
    

    if is_valid == true then
        -- getSourceFromIdentifier(destPlayer, function (srcTo)
        if FR.getUserSource({destPlayer}) ~= nil then
            srcTo = tonumber(FR.getUserSource({destPlayer}))

            if srcTo ~= nil then
                AppelsEnCours[indexCall].receiver_src = srcTo
                -- TriggerEvent('FR:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('FR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('FR:waitingCall', srcTo, AppelsEnCours[indexCall], false)
            else
                -- TriggerEvent('FR:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('FR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end
    else
        TriggerEvent('FR:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('FR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end

end)

RegisterServerEvent('FR:startCall')
AddEventHandler('FR:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('FR:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('FR:candidates')
AddEventHandler('FR:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('FR:candidates', to, candidates)
    end
end)


RegisterServerEvent('FR:acceptCall')
AddEventHandler('FR:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('FR:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('FR:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('FR:rejectCall')
AddEventHandler('FR:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('FR:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('FR:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('FR:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('FR:appelsDeleteHistorique')
AddEventHandler('FR:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('FR:appelsDeleteAllHistorique')
AddEventHandler('FR:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)










































--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler("FR:playerSpawn",function(user_id, source, first_spawn)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("FR:myPhoneNumber", sourcePlayer, myPhoneNumber)
        TriggerClientEvent("FR:contactList", sourcePlayer, getContacts(identifier))
        TriggerClientEvent("FR:allMessage", sourcePlayer, getMessages(identifier))
    end)
    local bankM = FR.getBankMoney({user_id})
    TriggerClientEvent('FR:setAccountMoney',source,bankM)
end)

-- Just For reload
RegisterServerEvent('FR:allUpdate')
AddEventHandler('FR:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
    TriggerClientEvent("FR:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("FR:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("FR:allMessage", sourcePlayer, getMessages(identifier))
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = Config.FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('FR:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('FR:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('FR:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('FR:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('FR:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('FR:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('FR:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end