/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

/*-----------------------------------------------------
					Car Dealer 
-----------------------------------------------------*/

concommand.Add("scardealer_spawn", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		local Pos = string.Explode(" ", tostring(ply:GetPos()) )
		local Ang = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)))
		
		file.Write("S-CarDealer/car_spawn_"..string.lower(game.GetMap())..".txt", ""..(Pos[1]).." "..(Pos[2]).." "..(Pos[3]).." "..(Ang[1]).." "..(Ang[2]).." "..(Ang[3]))
		ply:SendLua('local tab = {Color(230, 92, 78), "[S-CarDealer] ", color_white, "Modification du spawn effectué avec succès." } chat.AddText(unpack(tab))')
	else
		ply:SendLua('local tab = {Color(230, 92, 78), "[S-CarDealer] ", color_white, "Vous n\'êtes pas superadmin." } chat.AddText(unpack(tab))')
	end
end)

net.Receive("OpenSCarDealerMenu",function(lenght,ply)
	local SendnNet = net.ReadString()
	local SendTable = net.ReadTable()

	net.Start(SendnNet)
	net.WriteTable(SendTable)
	net.Send(ply)
end)

timer.Simple(1,function()
	// Create Folder Data
	SCarDealerCreateData()
	// Spawn Car Dealer
	ScarDealerInitializeCarDealer()
end)

hook.Add("PostCleanupMap","SCarDealerSpawn",function()	
	// Respawn All Car Dealer
	ScarDealerRespawnCarDealer()
end)

net.Receive("SaveSCarDealer",function(lenght,ply)
	local CarDealer = {}
	local CarDealerID = string.lower(net.ReadFloat())
	local CarDealerName = net.ReadString()
	local CarDealerModel = net.ReadString()
	local CarDealerEntity = net.ReadEntity()

	if ply:IsSuperAdmin() then
		if CarDealerEntity:GetClass() == "s-cardealer" then
			if file.Exists( "S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."/"..CarDealerID..".txt" , "DATA" ) then
				file.Delete( "S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."/"..CarDealerID..".txt" )
			end

			local CarDealerEntityPos = string.Explode(" ", tostring(CarDealerEntity:GetPos()))

			CarDealer = {
				ID = CarDealerID,
				Pos = CarDealerEntityPos[1].." "..CarDealerEntityPos[2].." "..CarDealerEntityPos[3],
				Name = CarDealerName,
				Model = CarDealerModel
			}

			local CarDealerTab = util.TableToJSON( CarDealer )

			file.Write("S-CarDealer/car_dealer/"..string.lower(game.GetMap()).."/"..CarDealerID..".txt", CarDealerTab)

			CarDealerEntity:SetModel(CarDealerModel)
			CarDealerEntity:SetCarDealerID(CarDealerID)
			CarDealerEntity:SetCarDealerName(CarDealerName)
			CarDealerEntity:SetCarDealerModel(CarDealerModel)
			CarDealerEntity:SetNWBool("SCarDealer_Save", true)
		else
			ply:ChatPrint("Vous ne pouvez pas supprimer ce car dealer car il est déjà enregistré, supprimer-le puis re-créer en un.")
		end
	else
		ply:ChatPrint("Vous n'êtes pas superadmin.")
	end
end)

net.Receive("DelSCarDealer",function(lenght,ply)
	local CarDealerEntity = net.ReadEntity()
	local CarDealerID = CarDealerEntity:GetNWFloat('SCarDealer_ID')

	SCarDealerRemoveCarDealer(ply,CarDealerID,CarDealerEntity)
end)