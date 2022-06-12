local ESX = nil

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(lib) ESX = lib end)
    while ESX == nil do Citizen.Wait(100) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.DeleteVeh)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
			if dist <= Config.Marker.DrawDistance then
			Timer = 0
			DrawMarker(Config.Marker.Type, Config.DeleteVeh, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
			end
			if dist <= Config.Marker.DrawInteract then
				Timer = 0
					RageUI.Text({ message = "Appuyez sur  ~r~[E]~s~ pour ranger votre véhicule", time_display = 1 })
				if IsControlJustPressed(1,51) then
					local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
						if dist4 < 5 then
							DeleteEntity(veh)
							ESX.ShowNotification("<C>~g~Véhicule ranger avec succès")
						end 
            		end
         		end
        	end
		end
    	Citizen.Wait(Timer)
 	end
end)

function OpenGarage()
	local garageanim = RageUI.CreateMenu("Garage", "~r~KFC")
	garageanim:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

	RageUI.Visible(garageanim, not RageUI.Visible(garageanim))
		while garageanim do
		Citizen.Wait(0)
		RageUI.IsVisible(garageanim, true, true, true, function()

		RageUI.Separator("↓ ~o~Véhicule(s) disponible~s~ ↓")

			for k,v in pairs(Config.ListVeh) do
					RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected)
					if (Selected) then
					Citizen.Wait(1)  
					SpawnCar(v.model)
					coolcoolmec(3500)
					RageUI.CloseAll()
					end
				end)
			end 
            
		end, function() 
		end)

		if not RageUI.Visible(garageanim) then
			garageanim = RMenu:DeleteType(garageanim, true)
		end
	end
end

function SpawnCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.SpawnVeh, Config.SpawnHeading, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.Garage)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
				if dist <= Config.Marker.DrawDistance then
				Timer = 0
				DrawMarker(Config.Marker.Type, Config.Garage, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
				end
				if dist <= Config.Marker.DrawInteract then
					Timer = 0
					RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir →→ ~r~Garage", time_display = 1 })
					if IsControlJustPressed(1,51) then
						OpenGarage()
					end
				end
			end
		Citizen.Wait(Timer)
	end
end)