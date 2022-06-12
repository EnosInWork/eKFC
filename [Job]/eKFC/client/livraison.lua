
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

local function menuDelivery()
    local main = RageUI.CreateMenu('Livraison', 'KFC')
    local sub_main = RageUI.CreateSubMenu(main, 'Livraison', 'KFC')
    local sub_three = RageUI.CreateSubMenu(main, 'Livraison', 'KFC')
    main:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    sub_main:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    sub_three:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        RageUI.Visible(main, not RageUI.Visible(main))

        while main do

        Citizen.Wait(0)

            RageUI.IsVisible(main, true, true, true, function()

            RageUI.ButtonWithStyle("Nos produit(s)", "Alimentaire requis au fonctionnement du restaurant.", {RightLabel = "~o~Restaurant ~s~→→"}, true, function(Hovered, Active, Selected)
            end, sub_main)
            RageUI.ButtonWithStyle("Nos produit(s)", "Confectionnez votre menu et partez en livraison.", {RightLabel = "~o~Livraison ~s~→→"}, true, function(Hovered, Active, Selected)
            end, sub_three)

            end, function()
            end)

            RageUI.IsVisible(sub_main, true, true, true, function()

            for k,v in pairs(Config.deliveryItems) do
                RageUI.ButtonWithStyle(v.label,nil, {RightLabel = "~o~"..v.prix.."$ Entreprise"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('eKFC:deliveryAdd', v.prix, v.name)
                    end
                end)
            end

            end, function()
            end)

            RageUI.IsVisible(sub_three, true, true, true, function()

                for k,v in pairs(Config.LivraisonItem) do
                    RageUI.ButtonWithStyle(v.label,nil, {RightLabel = "~o~Point GPS"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            SetNewWaypoint(Config.posFarm.x, Config.posFarm.y)
                        end
                    end)
                end

            end, function()
            end)

            if not RageUI.Visible(main) and not RageUI.Visible(sub_main) and not RageUI.Visible(sub_three) then
            main = RMenu:DeleteType(main, true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.livrPos)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
            if dist <= Config.Marker.DrawDistance then
            Timer = 0
            DrawMarker(Config.Marker.Type,  Config.livrPos.x, Config.livrPos.y, Config.livrPos.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
            end
            if dist <= Config.Marker.DrawInteract then
                Timer = 0
                RageUI.Text({ message = "Appuyez sur  ~r~[E]~s~ pour ouvrir → ~r~Livraison", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    menuDelivery()
                end
            end
        end

    Citizen.Wait(Timer)
    end
end)

local PanelChargement = false
local Percentage = 0.0

local function menuRec()
    local menureco = RageUI.CreateMenu("Recolte", "KFC")
    menureco:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    RageUI.Visible(menureco, not RageUI.Visible(menureco))
    while menureco do
        Wait(0)
        RageUI.IsVisible(menureco, true, true, true, function()

            RageUI.ButtonWithStyle("Charger le véhicule", "Véhicule de service requis", {RightLabel = "→→"}, not PanelChargement and IsInAuthorizedVehicle(), function(Hovered,Active,Selected)
                if Selected then 
                    PanelChargement = true
                end
            end)                       

            if PanelChargement == true then
                RageUI.PercentagePanel(Percentage or 0.0, "Chargement ... ("..math.floor(Percentage * 100).."%)", "", "",  function(Hovered, Active, Percent)
                    if Percentage < 1.0 then
                        Percentage = Percentage + 0.004 
                    else 
                        FreezeEntityPosition(PlayerPedId(), true)
                        ESX.ShowNotification("<C>~r~KFC</C>\n~s~Récolte en cours")
                        TriggerServerEvent("eKFC:recolte", "menulivraison")
                        FreezeEntityPosition(PlayerPedId(), false)
                        PanelChargement = false
                        Percentage = 0.0
                    end 
                end) 
            end

            end, function() 
            end)

        if not RageUI.Visible(menureco) then
            menureco = RMenu:DeleteType("menureco", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.posFarm)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
            if dist <= Config.Marker.DrawDistance then
            Timer = 0
            DrawMarker(Config.Marker.Type,  Config.posFarm.x, Config.posFarm.y, Config.posFarm.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
            end
            if dist <= Config.Marker.DrawInteract then
                Timer = 0
                RageUI.Text({ message = "Appuyez sur  ~r~[E]~s~ pour ouvrir → ~r~Chargement", time_display = 1 })
                if IsControlJustPressed(1,51) then
                    menuRec()
                end
            end
        end

    Citizen.Wait(Timer)
    end
end)
