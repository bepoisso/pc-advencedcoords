-- Variables
local markerActive = false -- Is the coordinate selection active
local markerCoords = nil -- Current marker position
local activeCallback = nil -- Callback function for export mode

-- Command: Activate coordinate selection and copy to clipboard
-- Usage: /coords
RegisterCommand('coords', function()
    markerActive = false
    markerCoords = nil
    activeCallback = nil

    markerActive = true
    markerCoords = nil
    
    lib.showTextUI('[E] Copy coordinates')
end, false)

-- Export: Activate coordinate selection and return vector3 via callback
-- Usage from another script: exports['pc-advencedcoords']:selectCoords(function(coords) ... end)
-- @param cb - Callback function that receives the selected vector3
exports('selectCoords', function(cb)
    markerActive = false
    markerCoords = nil
    activeCallback = nil

    markerActive = true
    markerCoords = nil
    activeCallback = cb
    
    lib.showTextUI('[E] Select coordinates')
end)

-- Main thread: Handles marker display and coordinate selection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if markerActive then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local camCoord = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(0)
            
            -- Calculate camera direction vector
            local camDir = vector3(
                -math.sin(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
                math.cos(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
                math.sin(math.rad(camRot.x))
            )
            
            -- Raycast from camera to detect surfaces
            local distance = 10.0
            local targetCoords = camCoord + camDir * distance
            local ray = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, targetCoords.x, targetCoords.y, targetCoords.z, -1, playerPed, 0)
            local _, hit, endCoords = GetShapeTestResult(ray)

            -- Position marker at raycast hit point or fallback position
            if hit == 1 then
                markerCoords = vector3(endCoords.x, endCoords.y, endCoords.z)
            else
                markerCoords = playerCoords + camDir * 2.0
            end

            -- Draw red marker at target position
            DrawMarker(28, markerCoords.x, markerCoords.y, markerCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)

            -- Handle E key press
            if IsControlJustPressed(0, 38) then -- Key E
                lib.hideTextUI()
                
                if activeCallback then
                    -- Export mode: Return vector3 to callback function
                    activeCallback(markerCoords)
                    activeCallback = nil
                else
                    -- Command mode: Copy coordinates to clipboard
                    local text = string.format('vector3(%.2f, %.2f, %.2f)', markerCoords.x, markerCoords.y, markerCoords.z)
                    lib.setClipboard(text)
                    lib.notify({
                        title = 'Coordinates copied',
                        description = text,
                        type = 'success'
                    })
                end
                
                -- Deactivate marker
                markerActive = false
                markerCoords = nil
            end
        end
    end
end)
