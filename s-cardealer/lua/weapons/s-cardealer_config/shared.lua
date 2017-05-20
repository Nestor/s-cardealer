/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

AddCSLuaFile()

SWEP.PrintName = "Car Dealer Config"
SWEP.Author = "SlownLS"
SWEP.Category = "♦ SlownLS | Car Dealer ♦"
SWEP.Instructions = "Left click to spawn Car Dealer\nRight click to config Car Dealer"

SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.UseHands			= true

function SWEP:Initialize()
    self:SetHoldType("normal")
end

/*-------------------------
		Deploy
-------------------------*/

function SWEP:Deploy()
	if CLIENT or not IsValid(self:GetOwner()) then return true end

	if SERVER then
		net.Start("DeploySCarDealerConfigWeapon")
		net.Send(self.Owner)
	end

    return true
end

function SWEP:Holster()
	return true
end

/*-------------------------
		PrimaryAttack
-------------------------*/

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime()+.2)
	if SERVER then
		if self.Owner:IsSuperAdmin() then
			local tr = self.Owner:GetEyeTrace()

			local CarDealer = ents.Create("s-cardealer")
			CarDealer:SetModel('models/gman_high.mdl')
			CarDealer:SetPos(tr.HitPos)
			CarDealer:Spawn()
						
			undo.Create( "s-cardealer" )
			undo.AddEntity( CarDealer )
			undo.SetPlayer( self:GetOwner() )
			undo.Finish()
		else
			self.Owner:ChatPrint("Vous n'êtes pas superadmin.")
		end
	end
end

/*-------------------------
		SecondaryAttack
-------------------------*/

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime()+.2)
	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local ent = tr.Entity

		if ent:GetClass() == "s-cardealer" then
			if self.Owner:GetPos():Distance( ent:GetPos() ) <= 100 then
				net.Start("OpenSCarDealerMenuConfig")
				net.WriteEntity(ent)
				net.Send(self.Owner)
			end
		end
	end
end
