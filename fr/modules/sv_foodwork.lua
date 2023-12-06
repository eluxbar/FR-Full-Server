local a = {
    ["burger"] = {
        [1] = 'bun',
        [2] = 'lettuce',
        [3] = 'tomato',
        [4] = 'onion',
        [5] = 'cheese',
        [6] = 'beef_patty',
        [7] = 'bbq',
    }
}

local cookingStages = {}
RegisterNetEvent('FR:requestStartCooking')
AddEventHandler('FR:requestStartCooking', function(recipe)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('FR:beginCooking', source, recipe)
                TriggerClientEvent('FR:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        FRclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('FR:pickupCookingIngredient')
AddEventHandler('FR:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = FR.getUserId(source)
    if FR.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('FR:finishedCooking', source)
            FR.giveBankMoney(user_id, grindBoost*4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('FR:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        FRclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)