# MADE BY
- Samuel Silva / SamuelGamerPT

# REQUIREMENTS
- redemrp_notification
- redemrp_respawn

#HOW TO USE
- Just use this command in your chat /setjob id ambulance grade

# ADVISES
- Create all the items in your redemrp_inventory/config.lua
Config.Usable = {
badage,
mbandage,
medikit,
}

Config.Labels = {
["bandage"] = Bandage,
["mbandage"] = Medic Bandage,
["medikit"] = MediKit,
}

- To use this script you have to change the redemrp_respawn script. If you wan't you can just copy this and insert in your script

local new_character = 0
local respawned = false
local firstjoin = true
local pressed = false
local rp = false
local count = true

RegisterCommand("kys", function(source, args, rawCommand) -- KILL YOURSELF COMMAND
local _source = source
if Config.kysCommand then
	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
    local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
        Citizen.InvokeNative(0x697157CED63F18D4, ped, 500000, false, true, true)
		else end
end, false)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- DO NOT REMOVE
		local pl = Citizen.InvokeNative(0x217E9DC48139933D)
		while Citizen.InvokeNative(0x2E9C3FCB6798F397, pl) do
			Citizen.Wait(0) -- DO NOT REMOVE
			local timer = GetGameTimer()+Config.RespawnTime
			while timer >= GetGameTimer() do
				if respawned == false then
					Citizen.Wait(0) -- DO NOT REMOVE
					Citizen.InvokeNative(0xFA08722A5EA82DA7, Config.Timecycle)
					Citizen.InvokeNative(0xFDB74C9CC54C3F37, Config.TimecycleStrenght)
					Citizen.InvokeNative(0x405224591DF02025, 0.50, 0.475, 1.0, 0.22, 1, 1, 1, 100, true, true)
					DrawTxt(Config.LocaleDead, 0.50, 0.40, 1.0, 1.0, true, 161, 3, 0, 255, true)
					DrawTxt(Config.LocaleTimer .. " " .. tonumber(string.format("%.0f", (((GetGameTimer() - timer) * -1)/1000))), 0.50, 0.50, 0.7, 0.7, true, 255, 255, 255, 255, true) 
					--print ("PLAYER IS DEAD")
					DisplayHud(false)
					DisplayRadar(false)
					exports.spawnmanager:setAutoSpawn(false) -- disable respawn
				else
					Citizen.InvokeNative(0x0E3F4AF2D63491FB)
					respawned = false
					break
				end
			end
			while not pressed do
				Wait(0)
				DrawTxt(Config.PressRespawn, 0.50, 0.45, 1.0, 1.0, true, 255, 255, 255, 255, true)
				if IsControlJustReleased(0, 0xDFF812F9) then
				pressed = true
				end
			end
			pressed = false
			if rp == false then
				respawn() -- Calling the respawn function here
			end
		end
	end
end)

function respawn()
	SendNUIMessage({
		type = 1,
		showMap = true
	})
	SetNuiFocus(true, true)

	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
	local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
	local coords = GetEntityCoords(ped, false)
	SetEntityCoords(ped, coords.x, coords.y, coords.z - 128.0)
	FreezeEntityPosition(ped, true)
    Citizen.InvokeNative(0x71BC8E838B9C6035, ped)
	Citizen.InvokeNative(0x0E3F4AF2D63491FB)
end

RegisterNetEvent("redemrp_respawn:rev")
AddEventHandler("redemrp_respawn:rev", function()
	rp = true
	pressed = true
	respawned = true
	SendNUIMessage({
		type = 1,
		showMap = false
	})
	SetNuiFocus(false, false)

	local pl = Citizen.InvokeNative(0x217E9DC48139933D)
	local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
	FreezeEntityPosition(ped, false)
    Citizen.InvokeNative(0x71BC8E838B9C6035, ped)
	Wait(0)
	rp = false
	pressed = false
	respawned = false
end)
