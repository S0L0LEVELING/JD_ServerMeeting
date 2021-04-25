local meetingActive = false
local x, y, z = nil
local isMeeting = true

RegisterCommand('meeting', function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.MeetingPerm) then
		if args[1] ~= nil then
			if isMeeting and args[1] ~= nil then
				if Config.Logs then
					exports.JD_logs:discord(GetPlayerName(source).." just started a meeting.", source, 0, Config.LogsColor, Config.LogsChannel)
				end
				isMeeting = false
				local countdown = args[1]
				while true do
					Citizen.Wait(0)
					if countdown ~= 0 then
						TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "A Server Meeting will ^2^*start^0^r in ^1".. math.floor(tonumber(countdown)) .." seconds^0."}})
						countdown = countdown - 1
						Citizen.Wait(1000)
					else 
						TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "Meeting will ^2^*start^0^r now."}})
						TriggerClientEvent('beginMeeting', -1)
						return
					end
				end
			else
				if Config.Logs then
					exports.JD_logs:discord(GetPlayerName(source).." just started a meeting.", source, 0, Config.LogsColor, Config.LogsChannel)
				end
				isMeeting = true
				local countdown = args[1]
				while true do
					Citizen.Wait(0)
					if countdown ~= 0 then
						TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "The Server Meeting will ^1^*end^0^r in ^1".. math.floor(tonumber(countdown)) .." seconds^0."}})
						countdown = countdown -1
						Citizen.Wait(1000)
					else 
						TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "Meeting will ^1^*end^0^r now."}})
						TriggerClientEvent('endMeeting', -1)
						return
					end
				end
			end
		else
			TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "Please use: ^1/meeting [seconds]^0"}})
		end
	else
		TriggerClientEvent('chat:addMessage', -1, { color = { 255, 0, 0}, multiline = true, args = {"^*^5[JD_Meeting]^0^r", "^1Error: You don't have permission to use this command.^0"}})
	end
end)

RegisterNetEvent('startSyncMeeting')
AddEventHandler('startSyncMeeting', function()
	if IsPlayerAceAllowed(source, Config.AcePerm) then
		TriggerClientEvent('staffMeeting', source)
	end
end)

RegisterNetEvent('endSyncMeeting')
	AddEventHandler('endSyncMeeting', function()
end)

-- version check
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/prefech/JD_ServerMeeting/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1

-------------------------------------------------------
JD_ServerMeeting
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('JD_ServerMeeting unable to check version')
					end
				end,
				'GET'
			)
		end
	end
)