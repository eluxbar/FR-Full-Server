local a=0;local b=0;local c=0;local d=3;proximityIdToString={[1]="Whisper",[2]="Talking",[3]="Shouting"}local e,f=GetActiveScreenResolution()local g={}local h=GetResourceKvpString("fr_custom_pfp")or""g["Custom"]=h;RegisterNetEvent("FR:showHUD")AddEventHandler("FR:showHUD",function(i)showhudUI(i)end)AddEventHandler("pma-voice:setTalkingMode",function(j)d=j;local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,k.rightX*k.resX)end)function updateMoneyUI(l,m,n,o,k,p)SendNUIMessage({updateMoney=true,cash=l,bank=m,redmoney=n,proximity=proximityIdToString[o],topLeftAnchor=k,yAnchor=p})end;function showhudUI(i)SendNUIMessage({showMoney=i})end;RegisterNetEvent("FR:setProfilePictures")AddEventHandler("FR:setProfilePictures",function(q)g=q end)RegisterNetEvent("FR:setDisplayMoney")RegisterNetEvent("FR:setDisplayMoney",function(r)local s=tostring(math.floor(r))a=getMoneyStringFormatted(s)local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,k.rightX*k.resX)end)RegisterNetEvent("FR:setDisplayBankMoney")AddEventHandler("FR:setDisplayBankMoney",function(r)local s=tostring(math.floor(r))b=getMoneyStringFormatted(s)local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,k.rightX*k.resX)end)RegisterNetEvent("FR:setDisplayRedMoney")AddEventHandler("FR:setDisplayRedMoney",function(r)local s=tostring(math.floor(r))c=getMoneyStringFormatted(s)local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,k.rightX*k.resX)end)RegisterNetEvent("FR:initMoney")AddEventHandler("FR:initMoney",function(l,m)local t=tostring(math.floor(l))a=getMoneyStringFormatted(t)local s=tostring(math.floor(m))b=getMoneyStringFormatted(s)local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,k.rightX*k.resX)end)Citizen.CreateThread(function()Wait(4000)while tFR.getUserId()==nil do Wait(100)end;TriggerServerEvent("FR:requestPlayerBankBalance")local u=false;while true do local v,w=GetActiveScreenResolution()if v~=e or w~=f then e,f=GetActiveScreenResolution()cachedMinimapAnchor=GetMinimapAnchor()updateMoneyUI("£"..a,"£"..b,"£"..c,d,cachedMinimapAnchor.rightX*cachedMinimapAnchor.resX)end;if NetworkIsPlayerTalking(PlayerId())then if not u then u=true;SendNUIMessage({moneyTalking=true})end else if u then u=false;SendNUIMessage({moneyTalking=false})end end;Wait(0)end end)RegisterNUICallback("moneyUILoaded",function(x,y)local k=tFR.getCachedMinimapAnchor()updateMoneyUI("£"..tostring(a),"£"..tostring(b),"£"..tostring(c),d,k.rightX*k.resX)end)function tFR.updatePFPType(z)if not tFR.isPlatClub()and not tFR.isPlusClub()then z="Steam"end;if z=="Custom"then SendNUIMessage({setPFP=GetResourceKvpString("fr_custom_pfp")})else SendNUIMessage({setPFP=g[z]})end end;function tFR.updatePFPSize(A)SendNUIMessage({setPFPSize=A})end