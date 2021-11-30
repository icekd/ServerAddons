ESX = nil
local canBuy = false
local canSell = false
TriggerEvent('esx:getShzuluaredObjzuluect', function(obj) ESX = obj end)

function getIdentity(idnetifier)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
	  local identity = result[1]
  
	  return {
		identifier = identity['identifier'],
		firstname = identity['firstname'],
		lastname = identity['lastname'],
		dateofbirth = identity['dateofbirth'],
		sex = identity['sex'],
		height = identity['height'],
		phone_number = identity['phone_number']
		
	  }
	else
	  return nil
	end
  end

Citizen.CreateThread(function ()
	
	while true do
		Citizen.Wait(2000)
		local curDate = os.date("*t", os.time())
		local hours = curDate.hour
		local minutes = curDate.min
		--print(hours)
		--print(minutes)
		if hours == 11 or hours == 16 or hours == 1 then
			if minutes == 30 or minutes == 45 or minutes == 50 or minutes == 55 or minutes == 58 then
				minutes = 60 - minutes
				local text = "Server Tsunami in " .. minutes .. " minutes, be prepared!"
				if minutes < 12 then
					text = "Server Tsunami in " .. minutes .. " minutes, be prepared, make sure to save your vehicles and finish any jobs!"
				end
				TriggerClientEvent('chatMessage', -1, "^8^*" .. "!" .. "^0^r ", {30, 144, 255},text)
				TriggerClientEvent('chatMessage', -1, "^8^*" .. "!" .. "^0^r ", {30, 144, 255},text)
				if minutes == 2 then
					ESX.SavePlayers()
					Citizen.Wait(45000)
					ESX.SavePlayers()
					Citizen.Wait(35000)
					ESX.SavePlayers()
				end
				Citizen.Wait(60000 * 2)
			else
				Citizen.Wait(4000)
			end
		end
	end
end)

local function getMoneyFromUser(id_user)
	local xPlayer = ESX.GetPlayerFromId(id_user)
	return xPlayer.getMoney()
end

local function getBankFromUser(id_user)
		local xPlayer = ESX.GetPlayerFromId(id_user)
		local account = xPlayer.getAccount('bank')
	return account.money

end

ESX.RegisterUsableItem('radio', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('Radio.Set', source, true)
	TriggerClientEvent('Radio.Toggle', source)

end)

