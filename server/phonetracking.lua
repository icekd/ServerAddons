ESX = nil
TriggerEvent('esx:getShzuluaredObjzuluect', function(obj) ESX = obj end)

-- /trace 555-5555
-- A Phone Tracker Program that tracks a player if they have a phone item
RegisterCommand('trace', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	--print("here")
	local a = args[1]
	--print(a)
    
	if a ~= "" and string.len(a) >= 2 and string.len(a) <= 10 then
		if xPlayer.job.name == 'fbi' then
			MySQL.Async.fetchAll('SELECT identifier,firstname,lastname,phone_number FROM users WHERE phone_number = @phone_number', {
				['@phone_number'] = a
			},function(affectedRows)
				if affectedRows[1] ~= nil then
					local str = affectedRows[1].identifier
					local  val = string.sub(str, 7)
					local ide = "steam:" .. val
					--print(affectedRows[1].identifier)
					--print(val)
					local xPlayers = ESX.GetPlayers()
					local found = 0
					local resultPlayer = nil
					local identifier = nil
					for i=1, #xPlayers, 1 do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						local identi = xPlayer.getIdentifier()
						if identi == ide then
							found = 1
							resultPlayer = xPlayer
							identifier = identi
							break
						end
					end
					
					if found == 0 then
						
						local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
						TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
						Citizen.Wait(2000)
						text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^1NO SIGNAL" 
						TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
					else

						local val = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {['@identifier'] = identifier})
						--print(val[1].phone_number)
							--print("here")
							--print("here")
							if val[1].phone_number == affectedRows[1].phone_number then
								local amount = resultPlayer.getInventoryItem('apple_iphone').count
								if amount > 0 then
									local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
									TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
									Citizen.Wait(2000)
									text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^2GOOD SIGNAL" 
									TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
									Citizen.Wait(2000)
									Citizen.CreateThread(function()
										local count = 0
										while count < 10 do
											amount = resultPlayer.getInventoryItem('apple_iphone').count
											if amount > 0 then
												local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
												TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
												Citizen.Wait(2000)
												text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^2GOOD SIGNAL" 
												TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
												local value = resultPlayer.getCoords(useVector)
												TriggerClientEvent('esx_showwealth:coords', source, value)
												--TriggerClientEvent('esx_outlawalert:gunshotInProgress', source, value)
												
											else
												local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
												TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
												Citizen.Wait(2000)
												text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^3WEAK SIGNAL, CLOSE TRACKER APP" 
												TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
												count = 10
												break
											end
											
											count = count + 1
											Citizen.Wait(30000)
										end
										TriggerClientEvent('esx_showwealth:moneyRecieve', source, '^1PROGRAM ENDED DUE TO SIGNAL LOSS, RESTART IF YOU ARE STILL TRACKING', source)
									end)
									
								else
									local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
									TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
									Citizen.Wait(2000)
									text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^3WEAK SIGNAL, TRACE NOT POSSIBLE" 
									TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
								end
							else
								local text = "CELLULAR DATA MDT: Pinging ... Phone: " .. a
								TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
								Citizen.Wait(2000)
								text = "PING RESULT FOR PHONE NUMBER " .. a .. " STATUS: ^1NO SIGNAL" 
								TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
							end
						end
					
					--affectedRows[1].identifier
					--TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)

					--sendToDiscordHookPlate(a,xPlayer.getName(),source)
				else
					local text = 'Not a valid number!'
					TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				end
			end)
		end
	else
		local text = 'Not a valid entry!'
	    TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
	end
end)
