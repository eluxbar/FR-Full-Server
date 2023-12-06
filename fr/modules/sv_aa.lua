RegisterServerEvent('FR:openAAMenu')
AddEventHandler('FR:openAAMenu', function()
    local source = source
    local user_id = FR.getUserId(source)
    if user_id ~= nil and FR.hasPermission(user_id, "aa.menu")then
      FRclient.openAAMenu(source,{})
    end
end)

RegisterServerEvent('FR:setAAMenu')
AddEventHandler('FR:setAAMenu', function(status)
    local source = source
    local user_id = FR.getUserId(source)
end)