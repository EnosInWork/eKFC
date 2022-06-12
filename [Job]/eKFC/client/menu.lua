local ESX, isInJobPizz, nbMission, isToHouse, isToPizzaria, multiplicateur, cash, px, py, pz, position, inLivre = nil, false, 0, false, false, 0.5, 0, 0, 0, 0, Config.position, false

Citizen.CreateThread(function()
    TriggerEvent('esx:getSharedObject', function(lib) ESX = lib end)
    while ESX == nil do Citizen.Wait(100) end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
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
    local blipBurgerShot = AddBlipForCoord(Config.posBlips)
    SetBlipSprite(blipBurgerShot, 590)
    SetBlipColour(blipBurgerShot, 1)
    SetBlipScale(blipBurgerShot, 0.80)
    SetBlipAsShortRange(blipBurgerShot, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("KFC")
    EndTextCommandSetBlipName(blipBurgerShot)
end)

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

MenuDeOuf = {
    action = {
        'Ouvert',
        'Fermer',
        'Pause',
        'Dispo livraison',
        'N-D livraison',
        'Personnalisée',
    }, list = 1
}

local function MenuInterac()
    local main_kfc = RageUI.CreateMenu('KFC', '~r~Intéractions KFC')
    local ano_kfc = RageUI.CreateSubMenu(main_kfc, 'KFC', '~r~Intéractions KFC')
    main_kfc:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    ano_kfc:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        RageUI.Visible(main_kfc, not RageUI.Visible(main_kfc))
        while main_kfc do
        Citizen.Wait(0)
        RageUI.IsVisible(main_kfc, true, true, true, function()

            RageUI.Separator("~o~↓ Intéractions ↓")

            RageUI.ButtonWithStyle("Annonces",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
            end, ano_kfc)

            RageUI.ButtonWithStyle("Facture",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                local player, distance = ESX.Game.GetClosestPlayer()
                if Selected then
                    local raison = ""
                    local montant = 0
                    AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0)
                        Wait(0)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then
                            raison = result
                            result = nil
                            AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                result = GetOnscreenKeyboardResult()
                                if result then
                                    montant = result
                                    result = nil
                                    if player ~= -1 and distance <= 3.0 then
                                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_kfc', ('kfc'), montant)
                                        TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                    else
                                        ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            if IsInAuthorizedVehicle() then 
                RageUI.ButtonWithStyle("Commencer les livraisons",nil, {RightLabel = "→→"}, not inLivre and not cooldown, function(Hovered, Active, Selected)
                    if Selected then
                        inLivre = true
                        StartMission()
                    end
                end)
            else
                RageUI.ButtonWithStyle("Commencer les livraisons", "~o~Vous devez être dans un véhicule de service", {RightLabel = ""}, false, function(Hovered, Active, Selected)
                end)
            end

            if inLivre then 
                RageUI.ButtonWithStyle("Arrêter les livraisons",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                    if Selected then
                        inLivre = false
                        StopMission()
                    end
                end)
            end

        end, function() 
        end)


        RageUI.IsVisible(ano_kfc, true, true, true, function()

            RageUI.List('Vos annonces', MenuDeOuf.action, MenuDeOuf.list, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                if (Selected) then
                    if Index == 1 then
                   TriggerServerEvent('eKFC:Annonce', true, false, false, false, false)
                    coolcoolmec(35000)
                    elseif Index == 2 then
                    TriggerServerEvent('eKFC:Annonce', false, true, false, false, false)
                    coolcoolmec(35000)
                    elseif Index == 3 then
                    TriggerServerEvent('eKFC:Annonce', false, false, true, false, false)
                    coolcoolmec(35000)
                    elseif Index == 4 then
                    TriggerServerEvent('eKFC:Annonce', false, false, false, true, false)
                    coolcoolmec(35000)
                    elseif Index == 5 then
                    TriggerServerEvent('eKFC:Annonce', false, false, false, false, true)
                    coolcoolmec(35000)
                    elseif Index == 6 then
                    local anomsg = KeyboardInput("Votre annonce", "", 100)
                    ExecuteCommand("kfc "..anomsg)
                    coolcoolmec(35000)
                    end
                    Wait(5)
                end
                MenuDeOuf.list = Index;
            end)

        end, function() 
        end)

        if not RageUI.Visible(main_kfc) and not RageUI.Visible(ano_kfc) then
            main_kfc = RMenu:DeleteType(main_kfc, true)
        end
    end
end

Keys.Register('F6', 'KFC', 'Ouvrir le menu KFC', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
    	MenuInterac()
	end
end)

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.ListVeh, 1 do
		if vehModel == GetHashKey(Config.ListVeh[i].model) then
			return true
		end
	end
	
	return false
end

function StartBliper(position,nbMission)
	Blip = AddBlipForCoord(position[nbMission].x, position[nbMission].y, position[nbMission].z)
	SetBlipSprite(Blip, 1)
    SetBlipColour(Blip, 2)
	SetBlipRoute(Blip, true)
end

Citizen.CreateThread(function()
	while true do
		local wait = 800

		if isToHouse == true then
            wait = 0
			destinol = position[nbMission].name
            DrawMarker(6, position[nbMission].x,position[nbMission].y,position[nbMission].z, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
			if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(GetPlayerPed(-1),true)) < 3 then
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour donner la commande", time_display = 1 })
				if IsControlJustPressed(1,38) then
                    ESX.TriggerServerCallback('eKFC:livraisonRequire', function(item)
                        if item then	
                            local tempTime = 5 * 1000 / 2
                            FreezeEntityPosition(playerPed, true)
                            startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
                            Citizen.Wait(tempTime)
                            ClearPedTasks(PlayerPedId())
                            startAnim("mp_common", "givetake1_a")
                            Citizen.Wait(tempTime)
                            ClearPedTasks(PlayerPedId())
                            gainsMission = Config.gainsMission
                            gainsEntreprise = Config.gainsMissionEntreprise
                            RageUI.Popup({ message = "Vous avez gagner "..gainsMission.."$", time_display = 4000 })
                            TriggerServerEvent("eKFC:GiveCash", gainsMission, gainsEntreprise)
                            FreezeEntityPosition(playerPed, false)
                            ClearPedTasks(PlayerPedId())

                            isToHouse = true
                            nbMission = math.random(1, 13)
                            px = position[nbMission].x
                            py = position[nbMission].y
                            pz = position[nbMission].z
                            distance = round(GetDistanceBetweenCoords(Config.Garage.x, Config.Garage.y, Config.Garage.z, px,py,pz))
                            cash = distance * multiplicateur
                            RemoveBlip(Blip)
                            StartBliper(position,nbMission)
                        else
                            ESX.ShowNotification("<C>[~r~KFC~s~]\n~r~Vous n'avez pas le menu pour le client.")
                        end
                    end)
                end
            end
        end

		if IsEntityDead(GetPlayerPed(-1)) then
            wait = 0
            isInJobPizz = false
            nbMission = 0
            isToHouse = false
            isToPizzaria = false
            cash = 0
            px = 0
            py = 0
			pz = 0
		end
        Citizen.Wait(wait)
	end
end)

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function StopMission()
    RemoveBlip(Blip)
    isInJobPizz = false
    nbMission = 0
    isToHouse = false
    isToPizzaria = false
    cash = 0
    px = 0
    py = 0
    pz = 0
end

function StartMission()
    ESX.ShowNotification("<C>[~r~KFC~s~]\n~b~N'oubliez pas que vous avez besoin du menu de livraison pour livrer.")
    isInJobPizz = true
    isToHouse = true
    nbMission = math.random(1, 13)
    px = position[nbMission].x
    py = position[nbMission].y
    pz = position[nbMission].z
    distance = round(GetDistanceBetweenCoords(Config.Garage.x, Config.Garage.y, Config.Garage.z, px,py,pz))
    cash = distance * multiplicateur
    StartBliper(position,nbMission)
    isToPizzaria = true
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.ListVeh, 1 do
		if vehModel == GetHashKey(Config.ListVeh[i].model) then
			return true
		end
	end
	
	return false
end

function coolcoolmec(time)
    cooldown = true
    Citizen.SetTimeout(time,function()
        cooldown = false
    end)
end