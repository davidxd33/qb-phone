local QBCore = exports['qb-core']:GetCoreObject()
hasHackedPhone = false

CreateThread(function()
    QBCore.Functions.LoadModel(Config.ChatSeller)

    local ped = CreatePed(5, 'csb_sol', Config.SellerLocation, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE_UPRIGHT_CLUBHOUSE', 0, true)

    exports['qb-target']:AddTargetModel(Config.ChatSeller, {
        options = {
            {
                type = "client",
                event = "qb-phone:client:openChannelMenu",
                icon = 'fas fa-comment-dots',
                label = 'Purchase Chat Channel',
                targeticon = 'fas fa-comments', 
            },
            {
                type = "client",
                event = "qb-phone:client:openChannelHackedMenu",
                icon = 'fas fa-user-secret',
                label = 'Purchase Secured Channel',
                targeticon = 'fas fa-comments',
                canInteract = function()
                    QBCore.Functions.TriggerCallback('qb-phone:server:hasHackedPhone', function(result)
                        hasHackedPhone = result                     
                    end)
                    Wait(500)

                    return hasHackedPhone
                end
            }
        }, 
        distance = 5.0
    })
end)

RegisterNetEvent('qb-phone:client:openChannelMenu', function() 
    local dialog = exports['qb-input']:ShowInput({
        header = "Purchase Chat Channel",
        submitText = "Purchase Room ($250)",
        info = "Rent your own chat channel. Renews for $15 every tsunami.",
        inputs = {
            {
                text = "Channel Name",
                name = "channel-name", 
                type = "chat-channel-name"
            },
            {
                text = "Passcode (Optional) : Passcode protected rooms will not show up in the public listing.",
                name = "channel-passcode", 
                type = "chat-channel-passcode",
                placeholder = "Leave Blank for Public Access"
            },
        },
    })

    if dialog then
        local roomData = {
            room_owner_name = PhoneData.PlayerData.charinfo.firstname .. " " .. PhoneData.PlayerData.charinfo.lastname
        }

        local allGood = false

        for k,v in pairs(dialog) do
            if k == 'channel-name' then
                roomData.room_name = v

                allGood = true
            end

            if k == 'channel-passcode' then
                roomData.room_pin = v
            end
        end

        if allGood then
            QBCore.Functions.TriggerCallback("qb-phone:server:PurchaseRoom",function(status) 
                if status then
                    TriggerServerEvent("qb-phone:server:CreateRoom", PhoneData.PlayerData.source, roomData)
                end
            end, 250)
        end
    end
end)

RegisterNetEvent('qb-phone:client:openChannelHackedMenu', function() 
    local dialog = exports['qb-input']:ShowInput({
        header = "Purchase Secured Channel",
        submitText = "Purchase Room ($5000)",
        info = "Rent your own chat channel. Renews for $75 every tsunami.",
        inputs = {
            {
                text = "Channel Name",
                name = "channel-name", 
                type = "chat-channel-name"
            },
            {
                text = "Passcode (Optional) : Passcode protected rooms will not show up in the *secured* public listing.",
                name = "channel-passcode", 
                type = "chat-channel-passcode",
                placeholder = "Leave Blank for Public Access"
            },
        },
    })

    if dialog then
        local roomData = {
            room_owner_name = PhoneData.PlayerData.charinfo.firstname .. " " .. PhoneData.PlayerData.charinfo.lastname
        }

        local allGood = false

        for k,v in pairs(dialog) do
            if k == 'channel-name' then
                roomData.room_name = v

                allGood = true
            end

            if k == 'channel-passcode' then
                roomData.room_pin = v
            end
        end

        if allGood then
            QBCore.Functions.TriggerCallback("qb-phone:server:PurchaseRoom",function(status) 
                if status then
                    TriggerServerEvent("qb-phone:server:CreateRoom", PhoneData.PlayerData.source, roomData, true)
                end
            end, 5000)
        end
    end
end)

RegisterNetEvent('qb-phone:client:TriggerPhoneHack', function(src)
    QBCore.Functions.Progressbar("hack_gate", "Plugging in the usb...", math.random(5000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "missheistdockssetup1clipboard@base",
        anim = "base",
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)

        local hack = exports['cd_terminalhacker']:StartTerminalHacking()
        if hack.success then
            TriggerServerEvent("QBCore:Server:RemoveItem", "phone_dongle", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["phone_dongle"], "remove")
            TriggerServerEvent('qb-phone:server:HackPhone', PhoneData.PlayerData.source)
        else
            QBCore.Functions.Notify("You have failed to hack your phone.", PhoneData.PlayerData.source, "error")
            TriggerServerEvent("QBCore:Server:RemoveItem", "phone_dongle", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["phone_dongle"], "remove")
        end
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 1.0)
    end)
end)