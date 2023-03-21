ESX = nil
local loop = 0
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('laptop', function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    data = {}
    data.weapons = {
    ['weapon_smg'] = {
        name = 'SMG',
        price = 10000,
        count = 10
    },
    ['weapon_pistol'] = {
        name = 'Pistol',
        price = 4000,
        count = 3
    }
}
    data.user = {
        bank = xPlayer.bank
    }
    TriggerClientEvent('irrp_laptop:displayLaptop', source,data)
end)

RegisterServerEvent('irrp_laptop:submitOrder',function(order)
    TriggerClientEvent('irrp_laptop:carstuff', -1, order)
end)


RegisterServerEvent('irrp_laptop:PutItem')
AddEventHandler('irrp_laptop:PutItem', function(plate, order)
    Citizen.CreateThread(function()
        for item, amount in pairs(order) do
        for i = 1, amount, 1 do
            Citizen.Wait(500)
            TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
                local storeWeapons = store.get("weapons")

                if storeWeapons == nil then
                storeWeapons = {}
                end

                table.insert(storeWeapons,
                {
                    name = item,
                    label = ESX.GetWeaponLabel(item),
                    ammo = 250
                })


                store.set("weapons", storeWeapons)
                MySQL.Async.execute("UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",{["@plate"] = plate,["@owned"] = "script"})
            end)
        end
    end
    end)
end)

RegisterServerEvent('irrp_laptop:Log',function(name,steam,gang,grade,order)
    local xPlayer = ESX.GetPlayerFromId(source)
    LaptopLog(name,xPlayer.identifier,source,gang,grade,order)
end)

--Load Functions {Mehdi Raptor}
function LaptopLog(name,steam,id,gang,grade,order)
    local details = {
            {
                ["color"] = '51712',
                ["title"] = "Gang Laptop",
                ["description"] = "**Name** : "..name.."(".. id ..") \n**SteamHex** : "..steam.."\n**Gang** : "..gang.."\n**Grade** : ".. grade .."\n**Order** : ".. order,
                ["footer"] = {
                    ["text"] = "DarkWeb",
                    ["icon_url"] = 'https://images-ext-2.discordapp.net/external/a62bg8GjsJmIvqhUfabbTKuCeeNZjCBRO1ITtAcd6YU/%3Fsize%3D1024/https/cdn.discordapp.com/icons/978996662875877397/08510d53505946e6f6f80e96a7092fd6.png',
                },
            }
        }
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = "Gang Laptop", embeds = details}), { ['Content-Type'] = 'application/json' })
end