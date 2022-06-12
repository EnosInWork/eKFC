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

local function Keyboard(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local function menuCoffre()
    local menuCoffreP = RageUI.CreateMenu("Coffre", "~r~KFC")
    menuCoffreP:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

        RageUI.Visible(menuCoffreP, not RageUI.Visible(menuCoffreP))
            while menuCoffreP do
            Citizen.Wait(0)
            RageUI.IsVisible(menuCoffreP, true, true, true, function()

                RageUI.Separator("~o~↓ Objet(s) ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            menuCoffreRetirer()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            menuCoffreDeposer()
                        end
                    end)
                end)
            if not RageUI.Visible(menuCoffreP) then
            menuCoffreP = RMenu:DeleteType("menuCoffreP", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.coffrePos)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.jobName then
        if dist <= Config.Marker.DrawDistance then
         Timer = 0
         DrawMarker(Config.Marker.Type,  Config.coffrePos.x, Config.coffrePos.y, Config.coffrePos.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.H)
        end
         if dist <= Config.Marker.DrawInteract then
            Timer = 0
                RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour ouvrir → ~r~Frigidaire", time_display = 1 })
            if IsControlJustPressed(1,51) then
                menuCoffre()
            end
         end
        end
    Citizen.Wait(Timer)
 end
end)


local itemstock = {}
function menuCoffreRetirer()
    local menuCoffre = RageUI.CreateMenu("Coffre", "~r~KFC")
    menuCoffre:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    ESX.TriggerServerCallback('eKFC:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(menuCoffre, not RageUI.Visible(menuCoffre))
        while menuCoffre do
            Citizen.Wait(0)
                RageUI.IsVisible(menuCoffre, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = Keyboard("Combien ?", "", 2)
                                    TriggerServerEvent('eKFC:getStockItem', v.name, tonumber(count))
                                    RageUI.CloseAll()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(menuCoffre) then
            menuCoffre = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end


function menuCoffreDeposer()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Voici votre ~y~inventaire")
    StockPlayer:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)

    ESX.TriggerServerCallback('eKFC:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                    RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = Keyboard("Combien ?", '' , 8)
                                            TriggerServerEvent('eKFC:putStockItems', item.name, tonumber(count))
                                            RageUI.CloseAll()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end
