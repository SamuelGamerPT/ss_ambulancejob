Citizen.CreateThread(function()
    WarMenu.CreateMenu("pharmacy", "Pharmacy")
    WarMenu.SetSubTitle("pharmacy", "")

    while true do
        Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened("pharmacy") then
            if WarMenu.Button("Bandages") then
                TriggerServerEvent("ss_ambulancejob:giveItem", "bandage") -- Badage to heal yourself
            elseif WarMenu.Button("Medic Bandages") then
                TriggerServerEvent("ss_ambulancejob:giveItem", "mbandage") -- Bandage to heal other players
            elseif WarMenu.Button("MediKit") then
                TriggerServerEvent("ss_ambulancejob:giveItem", "medikit") -- Medikit to revive other players
            end
            WarMenu.Display()
        end

        for k,v in pairs (Config.Pharmacies) do
            if Vdist(playerCoords, v) <= 1.5 then
                TriggerServerEvent("ss_ambulancejob:checkJob", 1)
            end
        end
    end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu("stable", "Stable")
    WarMenu.SetSubTitle("stable", "")

    while true do
        Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened("stable", "Stable") then
            if WarMenu.Button("DocV") then
                RequestModel("wagonDoc01x", true)
                CreateVehicle("wagonDoc01x", -280.47, 828.05, 119.49, 274.21, true, false, false, false)
            end
            WarMenu.Display()
        end

        for k,v in pairs(Config.Stables) do
            if Vdist(playerCoords, v) <= 1.5 then
                TriggerServerEvent("ss_ambulancejob:checkJob", 2)
            end
        end

        for k,v in pairs(Config.Stables2) do
            if IsPedInAnyVehicle(PlayerPedId(), true) then
                if Vdist(playerCoords, v) <= 3.0 then
                    TriggerServerEvent("ss_ambulancejob:checkJob", 3)
                end
            end
        end
    end
end)

RegisterCommand("doc", function()
    RequestModel(GetHashKey("wagonDoc01x"), true)
    CreateVehicle(GetHashKey("wagonDoc01x"), -267.12, 815.72, 118.93, 0, true, false, false, false)
end)

RegisterNetEvent("ss_ambulancejob:getClosestPlayer")
AddEventHandler("ss_ambulancejob:getClosestPlayer", function(source, value)
    local closestPlayer, closestDistance = GetClosestPlayer()
    local _value = value

    if closestPlayer ~= -1 and closestDistance <= 3.0 and _value == 1 then
        TriggerServerEvent("ss_ambulancejob:setHealthS", GetPlayerServerId(closestPlayer))
    elseif closestPlayer ~= -1 and closestDistance <= 3.0 and _value == 2 then
        TriggerServerEvent("ss_ambulancejob:revivePlayer", GetPlayerServerId(closestPlayer))
    else
        TriggerEvent("redemrp_notification:start", "There's any player neraby", 3)
    end
end)

RegisterNetEvent("ss_ambulancejob:openMenu")
AddEventHandler("ss_ambulancejob:openMenu", function()
    TriggerEvent("ambulance:showprompt", "Press [G] to open the pharmacy")

    if IsControlPressed(0, 0x760A9C6F) then
        WarMenu.OpenMenu("pharmacy")
    end
end)

RegisterNetEvent("ss_ambulancejob:openMenu2")
AddEventHandler("ss_ambulancejob:openMenu2", function()
    TriggerEvent("ambulance:showprompt", "Press [G] to open the stable")

    if IsControlPressed(0, 0x760A9C6F) then
        WarMenu.OpenMenu("stable")
    end
end)

RegisterNetEvent("ss_ambulancejob:deleteVehicle")
AddEventHandler("ss_ambulancejob:deleteVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    TriggerEvent("ambulance:showprompt", "Press [ENTER] to store the vehicle")
    
    if IsControlPressed(0, 0xC7B5340A) then
        DeleteVehicle(vehicle)
    end
end)

RegisterNetEvent("ss_ambulancejob:setHealthC")
AddEventHandler("ss_ambulancejob:setHealthC", function()
    local target = PlayerPedId()
    local health = Citizen.InvokeNative(0x36731AC041289BB1, target, 0)
    Citizen.InvokeNative(0xC6258F41D86676E0, target, 0, health + 50)
end)

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterNetEvent("ss_ambulancejob:setPHealth")
AddEventHandler("ss_ambulancejob:setPHealth", function()
    local health = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, health + 10)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Pharmacies) do
        local blip = N_0x554d9d53f696d002(1664425300, v)
        SetBlipSprite(blip, Config.BlipSprite, 1)
        SetBlipScale(blip, Config.BlipScale)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.BlipName)
    end
end)

RegisterNetEvent("ambulance:showprompt")
AddEventHandler("ambulance:showprompt", function(msg)
    SetTextScale(0.5, 0.5)
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end)