
--
local ownedPets = {
    ["bear"] = {
        awaitingHealthReduction = false,
        name = "Bear",
        id = "bear",
        ownedSkills = {
            teleport = true,
        },
    },
}

local disabledAbilities = {
    attack = false,
}


AddEventHandler("FR:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = FR.getUserId(source)
    if first_spawn then
        TriggerClientEvent('FR:buildPetCFG', source, ownedPets, disabledAbilities, petStore)
    end
end)

RegisterServerEvent('FR:receivePetCommand')
AddEventHandler("FR:receivePetCommand", function(id, M, L, zz)
    local source = source
    local user_id = FR.getUserId(source)
    -- check if permid owns this pet
    TriggerClientEvent('FR:receivePetCommand', source, M, L, zz)
end)

RegisterServerEvent('FR:startPetAttack')
AddEventHandler("FR:startPetAttack", function(id, M, Y)
    local source = source
    local user_id = FR.getUserId(source)
    -- check if permid owns this pet and that attacks aren't disabled
    TriggerClientEvent('FR:sendClientRagdollPet', Y, user_id, FR.getPlayerName(source))
    TriggerClientEvent('FR:startPetAttack', source, id)
end)

RegisterCommand('pet', function(source)
    local source = source
    local user_id = FR.getUserId(source)
    if user_id == 1 or user_id == 2 then
        TriggerClientEvent('FR:togglePetMenu', source)
        TriggerServerEvent
    end
end)

if exports('addMessage', function(target, message)
    if not message then
        message = target
        target = -1
    end

    if not target or not message then return end

    TriggerClientEvent('chat:addMessage', target, message)
end)
