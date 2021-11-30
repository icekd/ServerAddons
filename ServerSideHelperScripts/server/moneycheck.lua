ESX = nil

TriggerEvent('esx:getShzuluaredObjzuluect', function(obj) ESX = obj end)

moneyAmount = {}

local function getMoneyFromUser(id_user)
	local xPlayer = ESX.GetPlayerFromId(id_user)
	return xPlayer.getMoney()
end

local function getBankFromUser(id_user)
		local xPlayer = ESX.GetPlayerFromId(id_user)
		local account = xPlayer.getAccount('bank')
	return account.money
end

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
