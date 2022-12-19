Citizen.CreateThread(function()
    while true do
        local idle = 500
        local ped = GetPlayerPed(-1)
        local inhand = GetSelectedPedWeapon(ped, true)
        local armed = IsPedArmed(ped, 1 | 4 | 2)
        local check, hash = Blacklisted(inhand)
        if armed == 1 then
            if check then
                TriggerServerEvent('check:permissions', inhand)
            end
        else
            idle = 800
        end
        Citizen.Wait(idle)
    end
end)

RegisterNetEvent('remove:weapon')
AddEventHandler('remove:weapon', function(hash)
    local ped = GetPlayerPed(-1)
    RemoveWeaponFromPed(ped, hash)
    TriggerEvent('chatMessage', wepcfg.error_msg)
end)


function Blacklisted(inhand)
    local check = false
    for role, cat in pairs(wepcfg.whitelisted_weapons) do
        for k, v in pairs(cat) do
            if inhand == GetHashKey(v.WepName) then
                check = true
            end
        end
    end
    return check
end
