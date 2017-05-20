/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("")
	self:SetSolid( SOLID_BBOX )
	self:SetUseType( SIMPLE_USE )
end

function ENT:AcceptInput(Name,Activator,Caller) 
    if Name == "Use" && IsValid(Caller) && Caller:IsPlayer() then
		local VehicleTable = {}
		if file.Exists( "s-cardealer/owners/"..Caller:SteamID64()..".txt","DATA") then
			VehicleTable = util.JSONToTable(file.Read( "s-cardealer/owners/"..Caller:SteamID64()..".txt" ))
		end

    	net.Start("OpenSCarDealerStoreMenu")
    	net.WriteTable(VehicleTable)
    	net.Send(Caller)
    end
end

function ENT:SetCarDealerID( id )
	self:SetNWFloat( "SCarDealer_ID", id )
end

function ENT:SetCarDealerName( name )
	self:SetNWString( "SCarDealer_Name", name )
end

function ENT:SetCarDealerModel( model )
	self:SetNWString( "SCarDealer_Model", model )
end