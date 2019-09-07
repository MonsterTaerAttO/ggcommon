local FirstSpawn = true
local LocalPedId = 0
local LocalPlayerId = 0

AddEventHandler(
    "playerSpawned",
    function()
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(LocalPlayerId, true, true)

        if (FirstSpawn) then
            SetGarbageTrucks(false)
            SetRandomBoats(false)

            for service=1, 15 do
                EnableDispatchService(service, false)
            end

            print("[Common] Disabled dispatch services, garbage trucks, and boats.")

            FirstSpawn = false
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)

            RestorePlayerStamina(LocalPlayerId, 1.0)

            if (GetPlayerWantedLevel(LocalPlayerId) > 0) then
                ClearPlayerWantedLevel(LocalPlayerId)
                SetPlayerWantedLevelNow(LocalPlayerId, 0)
            end
        end
    end
)

Citizen.CreateThread(function()
    while true do
        LocalPedId = PlayerPedId()
        LocalPlayerId = PlayerId()
        local _, hash = GetCurrentPedWeapon(LocalPedId, true)
        SetPedInfiniteAmmo(LocalPedId, true, hash)
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        Citizen.Wait(0)
    end
end)