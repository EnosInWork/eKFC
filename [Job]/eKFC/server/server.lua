local ESX
local societyName = Config.societyName

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'KFC', 'KFC', societyName, societyName, societyName, {type = 'private'})

ESX.RegisterServerCallback('eKFC:getSocietyMoney', function(source, cb, societyName)
	local society = "society_kfc"
		if society then
			TriggerEvent('esx_addonaccount:getSharedAccount', "society_kfc", function(account)
			cb(account.money)
			end)
		else
		cb(0)
	end
end)

RegisterServerEvent("eKFC:retraitentreprise")
AddEventHandler("eKFC:retraitentreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getBank()
	
	TriggerEvent('esx_addonaccount:getSharedAccount', Config.societyName, function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, '<C>Banque Société', '<C>~r~KFC', "<C>~g~Vous avez retiré "..total.." $ de votre entreprise", 'CHAR_BANK_FLEECA', 10)
		else
			TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d\'argent dans votre entreprise!")
		end
	end)
end) 
  
RegisterServerEvent("eKFC:depotentreprise")
AddEventHandler("eKFC:depotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
    
    TriggerEvent('esx_addonaccount:getSharedAccount', Config.societyName, function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
            TriggerClientEvent('esx:showAdvancedNotification', source, '<C>Banque Société', '<C>~r~KFC', "<C>~g~Vous avez déposé "..total.." $ dans votre entreprise", 'CHAR_BANK_FLEECA', 10)
        else
            TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d\'argent !")
        end
    end)   
end)

ESX.RegisterServerCallback('eKFC:livraisonRequire', function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("menulivraison").count >= 1 then
		xPlayer.removeInventoryItem("menulivraison",1)
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('eKFC:GiveCash')
AddEventHandler('eKFC:GiveCash', function(gainsMission, gainsEntreprise)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(gainsMission)
	TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function (account)
		account.addMoney(gainsEntreprise)
	end)
	eLogsDiscord("[GAINS-KFC] **"..xPlayer.getName().."** a fait gagner "..gainsEntreprise.."$ à l'entreprise et à gagner "..gainsMission.. "$ en completant sa mission.", Config.logs.Mission)
end)

RegisterServerEvent('eKFC:recolte')
AddEventHandler('eKFC:recolte', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem(item, 3)
	eLogsDiscord("[Récolte-KFC] **"..xPlayer.getName().."** a récolter x3 "..item, Config.logs.recolte)

end)

RegisterServerEvent('eKFC:deliveryAdd')
AddEventHandler('eKFC:deliveryAdd', function(price, itemNmae)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	
	if Config.DeliveryWithSocietyMoney then 
		TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
			if account then
				if account.money >= price then
					xPlayer.addInventoryItem(itemNmae, 1)
					account.removeMoney(price)
					eLogsDiscord("[Achat-Société-KFC] **"..xPlayer.getName().."** a acheter **"..itemNmae.." pour "..price.."$ avec l'argent de l'entreprise KFC**", Config.logs.shop)
				else
					TriggerClientEvent('esx:showAdvancedNotification', _src, 'KFC', '~r~Erreur', 'Votre entreprise n\'a pas assez d\'argent ~r~!', 'CHAR_PROPERTY_BAR_COCKOTOOS', 9)
				end
			end
		end)
	else
		xPlayer.addInventoryItem(itemNmae, 1)
		xPlayer.removeMoney(price)
		TriggerClientEvent('esx:showNotification', source, "<C>Vous avez retirer un "..itemNmae.." pour "..price.."$")	
	end
end)

RegisterServerEvent('eKFC:createBurger')
AddEventHandler('eKFC:createBurger', function(itemName, ingredients)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.getInventoryItem(ingredients[1].name).count >= ingredients[1].amout and xPlayer.getInventoryItem(ingredients[2].name).count >= ingredients[2].amout and xPlayer.getInventoryItem(ingredients[3].name).count >= ingredients[3].amout and xPlayer.getInventoryItem(ingredients[4].name).count >= ingredients[4].amout then
		TriggerClientEvent('eKFC:animationCreateFood', _src)
		Citizen.Wait(21000)
		for k,v in pairs(ingredients) do
			xPlayer.removeInventoryItem(v.name, v.amout)
		end
		xPlayer.addInventoryItem(itemName, 1)
		eLogsDiscord("[FOUR-KFC] "..xPlayer.getName().." a préparer "..itemName, Config.logs.Preparation)
	else
		TriggerClientEvent('esx:showAdvancedNotification', _src, 'KFC', '~r~Erreur', "Il vous manque de(s) ingrédient(s) ~r~!", 'CHAR_PROPERTY_BAR_COCKOTOOS', 9)
	end
end)

