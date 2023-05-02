RegisterServerEvent('ron-banking:server:openUI', function()
    TriggerClientEvent('ron-banking:client:openUI', source, GetChar(source).last)
end)

lib.callback.register('ron-banking:server:get', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end


    local PlayerData = {}
    PlayerData.bank = xPlayer.getAccount('bank').money
    PlayerData.cash = xPlayer.getMoney()
    PlayerData.firstname = GetChar(source).firstname
    PlayerData.lastname = GetChar(source).lastname
    return PlayerData
end)

RegisterServerEvent('ron-banking:deposit', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local amount = tonumber(amount)
    if not amount then return end

    if amount < 0 then
        return xPlayer.showNotification('Jumlah tidak valid', 'error')
    end


    if xPlayer.getMoney() >= amount then
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', amount)
    end
end)

RegisterServerEvent('ron-banking:withdraw', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local amount = tonumber(amount)
    if not amount then return end

    if amount < 0 then
        return xPlayer.showNotification('Jumlah tidak valid', 'error')
    end

    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    end
end)

RegisterServerEvent('ron-banking:transfer', function(id, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local id, amount = tonumber(id), tonumber(amount)
    if not id or not amount then return end

    if amount < 0 then
        return xPlayer.showNotification('Jumlah tidak valid', 'error')
    end

    local xTarget = ESX.GetPlayerFromId(id)

    if xTarget ~= nil then
        if src ~= id then
            if xPlayer.getAccount('bank').money >= amount then
                xPlayer.removeAccountMoney('bank', amount)
                xTarget.addAccountMoney('bank', amount)
                local amount = ESX.Math.GroupDigits(amount)
                xPlayer.showNotification('Kamu telah mentrasfer dengan jumlah $' .. amount)
                xTarget.showNotification('Kamu menerima transfer dari Bank ID ' ..
                    xPlayer.source .. ' sebesar $' .. amount)
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source,
                {
                    type = 'error',
                    text = 'Kamu tidak dapat mengirim ke diri sendiri',
                    length = 2500,
                    style = { ['background-color'] = 'red', ['color'] = 'white' }
                })
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source,
            {
                type = 'error',
                text = 'Bank ID sedang offline',
                length = 2500,
                style = { ['background-color'] = 'red', ['color'] = 'white' }
            })
    end
end)

-- Get nama ic
GetChar = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE `identifier` = \'' .. xPlayer.identifier .. '\'', {})
    if result[1] then
        return result[1]
    else
        return nil
    end
end
