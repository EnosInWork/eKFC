local ESX = nil
local KFCMoney = nil

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

local function menuBoss()
    local menuBossP = RageUI.CreateMenu("Actions Patron", "~r~KFC")
    menuBossP:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    RageUI.Visible(menuBossP, not RageUI.Visible(menuBossP))
    while menuBossP do
        Wait(0)
        RageUI.IsVisible(menuBossP, true, true, true, function()

            if KFCMoney ~= nil then
                RageUI.Separator("~b~Argent de société : ~s~"..KFCMoney.."$")
            end

            RageUI.Separator("")

            RageUI.ButtonWithStyle("Retirer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~KFC~b~]\n~r~Montant invalide"})
                    else
                        TriggerServerEvent("eKFC:retraitentreprise", amount)
                        refreshMoney()
                        coolcoolmec(3500)
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "<C>~b~[~b~Entreprise ~s~: ~r~KFC~b~]\n~r~Montant invalide"})
                    else
                        TriggerServerEvent("eKFC:depotentreprise", amount)
                        refreshMoney()
                        coolcoolmec(3500)
                    end
                end
            end) 

           RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('esx_society:openBossMenu', 'kfc', function(data, menu)
                        menu.close()
                    end, {wash = false})
                    RageUI.CloseAll()
                end
            end)
        end)
        
        if not RageUI.Visible(menuBossP) then
            menuBossP = RMenu:DeleteType("menuBossP", true)
        end
    end
end

function refreshMoney()
	ESX.TriggerServerCallback('eKFC:getSocietyMoney', function(money)
		UpMoneyKFC(money)
	end)
end

function UpMoneyKFC(money)
    KFCMoney = ESX.Math.GroupDigits(money)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.posMenuBoss)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName and ESX.PlayerData.job.grade_name == 'boss' then
        if dist <= Config.Marker.DrawDistance then
         Timer = 0
         DrawMarker(Config.Marker.Type,  Config.posMenuBoss.x, Config.posMenuBoss.y, Config.posMenuBoss.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
        end
         if dist <= Config.Marker.DrawInteract then
            Timer = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir → ~r~Actions patron", time_display = 1 })
            if IsControlJustPressed(1,51) then
                refreshMoney()
                menuBoss()
            end
         end
        end
    Citizen.Wait(Timer)
 end
end)