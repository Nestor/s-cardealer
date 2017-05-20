/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

if( SERVER ) then		
	include( "s-cardealer/cardealer_config.lua" )
	include( "s-cardealer/server/sv_cardealer.lua" )
	include( "s-cardealer/server/sv_cardealer_functions.lua" )
	
	AddCSLuaFile( "s-cardealer/cardealer_config.lua" )
	AddCSLuaFile( "s-cardealer/client/admin_menu.lua" )
	AddCSLuaFile( "s-cardealer/client/cardealer.lua" )
end

if( CLIENT ) then
	include( "s-cardealer/cardealer_config.lua" )
	include( "s-cardealer/client/admin_menu.lua" )
	include( "s-cardealer/client/cardealer.lua" )
end