local function sendToDiscordHookPlate(plate,playername,source)
	local val = GetPlayerIdentifier(source,0)
	local disconnect = {
        {
            ["color"] = "7663411",
            ["title"] = "Illegal Parking/Abandoned Vehicle Ticket" ,
            ["description"] = "Officer SS Number: " .. val .."-".. playername .. " Plate: " .. plate,
   		}
   }
    PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({username = "Clock In Log", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end

local function sendToDiscordHook(plate,playername,source,affectedRows)
	local val = GetPlayerIdentifier(source,0)
	local disconnect = {
        {
            ["color"] = "8663751",
            ["title"] = "Player Has Deleted a car!!!" .. affectedRows,
            ["description"] =  plate .. " deleted by " .. playername .. ":" .. val,
        }
    }
    PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({username = "Clock In Log", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('wealth', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = tonumber(args[1])
	local yPlayer = ESX.GetPlayerFromId(a)
	if yPlayer ~= nil then
		local wallet = getMoneyFromUser(a)
		local bank = getBankFromUser(a)
		if xPlayer.job.name == 'police' or xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
			local text = 'Person has $' .. wallet .. ' in wallet and $' .. bank .. ' in bank'
			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
		end
	else
		local text = 'Player is not on the server!'
	    TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
	end
end)

RegisterCommand("hose", function(source, args)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' then
    	TriggerClientEvent("Client:HoseCommand", source, true)
	end
end)

RegisterCommand("dojbill", function(source, args)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'doj' then
    	TriggerClientEvent('esx_showwealth:dojfine', source)
	end
end)

RegisterNetEvent('esx_showwealth:updateAttach')
AddEventHandler('esx_showwealth:updateAttach', function(hash)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local identi = xPlayer.getIdentifier()
	MySQL.Sync.execute("UPDATE disc_ammo SET attach = @newval WHERE owner = @identi AND hash = @hash", {['@newval'] = '[]', ['@identi'] = identi,['@hash'] = hash})
end)

RegisterCommand('realestatebuy', function(source, args)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = tonumber(args[1])
	local yPlayer = ESX.GetPlayerFromId(a)
	if yPlayer ~= nil then
		local wallet = getMoneyFromUser(a)
		local bank = getBankFromUser(a)
		if xPlayer.job.name == 'realestate' then
			canBuy = not canBuy
			local text = ''
			if canBuy then
				 text = 'Buying is now: ' .. 'True'
			else
				 text = 'Buying is now: ' .. 'False'
			end
			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
			TriggerClientEvent('esx_showwealth:enable', a)
		end
	else
		local text = 'Player is not on the server!'
	    TriggerClientEvent('esx_showwealth:moneyRecieve', source, text)
	end
end)


RegisterCommand('realestatesell', function(source, args)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = tonumber(args[1])
	local yPlayer = ESX.GetPlayerFromId(a)
	if yPlayer ~= nil then
		local wallet = getMoneyFromUser(a)
		local bank = getBankFromUser(a)
		if xPlayer.job.name == 'realestate' then
			canSell = not canSell
			local text = ''
			if canSell then
				 text = 'Selling is now: ' .. 'True'
			else
				 text = 'Selling is now: ' .. 'False'
			end
			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
			TriggerClientEvent('esx_showwealth:enablesell', a)
		end
	else
		local text = 'Player is not on the server!'
	    TriggerClientEvent('esx_showwealth:moneyRecieve', source, text)
	end
end)

     -- print(' this far')
	 RegisterNetEvent('esx_showwealth:hcheck')
AddEventHandler('esx_showwealth:hcheck', function(source, owner)
	 local char = owner:sub(1, 1)
	 local s = string.gsub(owner, char .. ":", "Char" ..char .. ":")
	 MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier=@identifier', {
			   ['@identifier'] = s
		   },function(affectedRows)
			if affectedRows[1] ~= nil then
					Wait(5000) 
		  --TriggerClientEvent('chatMessage', source, "[SYNTAX]", {255, 0, 0}, )
		  TriggerClientEvent('esx_showwealth:moneyRecieve', source, 'This House belongs to ' .. affectedRows[1].firstname .. ' ' .. affectedRows[1].lastname, source)
			   else
	   s2 = string.gsub(owner, char .. ":", "steam:")
	  MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier=@identifier', {
		['@identifier'] = s2
	  },function(affectedRow2)
	   print(affectedRow2)
		if affectedRow2[1] ~= nil then
		   Wait(5000) 
		   TriggerClientEvent('esx_showwealth:moneyRecieve', source, 'This House belongs to ' .. affectedRow2[1].firstname .. ' ' .. affectedRow2[1].lastname, source)
		else
		  local text = 'Not a valid House!'
		  TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
		end
	  end)
	   end
end)
end)

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

RegisterCommand('fineinfo', function(source, args)
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
					local text = affectedRows[1].identifier
					TriggerClientEvent('esx_showwealth:fineRecieve', source, text, source)
				else
					local text = 'Not a valid entry!'
					TriggerClientEvent('esx_showwealth:fineRecieve', source, text, source)
				end
			end)
		end
	end
end)


RegisterCommand('911', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local msg = rawCommand:sub(4)
	--local name = getIdentity(source)
	local amount = xPlayer.getInventoryItem('apple_iphone').count

	if msg == "" then
		return
	end
	if amount > 0 then
		TriggerClientEvent("esx:showNotification", source, "You have placed a call to 911, the closest unit is on its way!")
		TriggerClientEvent("esx_showwealth:callRecieve", source, msg)
	else
		TriggerClientEvent("esx:showNotification", source, "You need a Phone to /911, Buy one from the Legion Phone Store!")
        TriggerClientEvent('notification', source, 'You Need a Phone from the Legion Square Phone Store!', 2)
	end
end)

RegisterCommand('rmveh', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = args[1]
	if a ~= "" and string.len(a) >= 2 and string.len(a) <= 8 then
		if IsPlayerAceAllowed(source,"easyadmin.ban") then
			--print("here")
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = a
			},function(affectedRows)
				print(affectedRows)
				if affectedRows ~= 0 then
					local text = 'Car with Plate ' .. a .. ' Removed!!!'
	    			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
					sendToDiscordHook(a,xPlayer.getName(),source,affectedRows)
				else
					local text = '(ERROR) Something Went Wrong, Make sure you typed in the plate correctly!'
	    			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				end
			end)
		end
	else
		local text = 'Not a valid entry!'
	    TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
	end
