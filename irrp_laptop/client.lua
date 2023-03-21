-- Load ESX Stuff
ESX = nil
PlayerData = {}
Config = {}
local IsLaptopOpen = false

-- Load Source {IRan RolePlay Default}
Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	while not ESX.GetPlayerData().gang do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNUICallback('submit', function(order)
	TriggerEvent('irrp_laptop:clearCart')
	TriggerServerEvent('irrp_laptop:submitOrder', order)
end)

RegisterNUICallback('refresh', function()
	ESX.TriggerServerCallback('irrp_laptop:fetchData', function(data)
		SendNUIMessage({type = 'open', data = data})
	end)
end)

RegisterNUICallback('close', function()
	SetNuiFocus(false, false)
	IsLaptopOpen = false
	TriggerEvent('irrp_laptop:clearCart')
end)

RegisterNetEvent('irrp_laptop:displayLaptop')
AddEventHandler('irrp_laptop:displayLaptop', function(data)
	SendNUIMessage({type = 'open', data = data})
	SetNuiFocus(true, true)
	IsLaptopOpen = true
end)

RegisterNetEvent('irrp_laptop:forceRefresh')
AddEventHandler('irrp_laptop:forceRefresh', function()
    if IsLaptopOpen then
		ESX.TriggerServerCallback('irrp_laptop:fetchData', function(data)
			SendNUIMessage({type = 'open', data = data})
		end)
	end
end)

RegisterNetEvent('irrp_laptop:clearCart')
AddEventHandler('irrp_laptop:clearCart', function()
	SendNUIMessage({type = 'clearCart'})
end)

RegisterNetEvent('irrp_laptop:sendNuiNotification')
AddEventHandler('irrp_laptop:sendNuiNotification', function(message)
	SendNUIMessage({type = 'notification', message = message})
end)

RegisterCommand('lap', function(source,args)
	TriggerEvent('irrp_laptop:carstuff', 1)
end)


--Load Source {Writed By Mehdi Raptor}
RegisterNetEvent('irrp_laptop:carstuff')
AddEventHandler('irrp_laptop:carstuff', function(order)

	local model = GetHashKey('benson')
    local randomDrive = math.random(1,tablelength(Config.coordDrive))
    local coordRandomDrive = Config.coordDrive[randomDrive]
	local waitingtime = math.random(Config.waitmin,Config.waitmax)

	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(300)
	end

	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "Yek ^1Mahmole aslahe^0 Bein ^2".. Config.waitmin .." ^0Ta ^2".. Config.waitmax .." ^0Daghighe Digar Miresad!")

	Citizen.Wait(1000*60*waitingtime)

	vehicle = CreateVehicle(model, coordRandomDrive.x, coordRandomDrive.y, coordRandomDrive.z-1, 0.0, true, false)

	SetVehicleEngineHealth(vehicle, 0)

	TriggerEvent('irrp_laptop:applyVehicleAppearence', NetworkGetNetworkIdFromEntity(vehicle))

	TriggerServerEvent('irrp_laptop:PutItem', GetVehicleNumberPlateText(vehicle),order)

	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^1Mahmole aslahe^0 Resid Va Mahal an bar rooye ^2MAP ^0Moshakhas shod!")

	createblipw(GetEntityCoords(vehicle))

	TriggerServerEvent('irrp_laptop:Log', GetPlayerName(PlayerId()),hex,PlayerData.gang.name,PlayerData.gang.grade,json.encode(order))

end)

RegisterNetEvent('irrp_laptop:applyVehicleAppearence')
AddEventHandler('irrp_laptop:applyVehicleAppearence', function(netid)
	local vehicle = NetworkGetEntityFromNetworkId(netid)
	if DoesEntityExist(vehicle) then
		SetVehicleColours(vehicle, 0, 0)
	end
end)

RegisterNetEvent('irrp_laptop:notifyPeople')
AddEventHandler('irrp_laptop:notifyPeople', function(data)
	if PlayerData.job and PlayerData.gang then
		if data.type == "police" then
			if PlayerData.job.name == data.type then
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Informer ha etelaa dadan ke yek ^1Mahmole aslahe^0 dar ^3" .. data.location .. "^0 ta ^230 ^0daghighe digar miresad!")
			end
		else
			if PlayerData.gang.name ~= "nogang" and PlayerData.gang.name ~= data.name and PlayerData.gang.grade >= 4 then
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Informer ha etelaa dadan ke yek ^1Mahmole aslahe^0 dar ^3" .. data.location .. "^0 ta ^230 ^0daghighe digar miresad!")
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if Vdist(GetEntityCoords(PlayerPedId()), GetEntityCoords(vehicle)) < 50 then
			RemoveBlip(blip)
		end
	end
end)


-- Load Functions
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

  function createblipw(x,y,z)
    blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, 432)
	SetBlipRoute(blip,  true)
	SetBlipRouteColour(blip, 5)
	SetBlipColour(blip, 6)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Black Market')
    EndTextCommandSetBlipName(blip)
end