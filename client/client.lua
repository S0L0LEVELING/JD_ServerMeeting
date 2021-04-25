local a, b, c = nil
local x, y, z = table.unpack(Config.SpawnPoint)
local x2, y2, z2 = table.unpack(Config.StaffSpawnPoint)
local allowed = false
local meetingRunning = false

print(table.unpack(Config.SpawnPoint))
print(table.unpack(Config.StaffSpawnPoint))

function insidePolygon( point)
  local oddNodes = false
  local j = #Config.Zone
  for i = 1, #Config.Zone do
      if (Config.Zone[i][2] < point[2] and Config.Zone[j][2] >= point[2] or Config.Zone[j][2] < point[2] and Config.Zone[i][2] >= point[2]) then
          if (Config.Zone[i][1] + ( point[2] - Config.Zone[i][2] ) / (Config.Zone[j][2] - Config.Zone[i][2]) * (Config.Zone[j][1] - Config.Zone[i][1]) < point[1]) then
              oddNodes = not oddNodes;
          end
      end
      j = i;
  end
  return oddNodes 
end



Citizen.CreateThread(function()
  TriggerServerEvent('startSyncMeeting')
end)

RegisterNetEvent('beginMeeting')
AddEventHandler('beginMeeting', function()
    meetingRunning = true
    runMeeting()
end)

RegisterNetEvent('endMeeting')
AddEventHandler('endMeeting', function()
    meetingRunning = false
end)

RegisterNetEvent('staffMeeting')
AddEventHandler('staffMeeting', function()
    allowed = true
end)

Citizen.CreateThread(function()
  function runMeeting()
    a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    if not allowed then
      SetEntityCoords(GetPlayerPed(-1), x, y, z, 0, 0, 0, false)
    else
      SetEntityCoords(GetPlayerPed(-1), x2, y2, z2, 0, 0, 0, false)
    end
    while true do
      Citizen.Wait(0)
      if meetingRunning == true then
        local player = source
        local ped = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(ped)
        local inZone = insidePolygon(playerCoords)
        drawPoly(inZone)
        if not inZone and not allowed then
          SetEntityCoords(GetPlayerPed(-1), x, y, z, 0, 0, 0, false)
        end
        if not allowed then
          DisableControlAction(0, 249, true)
          DisableControlAction(0, 140, false)
          DisableControlAction(0, 45, true)
          DisableControlAction(0, 24, true)
          SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
        end
      else
        SetEntityCoords(GetPlayerPed(-1), a, b, c, 0, 0, 0, false)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        DisableControlAction(0, 249, false)
        DisableControlAction(0, 140, false)
        DisableControlAction(0, 45, false)
        DisableControlAction(0, 24, false)
        return
      end
    end
  end
end)

function drawPoly(isEntityZone)
  local iPed = GetPlayerPed(-1)
  for i = 1, #Config.Zone do
      local Zone = Zone
      local j = #Config.Zone
      for i = 1, #Config.Zone do
              
          local zone = Config.Zone[i]
          if i < #Config.Zone then
              local p2 = Config.Zone[i+1]
              _drawWall(zone, p2)
          end
      end
  
      if #Config.Zone > 2 then
          local firstPoint = Config.Zone[1]
          local lastPoint = Config.Zone[#Config.Zone]
          _drawWall(firstPoint, lastPoint)
      end
  end
end


function _drawWall(p1, p2)
  local bottomLeft = vector3(p1[1], p1[2], p1[3] - 1.5)
  local topLeft = vector3(p1[1], p1[2],  p1[3] + 2.5)
  local bottomRight = vector3(p2[1], p2[2], p2[3] - 1.5)
  local topRight = vector3(p2[1], p2[2], p2[3] + 2.5)
  
  DrawPoly(bottomLeft,topLeft,bottomRight,225,225,225,5)
  DrawPoly(topLeft,topRight,bottomRight,225,225,225,5)
  DrawPoly(bottomRight,topRight,topLeft,225,225,225,5)
  DrawPoly(bottomRight,topLeft,bottomLeft,225,225,225,5)
end