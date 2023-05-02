-- anim load
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- ip-target
local model = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

exports[Config.Target]:AddTargetModel(model, {
    options = {
        {
            type = 'server',
            event = 'ron-banking:server:openUI',
            icon = 'fas fa-money-check',
            label = 'Akses ATM',
        },
    },
    distance = 1.5
})


for _, v in pairs(Config.Banks) do
    exports['qtarget']:AddCircleZone('Bank_' .. _, vec3(v['coords'].x, v['coords'].y, v['coords'].z - 0.7), 1.2,
        {
            name = 'Bank_' .. _,
            debugPoly = false,
            useZ = true,
        }, {
            options = {
                {
                    type = 'server',
                    event = 'ron-banking:server:openUI',
                    icon = 'fas fa-piggy-bank',
                    label = 'Bank',
                    lokasi = _,
                    canInteract = function()
                        if not IsPedInAnyVehicle(PlayerPedId()) then
                            return true
                        end
                    end,
                },
            },
            distance = 1.0
        })
end


RegisterNetEvent('ron-banking:client:openUI', function()
    loadAnimDict("mp_common")
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    --
    if lib.progressBar({
            duration = 3500,
            label = 'Membuka Bank',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = false,
            },
        }) then
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = true,
                playerData = playerData
            })
            ClearPedTasks(PlayerPedId())
            FreezeEntityPosition(GetPlayerPed(-1), false)
        end)
    else
        exports['mythic_notify']:DoHudText('error', 'Canceled')
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
    --
end)

RegisterNUICallback('Deposit', function(data, cb)
    TriggerServerEvent('ron-banking:deposit', data.inputVal)
    SetTimeout(500, function()
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SendNUIMessage({
                updateBalance = true,
                playerData = playerData
            })
        end)
    end)
end)

RegisterNUICallback('Withdraw', function(data, cb)
    TriggerServerEvent('ron-banking:withdraw', data.inputVal)
    SetTimeout(500, function()
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SendNUIMessage({
                updateBalance = true,
                playerData = playerData
            })
        end)
    end)
end)

RegisterNUICallback('transfer', function(data, cb)
    TriggerServerEvent('ron-banking:transfer', data.inputValID, data.inputVal)
    SetTimeout(500, function()
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SendNUIMessage({
                updateBalance = true,
                playerData = playerData
            })
        end)
    end)
end)

RegisterNUICallback('quickdep', function(data, cb)
    quickActionsDeposit(data.amount)
    cb('ok')
end)

RegisterNUICallback('quickwit', function(data, cb)
    quickActionsWithdraw(data.amount)
    cb('ok')
end)

function quickActionsWithdraw(amount)
    TriggerServerEvent('ron-banking:withdraw', amount)
    SetTimeout(500, function()
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SendNUIMessage({
                updateBalance = true,
                playerData = playerData
            })
        end)
    end)
end

function quickActionsDeposit(amount)
    TriggerServerEvent('ron-banking:deposit', amount)
    SetTimeout(500, function()
        lib.callback('ron-banking:server:get', false, function(playerData)
            playerData.id = cache.serverId
            SendNUIMessage({
                updateBalance = true,
                playerData = playerData
            })
        end)
    end)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

-- blip
Citizen.CreateThread(function()
    for _, loc in pairs(Config.Banks) do
        loc = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(loc, 108)
        SetBlipColour(loc, 2)
        SetBlipScale(loc, 0.7)
        SetBlipAsShortRange(loc, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bank")
        EndTextCommandSetBlipName(loc)
    end
end)