end)

RegisterCommand('citation', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = args[1]
	if xPlayer.job.name == 'police' then
		if a ~= "" and string.len(a) >= 2 and string.len(a) <= 8 then
				--print(a)
				MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
					['@plate'] = a
				},function(affectedRows)
					if affectedRows ~= 0 then
						local val = GetPlayerIdentifier(source,0)
						local val2 = affectedRows[1].owner
						--print(val2)
						MySQL.Sync.execute("INSERT INTO billing (identifier,sender,target_type,target,label,amount) VALUES (@owner,@sender,@society,@target,@label,@amount)", {['@owner'] = val2, ['@sender'] = val,['@society'] = 'society',['@target'] = 'society_police',['@label'] = 'Fine: Illegal Parking',['@amount'] = '1000' })

						local text = 'YOU HAVE GIVEN A PARKING TICKET TO THE OWNER OF THIS CAR!, ' .. ' PLATE: ' .. a
						TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
						sendToDiscordHookPlate(a,xPlayer.getName(),source)
					else
						local text = 'Not a valid entry!'
						TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
					end
				end)
			end
		
	else
		local text = 'You are not a meter maid!'
		TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
	end
end)


RegisterCommand('jailtime', function(source, args)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = tonumber(args[1])
	local yPlayer = ESX.GetPlayerFromId(a)
	if yPlayer ~= nil then
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'doc' or xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
			MySQL.Async.fetchAll('SELECT firstname,lastname,jail FROM users WHERE identifier = @identifier', {
				['@identifier'] = GetPlayerIdentifier(a,0)
			},function(affectedRows)
				if affectedRows[1] ~= nil then
					local text = "CITIZEN: " .. affectedRows[1].firstname .. " " .. affectedRows[1].lastname .. " has " .. affectedRows[1].jail .. " months left in jail."
					TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				else
					local text = 'Not in Server!'
					TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				end
			end)
		end
	else
		local text = 'Player is not on the server!'
		TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
	end
end)


RegisterCommand('dnacode', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local a = args[1]
	if a ~= "" and (xPlayer.job.name == 'fbi' or (xPlayer.job.name == 'police' and xPlayer.job.grade >= 4)) then
			--print("here")
			MySQL.Async.fetchAll('SELECT first, lastname, dob, sex FROM dnadatabase WHERE dnacode = @dnacode', {
				['@dnacode'] = a
			},function(affectedRows)
				if affectedRows[1] ~= nil then
					local text = '[QUERY SUCCESSFUL] ID: ^3' .. a ..  '^0 NAME: ^2' .. affectedRows[1].first .. " " .. affectedRows[1].lastname .. "^0 DOB: ^2" .. affectedRows[1].dob .. '^0 SEX: ^2' .. affectedRows[1].sex
	    			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				else
					local text = '^1(ERROR)^0 No one matching this DNA sequence is registered in the Federal CODIS Database!'
	    			TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				end
			end)
		end
end)

RegisterCommand('checkpoints', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local a = args[1]
	local yPlayer = ESX.GetPlayerFromId(a)
	local identifier = yPlayer.getIdentifier()
	local name = yPlayer.getName()
    --/checkpoints 31
	if xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
			--print("here")
			MySQL.Async.fetchAll('SELECT points FROM pointDB WHERE identifier = @identifier', {
				['@identifier'] = identifier
			},function(affectedRows)
				if affectedRows[1] ~= nil then
					-- RETURN POINTS SOMEONE HAS
					--local text = '[QUERY SUCCESSFUL] ID: ^3' .. a ..  '^0 NAME: ^2' .. affectedRows[1].first .. " " .. affectedRows[1].lastname .. "^0 DOB: ^2" .. affectedRows[1].dob .. '^0 SEX: ^2' .. affectedRows[1].sex
	    			--TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				else
					--MySQL.Sync.execute("INSERT INTO billing (identifier,sender,target_type,target,label,amount) VALUES (@owner,@sender,@society,@target,@label,@amount)", {['@owner'] = val2, ['@sender'] = val,['@society'] = 'society',['@target'] = 'society_police',['@label'] = 'Fine: Illegal Parking',['@amount'] = '1000' })
					--MySQL.Sync.execute("UPDATE disc_ammo SET attach = @newval WHERE owner = @identi AND hash = @hash", {['@newval'] = '[]', ['@identi'] = identi,['@hash'] = hash})
					-- IF USER NOT FOUND CREATE ENTRY IN DATABASE
					--local text = '^1(ERROR)^0 No one matching this DNA sequence is registered in the Federal CODIS Database!'
	    			--TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
				end
			end)
		end
end)


