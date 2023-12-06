local cfg=module("cfg/cfg_groupselector")

function FR.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = FR.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if FR.hasPermission(FR.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if FR.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("FR:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("FR:getJobSelectors")
AddEventHandler("FR:getJobSelectors",function()
    local source = source
    FR.getJobSelectors(source)
end)

function FR.removeAllJobs(user_id)
    local source = FR.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and FR.hasGroup(user_id, v[1]) then
                FR.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and FR.hasGroup(user_id, v[1]..' Clocked') then
                FR.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                FRclient.setArmour(source, {0})
                TriggerEvent('FR:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    FRclient.setPolice(source, {false})
    TriggerClientEvent('FR:globalOnPoliceDuty', source, false)
    FRclient.setNHS(source, {false})
    TriggerClientEvent('FR:globalOnNHSDuty', source, false)
    FRclient.setHMP(source, {false})
    TriggerClientEvent('FR:globalOnPrisonDuty', source, false)
    FRclient.setLFB(source, {false})
    FR.updateCurrentPlayerInfo()
    TriggerClientEvent('FR:disableFactionBlips', source)
    TriggerClientEvent('FR:radiosClearAll', source)
    TriggerClientEvent('FR:toggleTacoJob', source, false)
end

RegisterNetEvent("FR:jobSelector")
AddEventHandler("FR:jobSelector",function(a,b)
    local source = source
    local user_id = FR.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("FR:acBan", user_id, 11, FR.getPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        FR.removeAllJobs(user_id)
        FRclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if FR.hasGroup(user_id, b) then
                FR.removeAllJobs(user_id)
                FR.addUserGroup(user_id,b..' Clocked')
                FRclient.setPolice(source, {true})
                TriggerClientEvent('FR:globalOnPoliceDuty', source, true)
                FRclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                FR.sendWebhook('pd-clock', 'FR Police Clock On Logs',"> Officer Name: **"..FR.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                FRclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if FR.hasGroup(user_id, b) then
                FR.removeAllJobs(user_id)
                FR.addUserGroup(user_id,b..' Clocked')
                FRclient.setNHS(source, {true})
                TriggerClientEvent('FR:globalOnNHSDuty', source, true)
                FRclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                FR.sendWebhook('nhs-clock', 'FR NHS Clock On Logs',"> Medic Name: **"..FR.getPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                FRclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if FR.hasGroup(user_id, b) then
                FR.removeAllJobs(user_id)
                FR.addUserGroup(user_id,b..' Clocked')
                FRclient.setLFB(source, {true})
                FRclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                FR.sendWebhook('lfb-clock', 'FR LFB Clock On Logs',"> Firefighter Name: **"..FR.getPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                FRclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if FR.hasGroup(user_id, b) then
                FR.removeAllJobs(user_id)
                FR.addUserGroup(user_id,b..' Clocked')
                FRclient.setHMP(source, {true})
                TriggerClientEvent('FR:globalOnPrisonDuty', source, true)
                FRclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                FR.sendWebhook('hmp-clock', 'FR HMP Clock On Logs',"> Prison Officer Name: **"..FR.getPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                FRclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        else
            FR.removeAllJobs(user_id)
            FR.addUserGroup(user_id,b)
            FRclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('FR:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('FR:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('FR:clockedOnCreateRadio', source)
        TriggerClientEvent('FR:radiosClearAll', source)
        TriggerClientEvent('FR:refreshGunStorePermissions', source)
        FR.updateCurrentPlayerInfo()
    end
end)