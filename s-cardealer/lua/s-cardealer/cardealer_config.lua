/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

SCarDealerConfig = {}
SCarDealerConfig.Cars = {}

SCarDealerConfig.Cars[1] = {
	class = "Jeep",
	price = 5000,

	customCheck = function(ply) return table.HasValue({'superadmin', "VIP"}, ply:GetUserGroup()) end,
	CustomCheckFailMSg = "Ce vehicule est pour les V.I.P's"
}

SCarDealerConfig.Cars[2] = {
	class = "Airboat",
	price = 5000
}