RegisterServerEvent('eKFC:createFrite')
AddEventHandler('eKFC:createFrite', function(itemName, ingredients)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	if xPlayer.getInventoryItem(ingredients[1].name).count >= ingredients[1].amout and xPlayer.getInventoryItem(ingredients[2].name).count >= ingredients[2].amout then
		TriggerClientEvent('eKFC:animationCreateFrite', _src)
		Citizen.Wait(21000)
		for k,v in pairs(ingredients) do
			xPlayer.removeInventoryItem(v.name, v.amout)
		end
		xPlayer.addInventoryItem(itemName, 1)
		eLogsDiscord("[FRITEUSE-KFC] "..xPlayer.getName().." a préparer "..itemName, Config.logs.Preparation)
	else
		TriggerClientEvent('esx:showAdvancedNotification', _src, 'KFC', '~r~Erreur', "Il vous manque de(s) ingrédient(s) ~r~!", 'CHAR_PROPERTY_BAR_COCKOTOOS', 9)
	end
end)


ESX.RegisterServerCallback('eKFC:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', societyName, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('eKFC:getStockItem')
AddEventHandler('eKFC:getStockItem', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)

	TriggerEvent('esx_addoninventory:getSharedInventory', societyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
			eLogsDiscord("[COFFRE-KFC] "..xPlayer.getName().." a retiré "..count.." "..inventoryItem.label.." du coffre", Config.logs.CoffreObjets)
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez retiré ~r~'..inventoryItem.label.." x"..count, 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_PROPERTY_BAR_COCKOTOOS', 9)
		end
	end)
end)

ESX.RegisterServerCallback('eKFC:getPlayerInventory', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('eKFC:putStockItems')
AddEventHandler('eKFC:putStockItems', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', societyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			eLogsDiscord("[COFFRE-KFC] "..xPlayer.getName().." a déposé "..count.." "..inventoryItem.label.." dans le coffre", Config.logs.CoffreObjets)
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', 'Vous avez déposé ~g~'..inventoryItem.label.." x"..count, 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		else
			TriggerClientEvent('esx:showAdvancedNotification', _src, 'Coffre', '~o~Informations~s~', "Quantité ~r~invalide", 'CHAR_PROPERTY_BAR_COCKOTOOS', 9)
		end
	end)
end)

RegisterServerEvent('eKFC:Annonce')
AddEventHandler('eKFC:Annonce', function(open, close, pause, dispolivre, nodispolivre)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if open then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~r~Information', 'Le KFC est désormais ~g~OUVERT~s~', 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		eLogsDiscord("[Annonce-KFC] "..xPlayer.getName().." a annoncé l'ouverture kfc", Config.logs.Annonce)
		elseif close then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~r~Information', 'Le KFC est désormais ~r~FERMER~s~', 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		eLogsDiscord("[Annonce-KFC] "..xPlayer.getName().." a annoncé la fermeture kfc", Config.logs.Annonce)
		elseif pause then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~r~Information', 'Le KFC est désormais en ~o~PAUSE~s~', 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		eLogsDiscord("[Annonce-KFC] "..xPlayer.getName().." a annoncé la pause du kfc", Config.logs.Annonce)
		elseif dispolivre then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~r~Information', 'Un livreur du KFC est désormais disponible en déplacement, Contactez nous par téléphone !', 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		eLogsDiscord("[Annonce-KFC] "..xPlayer.getName().." a annoncé disponible en livraison", Config.logs.Annonce)
		elseif nodispolivre then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~r~Information', 'Les livreurs du KFC ne sont plus disponible en déplacement pour le moment !', 'CHAR_PROPERTY_BAR_COCKOTOOS', 8)
		eLogsDiscord("[Annonce-KFC] "..xPlayer.getName().." a annoncé non disponible en livraison", Config.logs.Annonce)
		end
	end
end)

RegisterCommand('kfc', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == Config.jobName then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '<C>KFC', '<C>~b~Informations', ''..msg..'', 'CHAR_PROPERTY_BAR_COCKOTOOS', 0)
			eLogsDiscord("[Annonce-KFC] **"..xPlayer.getName().."** a fait une annonce perso << "..msg.." >>", Config.logs.Annonce)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'pas' , '~b~EMS pour faire cette commande', 'CHAR_WENDY', 0)
    end
    else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~b~Tu n\'est pas' , '~b~EMS pour faire cette commande', 'CHAR_WENDY', 0)
    end
end, false)

function eLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.logs.NameLogs, content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('eEMS:logsEvent')
AddEventHandler('eEMS:logsEvent', function(message, url)
	eLogsDiscord(message,url)
end)