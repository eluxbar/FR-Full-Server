local a;local b=false;local function c(d,e,f,g)if g==nil then g=function()end end;if a then SendNUIMessage({act="close_prompt"})while a do Wait(0)end end;SendNUIMessage({act="open_prompt",type=f,title=d,text=tostring(e)})SetNuiFocus(true)a=g;b=true end;RegisterNUICallback("prompt",function(h,g)if h.act=="close"then if a then a(h.result)a=nil end end end)function tFR.clientPrompt(d,e,g)c(d,e,"client",g)end;function tFR.prompt(d,e)c(d,e,"server",nil)end;RegisterNUICallback("prompt",function(h,g)if h.act=="close"and b then SetNuiFocus(false)b=false;if h.type~="client"then FRserver.promptResult({h.result})end end end)function tFR.CopyToClipBoard(i)SendNUIMessage({copytoboard=i})end;function tFR.OpenUrl(j)SendNUIMessage({act="openurl",url=j})end;RegisterNUICallback("ClosePrompt",function()if b then SendNUIMessage({act="close_prompt"})SetNuiFocus(false)a=nil;b=false end end)exports("prompt",tFR.clientPrompt)exports("copytoboard",tFR.CopyToClipBoard)exports("playSound",function(k)SendNUIMessage({transactionType=k})end)