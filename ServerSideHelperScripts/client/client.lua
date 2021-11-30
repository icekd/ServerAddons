TriggerEvent('esx:getShzuluaredObjzuluect', function(obj) ESX = obj end)
RegisterNetEvent('esx_showwealth:moneyRecieve')
AddEventHandler('esx_showwealth:moneyRecieve', function(text, source)
	TriggerEvent('chat:addMessage', {
			color = { 255, 0, 0},
			multiline = true,
			args = {"Me", text}
		})
end)

Citizen.CreateThread(function()
    while true do
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.1) 
	Wait(1)
    end
end)

RegisterNetEvent('esx_showwealth:dojfine')
AddEventHandler('esx_showwealth:dojfine', function()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
			title = 'invoice amount'
		}, function(data, menu)
			local amount = tonumber(data.value)
			print('here')
			if amount == nil or amount < 0 then
				ESX.ShowNotification('amount invalid')
			else
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification('no players nearby')
				else
					menu.close()
					TriggerServerEvent('esx_jktpotp602bmnytpoe40506alk70nmtyporty0396mntohglw:sendBill', GetPlayerServerId(closestPlayer), 'society_doj', 'Department Of Justice Invoice', amount)
					--TriggerServerEvent('esx_bizululling:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
end)


RegisterNetEvent('esx_showwealth:fineRecieve')
AddEventHandler('esx_showwealth:fineRecieve', function(identifier, source)
	local elements = {}

	ESX.TriggerServerCallback('esx_jktpotp602bmnytpoe40506alk70nmtyporty0396mntohglw:getTargetBills2', function(bills)
		local amount = 0
		for i=1, #bills, 1 do
			amount = amount + bills[i].amount 
			table.insert(elements, {
				label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>',
				value = bills[i].id
			})
		end
		table.insert(elements, {
			label = "Fine Sum: " .. ' - <span style="color: red;">$' .. amount .. '</span>',
			value = "Outstanding"
		})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = 'unpaid bills amount: ' .. amount,
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end, identifier)
end)

RegisterNetEvent('esx_showwealth:callRecieve')
AddEventHandler('esx_showwealth:callRecieve', function(msg)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_addons_gcphone:startCall','police', msg, {x = coords.x, y = coords.y, z = coords.z})
	TriggerServerEvent("mdt:newCall", msg, source , coords)
end)

RegisterNetEvent('esx_showwealth:coords')
AddEventHandler('esx_showwealth:coords', function(coords)
			local alpha = 250
			local color = 57
			local val1 = math.random(-100,100)
			local val2 = math.random(-100,100)
			local radius = AddBlipForRadius(coords.x + val1,coords.y + val2,coords.z, 150.0)
			local blip = AddBlipForCoord(coords.x + val1,coords.y + val2,coords.z)
		
			SetBlipSprite(blip, sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.3)
			SetBlipColour(blip, color)
			SetBlipAsShortRange(blip, false)
		
			SetBlipHighDetail(radius, true)
			SetBlipColour(radius, color)
			SetBlipAlpha(radius, alpha)
			SetBlipAsShortRange(radius, true)
			while alpha ~= 0 do
				Citizen.Wait(30*4)
				alpha = alpha - 1
				SetBlipAlpha(radius, alpha)
	
				if alpha == 0 then
					RemoveBlip(radius)
           			RemoveBlip(blip)
					return
				end
			end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
		local vte = 0
        for _, i in ipairs(GetActivePlayers()) do
        local pid = GetBlipFromEntity(GetPlayerPed(i))
            if DoesBlipExist(pid) then
				vte = vte + 1
            end
        end
		if vte >= 2 then
			TriggerServerEvent('esx:updatePEDCoords',{count = vte, coords = PlayerPedId()})
			Citizen.Wait(300000)
		else
			Citizen.Wait(65000)
		end
    end
end)

RegisterCommand('livery', function(source, args, rawCommand)
	local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
  local livery = tonumber(args[1])
  
  SetVehicleLivery(Veh, livery)
  exports['mythic_notify']:DoHudText('success', ('Vehicle Livery Changed'))
end)

RegisterCommand('extra', function(source, args, rawCommand)
	local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
  local extra = tonumber(args[1])

  SetVehicleExtra(Veh, extra)
  exports['mythic_notify']:DoHudText('success', ('Vehicle Extra Added'))
end)
