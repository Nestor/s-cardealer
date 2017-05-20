/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

/*-----------------------------------------------------
					Network
-----------------------------------------------------*/

// Admin Weapon
util.AddNetworkString('DeploySCarDealerConfigWeapon')
util.AddNetworkString('OpenSCarDealerMenuConfig')
util.AddNetworkString('SaveSCarDealer')
util.AddNetworkString('DelSCarDealer')

// Car Dealer Options
util.AddNetworkString('SCarDealerPurchaseVehicle')
util.AddNetworkString('SCarDealerSpawnVehicle')

// Menu
util.AddNetworkString('OpenSCarDealerMenu')
util.AddNetworkString("OpenSCarDealerStoreMenu")
util.AddNetworkString("OpenSCarDealerInventoryMenu")

/*-----------------------------------------------------
				SCarDealer Initialize
-----------------------------------------------------*/

function SCarDealerCreateData()
	if !file.IsDir("S-CarDealer", "DATA") then
		file.CreateDir("S-CarDealer", "DATA") 
		file.CreateDir("S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."", "DATA") 
		file.CreateDir("S-CarDealer/owners/", "DATA") 
	end 
end

function ScarDealerInitializeCarDealer()
	for k, v in pairs(file.Find("s-cardealer/car_dealer/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
		local CarDealerFilePos = file.Read("s-cardealer/car_dealer/"..string.lower(game.GetMap()).."/"..v, "DATA")
			 
		local CarDealerInfos =  util.JSONToTable(CarDealerFilePos)

		local CarDealerPos = string.Explode(" ", CarDealerInfos.Pos)

		local CarDealer = ents.Create("s-cardealer")
		CarDealer:SetModel(CarDealerInfos.Model)
		CarDealer:SetPos(Vector( CarDealerPos[1],CarDealerPos[2],CarDealerPos[3]))
		CarDealer:SetCarDealerID(CarDealerInfos.ID)
		CarDealer:SetCarDealerName(CarDealerInfos.Name)
		CarDealer:SetCarDealerModel(CarDealerInfos.Model)
		CarDealer:SetNWBool("SCarDealer_Save", true)
		CarDealer:Spawn()
	end
end

/*-----------------------------------------------------
				SCarDealer Functions
-----------------------------------------------------*/

function ScarDealerRespawnCarDealer()
	for k, v in pairs(file.Find("s-cardealer/car_dealer/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
		local CarDealerFilePos = file.Read("s-cardealer/car_dealer/"..string.lower(game.GetMap()).."/"..v, "DATA")
			 
		local CarDealerInfos =  util.JSONToTable(CarDealerFilePos)

		local CarDealerPos = string.Explode(" ", CarDealerInfos.Pos)

		local CarDealer = ents.Create("s-cardealer")
		CarDealer:SetModel(CarDealerInfos.Model)
		CarDealer:SetPos(Vector( CarDealerPos[1],CarDealerPos[2],CarDealerPos[3]))
		CarDealer:SetCarDealerID(CarDealerInfos.ID)
		CarDealer:SetCarDealerName(CarDealerInfos.Name)
		CarDealer:SetCarDealerModel(CarDealerInfos.Model)
		CarDealer:SetNWBool("SCarDealer_Save", true)
		CarDealer:Spawn()
	end
end

function SCarDealerRemoveCarDealer(ply,ID,Entity)
	if ply:IsSuperAdmin() then
		if Entity:GetClass() == "s-cardealer" then
			if file.Exists( "S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."/"..ID..".txt" , "DATA" ) then
				file.Delete( "S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."/"..ID..".txt" )
			end

			Entity:Remove()
		end
	else
		ply:ChatPrint("Vous n'êtes pas superadmin.")
	end
end

function SCarDealerRemoveVehicule(ply)
	local vehicule = ply:GetNWEntity("SCarDealerVehicule")
	if IsValid(vehicule) then
		vehicule:Remove()
	end
end

function ScarDealerCheckInfos(ply,VehicleID)
	if !SCarDealerConfig.Cars[VehicleID] then
		ply:ChatPrint("Ce vehicule n'exsite pas.")
		ply:EmitSound("buttons/button11.wav")
		return
	end

	if SCarDealerConfig.Cars[VehicleID].customCheck and !SCarDealerConfig.Cars[VehicleID].customCheck(ply) then 
		if SCarDealerConfig.Cars[VehicleID].CustomCheckFailMsg then
			DarkRP.notify(ply, 1, 4, SCarDealerConfig.Cars[VehicleID].CustomCheckFailMsg)
		else
			DarkRP.notify(ply, 1, 4, "Erreur.")
		end
		return
	end
end

/*-----------------------------------------------------
				SCarDealer Network
-----------------------------------------------------*/

net.Receive("SCarDealerSpawnVehicle",function(lenght,ply)
	local ID = net.ReadFloat()
	local VehicleTable = net.ReadTable()
	// Check informations
	ScarDealerCheckInfos(ply,ID)
	// Remove current vehicle
	SCarDealerRemoveVehicule(ply)
	// Check Vehicle
	if !table.HasValue(VehicleTable, SCarDealerConfig.Cars[ID].class) then
			ply:ChatPrint("Vous n'avez pas ce vehicule.")
			ply:EmitSound("buttons/button11.wav")
		return 
	end
	// Load Vehicle Informations
	local CarInfos = list.Get("Vehicles")[SCarDealerConfig.Cars[ID].class]
	if !CarInfos then return end
	// Spawn Vehicle
	local SpawnVehicle = ents.Create(CarInfos.Class)
	if !SpawnVehicle then return end
	SpawnVehicle:SetModel(CarInfos.Model)
	SpawnVehicle:SetPos(Vector(file.Read("S-CarDealer/car_spawn_"..string.lower(game.GetMap())..".txt")))
	if CarInfos.KeyValues then
		for k, v in pairs(CarInfos.KeyValues) do
			SpawnVehicle:SetKeyValue(k, v)
		end
	end
	SpawnVehicle:Spawn()
	SpawnVehicle:Activate()
	SpawnVehicle:keysOwn(ply)
	SpawnVehicle:keysLock()

	ply:EnterVehicle(SpawnVehicle)
	ply:SetNWEntity("SCarDealerVehicule", SpawnVehicle)
end)

net.Receive("SCarDealerPurchaseVehicle",function(lenght,ply)
	local ID = net.ReadFloat()
	local VehicleTable = {}
	// Get Table cars
	if file.Exists( "s-cardealer/owners/"..ply:SteamID64()..".txt","DATA") then
		VehicleTable = util.JSONToTable(file.Read( "s-cardealer/owners/"..ply:SteamID64()..".txt" ))
	end
	// Generate Unique Number
	local function UniqueNumberID()
		local UniqueNumber = math.random(1,999999)
		if VehicleTable[UniqueNumber] then
			return UniqueNumberID()
		else
			return UniqueNumber
		end
	end
	// Check informations
	ScarDealerCheckInfos(ply,ID)
	// Check Player Money
	if !ply:canAfford(SCarDealerConfig.Cars[ID].price) then
		DarkRP.notify(ply, 1, 4, "Vous n'avez pas assez d'argent.") 
		return
	end
	// Withdraw money from the player
	ply:addMoney(-SCarDealerConfig.Cars[ID].price)
	// Add Class of vehicle to table
	VehicleTable[UniqueNumberID()] = SCarDealerConfig.Cars[ID].class
	// Add vehicle to file data
	file.Write("s-cardealer/owners/"..ply:SteamID64()..".txt", util.TableToJSON(VehicleTable))
end)

/*-----------------------------------------------------
				SCarDealer Hook's
-----------------------------------------------------*/

hook.Add("PlayerInitialSpawn","SCarDealer",function(ply)
	if !file.Exists("s-cardealer/owners/"..ply:SteamID64()..".txt", "DATA") then
		file.Write("s-cardealer/owners/"..ply:SteamID64()..".txt","[]")
	end
end)

hook.Add("PlayerDisconnected","SCarDealer",function(ply)
	SCarDealerRemoveVehicule(ply)
end)
