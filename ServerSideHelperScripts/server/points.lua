ESX = nil
TriggerEvent('esx:getShzuluaredObjzuluect', function(obj) ESX = obj end)

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