--Check how many points a user has accumulated   /checkpoints 31   --> Player `Name` has x amount of points

-- Update Player points  /updatepoints 265 1[1 or 5 or 10] -- UPDATE current and adds to it 
-- If playerpoints was 10 now it will say Player `Name` now has x amount of points
-- deal with condition if not in system update their points , repeat this  Player `Name` now has x amount of points

-- Update Player points /setpoints 265 ANYVALUE -- UPDATE current and adds to it 
-- similar to add except for superadmin and above


deathArray = {}

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source
	deathArray[data.victim] = data
end)


ESX.RegisterUsableItem('hacksaw', function(source)
	TriggerClientEvent('esx_showwealth:hacksaw', source)
end)

ESX.RegisterServerCallback('esx_showwealth:checkorgans', function(src, cb, param1)
	if deathArray[param1] then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source
	deathArray[data.victim] = data
end)

jobTable ={}

jobTable['police'] = true
jobTable['ambulance'] = true
jobTable['fbi'] = true
jobTable['mechanic'] = true
jobTable['offmechanic'] = true
jobTable['offambulance'] = true
jobTable['offpolice'] = true


RegisterServerEvent('esx:updatePEDCoords')
AddEventHandler('esx:updatePEDCoords', function(blipsToUpdate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if jobTable[xPlayer.job.name] ~= nil or IsPlayerAceAllowed(source,"easyadmin.ban") then
		-- Do Nothing
	else
		if blipsToUpdate.count >= 2 then
			--local text = 'TEST!'
			--TriggerClientEvent('esx_showwealth:moneyRecieve', source, text, source)
			TriggerEvent('EasyAdmin:addBan2',_source, 'Hacking Violation - CB53' .. blipsToUpdate.count ,false,false)
		end
	end
end)

moneyAmount = {}

Citizen.CreateThread(function ()
	-- while true do
	-- 	Citizen.Wait(60000)
	-- 	local xPlayers = ESX.GetPlayers()
	-- 	local identifier = nil
	-- 	for i=1, #xPlayers, 1 do
	-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 		local money = getMoneyFromUser(xPlayers[i])
	-- 		local bank = getBankFromUser(xPlayers[i])
	-- 		local identi = xPlayer.getIdentifier()

	-- 		if moneyAmount[xPlayers[i]] ~= nil then
	-- 			local oldBank = moneyAmount[xPlayers[i]].bank
	-- 			local oldMoney =  moneyAmount[xPlayers[i]].money
	-- 			local moneyDiff = money - oldMoney
	-- 			local bankDiff = bank - oldBank
	-- 			if (bankDiff) >= 50000 or (moneyDiff) >= 50000 then
	-- 				local aPlayers = ESX.GetPlayers()
	-- 				for i=1, #aPlayers, 1 do
	-- 					local aPlayer = ESX.GetPlayerFromId(aPlayers[i])
	-- 					if bankDiff >= 250000 then

	-- 					end

					
	-- 					if aPlayer.getGroup() == 'superadmin' or aPlayer.getGroup() == 'mod' then
	-- 						if (bankDiff) >= 50000 then

	-- 							TriggerClientEvent('chat:addMessage', , { 
	-- 								template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(253, 53, 53, 0.6); border-radius: 5px;"><i class="fas fa-user-crown"></i> {0} </div>',
	-- 								args = { "^3!!Money Check!!^7 \n", xPlayer.getName() .. '-ID: ' .. xPlayers[i] .. ' BANK: OLD[' .. oldBank ..'] -> NEW['.. bank ..']' .. 'DIFF: ' .. bankDiff  }
	-- 								color = { 255, 255, 255 }, 
	-- 							})

	-- 						else
	-- 							if oldMoney + 5000 >= bankDiff then

	-- 							else
	-- 								TriggerClientEvent('chat:addMessage', , { 
	-- 									template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(253, 53, 53, 0.6); border-radius: 5px;"><i class="fas fa-user-crown"></i> {0} </div>',
	-- 									args = { "^3!!Money Check!!^7 \n", xPlayer.getName() .. '-ID: ' .. xPlayers[i] .. ' CASH: OLD[' .. oldMoney ..'] -> NEW['.. money ..']' .. 'DIFF: ' .. moneyDiff }
	-- 									color = { 255, 255, 255 }, 
	-- 								})
	-- 							end
	-- 						end
	-- 					end
	-- 				end
	-- 			end

	-- 			moneyAmount[xPlayers[i]] = {bank = bank, money = money}
	-- 		else
	-- 			moneyAmount[xPlayers[i]] = {bank = bank, money = money}
	-- 		end
	-- 	end

	-- end
end)

ESX.RegisterServerCallback('esx_showwealth:getPoints', function(src, cb, param1)
	local _source = src
    --local xPlayer = ESX.GetPlayerFromId(param1)
    local a = GetPlayerIdentifier(param1,0)
	--print(type(a))
	if a ~= ""  then
			--print("here")
			MySQL.Async.fetchAll('SELECT identifier, points, lastOffense FROM pointsdb WHERE identifier=@id', {['@id'] = a},function(affectedRows)
				if affectedRows[1] ~= nil then
					cb(affectedRows[1])
				else
					--os.date('%Y-%m-%d %H:%M:%S')
					MySQL.Sync.execute("INSERT INTO pointsdb (identifier, points, lastOffense) VALUES (@identifier, @points, @lastOffense)", {['@identifier'] = a, ['@points'] = 0,['@lastOffense'] = 'NONE'})
					defaultTable = {}
					defaultTable.identifier = a
					defaultTable.points = 0
					defaultTable.lastOffense = 'NONE'
					cb(defaultTable)
				end
			end)
		end
end)

local function sendToDiscordHookPoints(xPlayer,yPlayer,rval,points,info)
	local val = GetPlayerIdentifier(source,0)
	local disconnect = {
        {
            ["color"] = "7563411",
            ["title"] = rval .. ' points! out of ' .. points,
            ["description"] = xPlayer.getName() .. '-' .. xPlayer.getIdentifier() .. '\n\n **recieved points for** ' .. info .. '\n\n Given by: \n\n' .. yPlayer.getName() ..'-'.. xPlayer.getIdentifier(),
   		}
   }
    PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({username = "Point System", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('esx_showwealth:updatePoints')
AddEventHandler('esx_showwealth:updatePoints', function( playerID, points, rval, info)
	--print(source)
	local _source = source
	--print(playerID)
--	print(points)
	--print(info)
	local xPlayer = ESX.GetPlayerFromId(playerID)
	local yPlayer = ESX.GetPlayerFromId(_source)
	sendToDiscordHookPoints(xPlayer,yPlayer,rval,points + rval,info)
	local date = tostring(os.date('%Y-%m-%d %H:%M:%S'))
	local lastOffense = 'PTS['..rval..']-'.. date  ..' '.. info 
	--print(lastOffense)

	MySQL.Sync.execute("UPDATE pointsDB SET points = @points, lastOffense = @lastOffense WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier(), ['@points'] = points + rval,['@lastOffense'] = lastOffense})
	TriggerClientEvent('esx:showNotification', playerID, 'You have recieved a ~r~warning of ' .. rval .. ' points ~w~for ' .. info, 2)
	TriggerClientEvent('esx:showNotification', _source, 'You have given out a warning of ~g~'.. rval .. ' points!', 2)
	TriggerClientEvent('esx:showNotification', playerID, 'READ THE RULES! THEY EXIST TO HELP YOU. /help for FAQ & RULES', 2)
end)

--CREATE TABLE pointsDB (
	-- identifier VARCHAR(20),
   -- points INT(11),
    --lastOffense VARCHAR(50),
    --PRIMARY KEY (identifier)
--);


