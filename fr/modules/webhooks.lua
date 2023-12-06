local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1133594860935446561/uqivVeUPQVVsJ3zfPzkJHesVP62rspEOtruDlZhgJPhehdkrgwKYqleqfNAnpPvWAU5R',
    ['leave'] = 'https://discord.com/api/webhooks/1133594891771990117/ad-vIE-ZL9k_Q79sIg94GWjPh0NiHi65Jwk1_x0rcpC572M7ErVKPz9JYC8f1D9HWM6P',
    ['steam'] = 'https://discord.com/api/webhooks/1164767073931640902/s-v7YW3-kqHQ3KB9HZWhqixnGz-qerq6B-cCUpGiP1ZrMpH-8pUK1fnSzZik3snIZw-G',
    -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1133595055387590808/SyGKVwRl-YHWrFkw73w6fUKBwsBP_sD3BOogy1mF5gQoo_IOz9gPuiSM4lv_1YNdeWTe', 
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1133595082264674465/JKu5zfnE95KRRt7KgXZ8bmlcRox4Zf9q9MhBfTwV7c-e9EUhhL6qoFnSiUQ19u_NWx6W', 
    ['search-player'] = 'https://discord.com/api/webhooks/1133595114585997453/c7E84k_3Mbh6sK-SYetOlm1rqlT8Dv0ntgRIJ-OBqYvafakm6NIC5KbSXW3XF0DbgfR1', 
    ['gang'] = 'https://discord.com/api/webhooks/1133595151420371075/9QueaLTE29NfDYs7FKMOpKVR4bzhsh11sC6GmIn_wKdgKeljY1kf46nOV7OYiBD_33Ha',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1133595180746932264/RfgxZYTFZdmOLISXLDHoMWL0X9hpkcyzfMToxz0W3ESaMpGRjJdwJGtUxWoh2c2oHviU', 
    ['twitter'] = 'https://discord.com/api/webhooks/1133595230789177434/xKSgkRb7cuCcaY4kN12qTmoWzPQfuuGTR67AZb8lXycs0oRsdfmJYV1Fr2Xc1yoQgI8w', 
    ['staff'] = 'https://discord.com/api/webhooks/1133595293632450580/T1NHz0-Lk1jEebPXFbeLfBY8_psY8boO0JqLNoYU66e-7stW6y8pbooujAuz4Ob3Rzel',
    ['gang'] = 'https://discord.com/api/webhooks/1133595456497258586/b9nzAlGNpXZGE0fYeKrPjiCotEgI-6LeNgwBAuB1NQSJmZ0JVEqGARtjXajKk8tWic9w',
    ['anon'] = 'https://discord.com/api/webhooks/1133595481138798593/HLZzUQuRc_bp97pCjn9AvBz0JX8T4Dl9KOshwB4PMvhlgztxCINlGilZmzc8jjiDnO8Y', 
    ['announce'] = 'https://discord.com/api/webhooks/1133595521173430413/g2knvmOl8ITLJRsb2xbvBbfbksoI5Dcy61LHo2rs15iliUlSmWkjVMMv4AZfQMOPJJfB',
    -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1133595549585657906/BRhjqlqgjZpTRQXy8iVZIgJ-dHsfxo1rzomZC_cN7Ce0dp7KNK3t-u_Bvpi9n1SBc_2y', 
    ['ban-player'] = 'https://discord.com/api/webhooks/1133595668909412392/NdS5veJfeNso0iFDV6CEAQJT6s484hX0r96p8W4LbDYpefMJVHkt3QyLU-p0_ivTt2Qc', 
    ['spectate'] = 'https://discord.com/api/webhooks/1133596005170941953/gEMExtPVR6ytjiM2RwRVhpWkqnWDTX-ktDAIzHS36HZN6pfB30ykY9cKkHj8KYUfJg3z', 
    ['revive'] = 'https://discord.com/api/webhooks/1133596035709673496/9oVKBjgpSxMzMZZN9y7XZnI_3lRyZyVq3Sj4wfVj4u_hIMM6sZyWADViN1GAkFjAmg30', 
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1133596059239723018/fU_kiUmB9Igyk6wiSxkNnmRYUh_a-fCM6CMH6D1qfQECrg9J28nYskFr0uqDNg2BP-lN', 
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1133596083629592696/_NIqyF2e8gg_Zjc6jKdz_QOx19Wuwavw_Rgu3XnvYUML2jRsygIHVphqCP3vImv-5aBA', 
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1133596147370438697/iI_olHXRBkNF_3SB5-yRmgQMYvlIgA5ZMwHSsya9bL_QrZuPRBJOFzJ83L9T5F7-kHp6', 
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1133596178412486698/AaY8yGDcQavhqx98_583XUtq3CgXx3GNkULbqtl4W4McIFSxXaquC95j74v3EDgMbeaH', 
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1133596208091377764/UiUglfezojubLXvXOSsN9sekN-TVMa9oUKjpIvxHrK3h0YZVvUFt4mebYNsMIRErbxhj', 
    ['freeze'] = 'https://discord.com/api/webhooks/1133596238193901628/3bmVsgHXA4YeTnFUgwmG3j05YEM208mG2tCCUKGQTuyRBPLbc5BvrPY6GMz-ARC0W-oa', 
    ['slap'] = 'https://discord.com/api/webhooks/1133596427109539860/41yN2QU3VeUEzL1UGTOSb0yk6CWkwrHvsF0PBfTaMXxxsTpAXRgMkv-DiSjGoD9QDqFh', 
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1133596392468783214/KZwTHuWjSLW8iylFApfsa57-9Cq_ccP9IaTVigf6X6EkqYOfeITEdUNhwOF8bFHO_UiO', 
    ['screenshot'] = 'https://discord.com/api/webhooks/1133596457551794206/c6p4kBy4kwWxbldg9Azyr1wKM4x4imJYSGnCxlGwudEF1zK7e7HN7BI2XVjt31d4TIZB', 
    ['video'] = 'https://discord.com/api/webhooks/1133596483594227742/oJUqr-g9VhncpnJOO_HOYuYhLFLPDcYJbKo8Dj4Hp1LPRH4trMdLHKPv393W-rYlfH6M', 
    ['group'] = 'https://discord.com/api/webhooks/1133596519942070292/vfSK27_ivaM8GxpINV4NBD6ec0-iUUMLSid4KApAKimWXA2Rv_vO6-fDYH8B6_1e2Dd7', 
    ['unban-player'] = 'https://discord.com/api/webhooks/1133596801455378584/q8oVjd1lvgx8ICpKKmWvt9jR5VsvfFH8abEXYcTRtNdyP7j8VpTwNRashkW_ojKjMIMn', 
    ['remove-warning'] = 'https://discord.com/api/webhooks/1133740365262897232/YFmVXS3QJyoKkLpLUr-50DugA-VsO7_audLXItlUculVfbZPZVXKlOXHae3geXVnwFW1', 
    ['add-car'] = 'https://discord.com/api/webhooks/1133740420782882816/7IyH85wJpha1duY4QuvRbN5vKnFd0-rJFjaB387Dfq3G8TRahepFSapRc8GLr1RpTmqq', 
    ['manage-balance'] = 'https://discord.com/api/webhooks/1133740484834107524/6a1nc4_gQeGvnAB-za9pWXJIYukmWV5GHMM6c-ghXBMvpPFUlziROG0NQl0LYNmCV7na', 
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1133740532301049938/HZ9K0EwpjbgLDq4kNTMDQ0w119VhGxeiMyumT-tYkOejSaQpGGxfJhivljGxFFguyupW',
    ['com-pot'] = 'https://discord.com/api/webhooks/1133740578899759145/LaZ__51ZeRFTfK1LxTcoKJuEoSYSUsLF57BlkoXnhUdy_6mSDs_x8cdpMxL6uIr3dQAw',
    ['staffdm'] = 'https://discord.com/api/webhooks/1159951315644977203/AtsqvY_abEnLYb54KzqZTd2kA7GNQG74X55spMtFL-YSqHGQ-Dvpuxh4nc8CzzY7aq03',
    -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1133740637875867751/zEuxBuNFlmOdtPqd-xYN0tLOdbug5V-CpovTBBuSb5LN23xXJ-wnOxK3xb5nkLd3tkdi', 
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1133740685862907904/3HCydu3cPI4VjX62kCUj_angM7R3C4Z8MO9uII3eIt4uCNIRbHjX6UcCeFH37bEsOt7J', 
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1133740743396176003/SVC5_yzxMKyBq80nsxmWoqvK9samWCEcrOz0hOPO9Ce0t0ZbVu9KK7wFLnuBEEJWeZ0h',
    ['spawn-vehicle'] = 'https://discord.com/api/webhooks/1172913659635302470/E4w5GMvOfU3Aa0C8qAms53CzlOcvA_BVt0HqmLZzT9KW4yjXBS5QpJfNACaa-6_LlMKj',
    -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1130163973258477640/2uB_me4pHUo98i_4sPA9lE65qGsIRENqDa2zVHfQiXEEpc4aJXhSX7Uk3dsEn5VrOGnZ',
    ['pd-afk'] = 'https://discord.com/api/webhooks/1130163923128156160/qwncXuQOHS9q2OJUbcpXYqo_AiSOVUUN8blKQhMwGW6BL_zDHRMPyOig_tf6cIn70S0J',
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1130163824268411001/rJmx-PXs6uUnlfxkZV4Lc93rWKqn0z19kopQiARcYedLV30Gl5BnLXDWtfVukopSO_DT',
    ['fine-player'] = 'https://discord.com/api/webhooks/1130163740466225182/Cte7utuPfFBBIiIJaM2-IPbhojx56h84fP6ekzxHmCyWt33cRtPlUlF5T_HMTGetozSY',
    ['jail-player'] = 'https://discord.com/api/webhooks/1130163740466225182/Cte7utuPfFBBIiIJaM2-IPbhojx56h84fP6ekzxHmCyWt33cRtPlUlF5T_HMTGetozSY',
    ['pd-panic'] = 'https://discord.com/api/webhooks/1130164190439555102/Q6yT37dMDiZm7YmiqaAyRDKwppNgtt2ydlBPjZyLqjPYKiTEkdYuXf4OQk5kHNphlQ9h',
    ['seize-boot'] = 'https://discord.com/api/webhooks/1130163868853878824/Jf6LgQPNIWhaSLdPT1Jlz9MdHLvUXQth7663EAaXjVuV5NyBG6NVvVGgAZwkq4UrOX7U',
    ['impound'] = 'https://discord.com/api/webhooks/1130164141919830066/NaGBup_ZJEEz9DOGSSYJxRtBBGLTQ0_liWQyW7YUslUXPVWZKEXuRKh6fLd5e-OH-uwS',
    ['police-k9'] = 'https://discord.com/api/webhooks/1127973898479222876/KshzXMCksQJdfZxKMCgSodzHR19-J18RrDUfnKpen-NZsMyLzNjw2KtaMwjo8LVBSVCX',
    -- nhs
    ['nhs-clock'] = 'https://discord.com/api/webhooks/1127973941332410460/oCBhmr1hf7q-TSmJRvgFDmmZBSr0Cshi4EhEbCgKo8WYl7ZRa1VULwnZ4H1sEKsvFLwb',
    ['nhs-panic'] = 'https://discord.com/api/webhooks/1127973980536573963/UbzslTqEHhlVpnBaGPZiHc2Wjo_pTKW1pisrtVY8lp8qTk8dRPmjBwfdiE7VxJ76oP8N',
    ['nhs-afk'] = 'https://discord.com/api/webhooks/1127974023855362129/ztilmwOGrwYCuoVvLFDxSDLYej_mfYBLtbxGFaZFBTKFrMuplDa0iTGDBLAcGq4qi7mp',
    ['cpr'] = 'https://discord.com/api/webhooks/1127974068604375251/HaLR8qdmaKyEHpvHJ2CM6ql5wJMJ4eWO-I0J9w7_9jC8Je9lysQPR-upIX2I5FhTa7kF',
    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1133740827705888900/hQp7lyPgXMjqtWeMO6yb9bDdHLHRQuOndgOHMLEGS8l6nFwbgsiDixq6pj-wlLUtKkZp', 
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1133740885046198293/CdBkFHUZFfiyHlrlfoszswJeGFR_q0U5CXhHvMoOV_nKrvRdP6Mv83Y4QD78z6KabyOF', 
    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1133740941409255454/pHf6ZFq0GVhcR2odyg8FPryklgV67dWZEci6KgoMl54PWETROcFpGiv1pcvhuA4lPlLH',  
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1173381245644845206/kBc9OV6tFhqhWSsyb5cQlsZp1McjcjpoMPk88bOMtB9WIlnc26-_8-h2e7CZzlzsIHMF',  
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1133741069926940762/VyqwTA4zVmmHstFbYK6BaqWp6CUvTHEhBigKGNbYFu6AwB6Qqjy3mLKA0OfPzPg8Kq7b',  
    ['sell-chips'] = 'https://discord.com/api/webhooks/1133741123513356389/Lash4IhzDZV2vNMBg6F6H26B6j6EPx7aw9sRIKZ5LvyF_eU1QlHsPeknfwbH9DxwpzQU',  
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1133741189691093082/Ib2CtthXqKseNhMuvvPw5lbEAiCk1vjWJtbkBbcurC66NdrD-9PEec84Jw37Lb2LOyem',  
    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1133741299481182238/5rGrQnanz3nAkLaNhqNLjg8XY0lAdZhus8G_JMgYYwTBYY4Oc10PtDCYP0G2hoiyzHxz',  
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/1133741403739013201/8qZjgyaFmBjOPzc8PPnW2qngdK5bgJMXeiEuEHGi_osHTcJStWGEAkAezkR3_lkDGrcT', 
    ['tp-to-wp'] = 'https://discord.com/api/webhooks/1140341546160504873/SKI0Rvq1zek7eNQkG02ac9HG7ana6q8k-klXAOYCicaDeYgnccbpnDMPv2A0dejr7nMz', 
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1133741464006955048/7_-3V0ccWfenBBLFL-cuhgKnQ1BO5RP0EqQ646lhVixsyjY9bu0COYnpCY7NpZwI9jBR',
    ['multi-account'] = 'https://discord.com/api/webhooks/1133741507803885618/Qx3XB3wCs-ZfWFPh3sqfn4xVJ4a39A469ikk-x2rx0spMf6Gz73mMv11DSUXkbeCU_3l', 
    -- dono
    ['donation'] = 'https://discord.com/api/webhooks/1133741350341333073/nG_BMu7wKhzPnYRBl02roqfjwjbmxOlGhEKxdcGG52kDNzP6fxfuzzb1cHwxZBVEdfKy', 
    -- general
    ['banned-player'] = 'https://discord.com/api/webhooks/1138524301486727259/9wE0WV286U8-AHqpMrkWPEgHCGtwVVNrcoM9kQEwO93RHt_wldbJagyDLVVdtEet4MaF',
    ['tutorial'] = 'https://discord.com/api/webhooks/1133741580407287828/wSZzMaONO9W0z84tv9Lpn_9OQmX5OT5f45ryi5RjnFJrl18MP9Bctz0MUCr__EvLBmGT', 
    ['killvideo'] = "https://discord.com/api/webhooks/1133594927687798915/R_BDIorpmfRfwgop9F52vWe4nd5jidLhgdWUXTl15AJgLu3-_wfcyy3f1fRSwn46nf02",
    ['feedback'] = 'https://discord.com/api/webhooks/1133741643091165265/g-JLqT5cIA9OS2w0SvfCzseYyH5Cy1vZhBj5oq65TSM-QSnjmQsPrdCTjzcV5TUKytFl',
    ['kills'] = 'https://discord.com/api/webhooks/1133594927687798915/R_BDIorpmfRfwgop9F52vWe4nd5jidLhgdWUXTl15AJgLu3-_wfcyy3f1fRSwn46nf02',
    ['damage'] = 'https://discord.com/api/webhooks/1133594959925219378/hhowXm0YY7tjBUo9hlInSzSEd1ybIVynHD5N8zhRVSQGdbpx3xWj13a1UfwA380PzE-M',
    -- store
    ['store-sell'] = 'https://discord.com/api/webhooks/1143229362322292826/nYsMCbHkn4Lo7gp4o-HRzQdlIZquCX-FzceWcq56rH9a2o3ikCcJylF6MNX0_Bm_drDI', 
    ['store-redeem'] = 'https://discord.com/api/webhooks/1143229309960605767/Y0CrSZsp8IsLIrys1a_Ok6680eQwhQMcEiKpX0qAXBfsn_5P93vlUim980hHyCE3wVzr',
    ['store-unban'] = 'https://discord.com/api/webhooks/1145143051086471318/vBE3t2tj9EEQvnsWTZex5dkd_Hjy-8GDIZW5IZqi4yJNj3efXf7Jc2BhZn7voL_NyiM6',
    ['tebex'] = 'https://discord.com/api/webhooks/1173671026572398613/A_RUwhIYnGVsTj635oSJMK74F8GzzKUD-oi0vtGJlYAczD1WpdW4N6-GoyZFtkakdvwY',
    ['trigger-bot'] = 'https://discord.com/api/webhooks/1165138978085806171/rRqfjY9GYUIRN97sPb4kC_kf-mzz0uoDhtcERgH9HZrJT4TLU_Kbsoncl22cUBvZi85N',
    ['headshot'] = 'https://discord.com/api/webhooks/1166209238528442470/zZGXZT-huuuQ1b9ZeuzEy5NTSVplHKyOFoDrLnHeeoTJax7wAYpTx4hctgNMIkzNd_1T',
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "FR Logs", avatar_url = 'https://cdn.discordapp.com/attachments/1111316733937066055/1146051245048598639/PFP.png', embeds = {
                        {
                            ["color"] = 0xFF0000,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "FR - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function FR.sendWebhook(webhook, name, message)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function FR.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end