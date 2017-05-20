ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName       = "Car Dealer"
ENT.Category        = "♦ SlownLS | Car Dealer ♦" 
ENT.Spawnable       = false

function ENT:GetCarDealerID()
	return self:GetNWFloat( "SCarDealer_ID")
end

function ENT:GetCarDealerName()
	return self:GetNWString( "SCarDealer_Name")
end

function ENT:GetCarDealerModel()
	return self:GetNWString( "SCarDealer_Model")
end