/*-----------------------------------------------------------------
	Auteur		= SlownLS
	Addon 		= S-CarDealer
	Version 	= 1.0
	Site 		= http://slownls.fr
	Steam 	 	= https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

AddCSLuaFile()

for i=10,100 do 
	surface.CreateFont("SlownLSFont"..i, {
	font = "Open Sans", 
	size = i, 
	weight = 2000
})
end 

net.Receive("DeploySCarDealerConfigWeapon",function()
	chat.AddText(Color(230, 92, 78), "[S-CarDealer] ", color_white, "Left click to spawn Car Dealer")
	chat.AddText(Color(230, 92, 78), "[S-CarDealer] ", color_white, "Right click to config Car Dealer")
end)

net.Receive("OpenSCarDealerMenuConfig",function()

	local CarDealerEntity = net.ReadEntity()

	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 435, 215 )
	Base:Center()
	Base:SetTitle( "" )
	Base:SetVisible( true )
	Base:SetDraggable( true )
	Base:ShowCloseButton( true )
	Base:MakePopup()
	Base.Paint = function(self,w,h)
	 	draw.RoundedBox(0, 0, 0, w, h, Color(54, 57, 62, 255))
		draw.RoundedBox( 0, 0, 0, 40, h, Color(230, 92, 78))
	end

	local TextEntry = vgui.Create( "DTextEntry", Base ) 
	TextEntry:SetPos( 60, 30 )
	TextEntry:SetSize( Base:GetWide()-75-5, 25 )
	if CarDealerEntity:GetNWBool("SCarDealer_Save") == true then
		TextEntry:SetText( CarDealerEntity:GetCarDealerID() )	
	else
		TextEntry:SetText( "Enter unique ID (Number)..." )	
	end
	TextEntry:SetNumeric(true)	
	TextEntry.OnGetFocus = function(self)
		if self:GetText() == "Enter unique ID (Number)..." then
			self:SetText("")
		end
	end
	TextEntry.OnLoseFocus = function(self)
		if self:GetText() == "Enter unique ID (Number)..." then
			self:SetText("")
		end
	end	

	local TextEntry1 = vgui.Create( "DTextEntry", Base ) 
	TextEntry1:SetPos( 60, 30+25+10 )
	TextEntry1:SetSize( Base:GetWide()-75-5, 25 )
	if CarDealerEntity:GetNWBool("SCarDealer_Save") == true then
		TextEntry1:SetText( CarDealerEntity:GetCarDealerName() )	
	else
		TextEntry1:SetText( "Car Dealer" )	
	end

	local TextEntry2 = vgui.Create( "DTextEntry", Base ) 
	TextEntry2:SetPos( 60, 30+25+10+25+10 )
	TextEntry2:SetSize( Base:GetWide()-75-5, 25 )
	if CarDealerEntity:GetNWBool("SCarDealer_Save") == true then
		TextEntry2:SetText( CarDealerEntity:GetCarDealerModel() )	
	else
		TextEntry2:SetText( "models/gman_high.mdl" )	
	end

    local Button = vgui.Create( "DButton", Base )
    Button:SetPos( 60, 30+25+10+25+10+25+10)
    Button:SetSize( Base:GetWide()-75-5, 35 )
    Button:SetText( "Save" )
    Button:SetFont( "SlownLSFont20" )
    Button:SetTextColor(Color(255, 255, 255, 200))
    Button.OnCursorEntered = function(self) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
    Button.OnCursorExited = function(self) self.hover = false end
    Button.Paint = function(self,w,h)
        draw.RoundedBox(3, 0, 0, w, h-2, Color(0, 0, 0, 50))
        if self.hover then
            draw.RoundedBox(3, 0, 0, w, h-1, Color(0, 0, 0, 50))
            draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 50))
        end
        draw.RoundedBox(3, 0, 0, w, h-3, Color(230, 92, 78))
    end
    Button.DoClick = function()
    	if TextEntry:GetValue() == "Enter unique ID (Number)..." or TextEntry:GetValue() == "" then

    	else
    		net.Start('SaveSCarDealer')
	    	net.WriteFloat(TextEntry:GetValue())
	    	net.WriteString(TextEntry1:GetValue())
	    	net.WriteString(TextEntry2:GetValue())
	    	net.WriteEntity(CarDealerEntity)
	    	net.SendToServer()
	    end

    	Base:Close()
    end

    local Button2 = vgui.Create( "DButton", Base )
    Button2:SetPos( 60, 30+25+10+25+10+25+10+35+5)
    Button2:SetSize( Base:GetWide()-75-5, 35 )
    Button2:SetText( "Delete" )
    Button2:SetFont( "SlownLSFont20" )
    Button2:SetTextColor(Color(255, 255, 255, 200))
    Button2.OnCursorEntered = function(self) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
    Button2.OnCursorExited = function(self) self.hover = false end
    Button2.Paint = function(self,w,h)
        draw.RoundedBox(3, 0, 0, w, h-2, Color(0, 0, 0, 50))
        if self.hover then
            draw.RoundedBox(3, 0, 0, w, h-1, Color(0, 0, 0, 50))
            draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 50))
        end
        draw.RoundedBox(3, 0, 0, w, h-3, Color(230, 92, 78))
    end
    Button2.DoClick = function()
		net.Start('DelSCarDealer')
    	net.WriteEntity(CarDealerEntity)
    	net.SendToServer()

    	Base:Close()
    end

end)

net.Receive("OpenSCarDealer",function()
	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 435, 400 )
	Base:Center()
	Base:SetTitle( "" )
	Base:SetVisible( true )
	Base:SetDraggable( true )
	Base:ShowCloseButton( true )
	Base:MakePopup()
	Base.Paint = function(self,w,h)
	 	draw.RoundedBox(0, 0, 0, w, h, Color(54, 57, 62, 255))
		draw.RoundedBox( 0, 0, 0, 40, h, Color(230, 92, 78))
	end

    local Liste = vgui.Create("DScrollPanel", Base)
    Liste:SetSize(Base:GetWide()-80, Base:GetTall()-47)
    Liste:SetPos(60, 30)
    local scrollbar = Liste:GetVBar()
    function scrollbar:Paint(w, h)
        draw.RoundedBox(3, 5, 0, 10, h, Color(46, 49, 54, 255))
    end
    function scrollbar.btnUp:Paint(w, h)
        draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
    end
    function scrollbar.btnDown:Paint(w, h)
        draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
    end
    function scrollbar.btnGrip:Paint(w, h)
        draw.RoundedBox(3, 5, 0, 10, h, Color(36, 39, 44, 255))
    end

	for k, v in pairs(CarDealer.Cars) do


		local Fond = vgui.Create("DPanel", Liste)
        Fond:SetSize(0, 65)
        Fond:DockMargin(0, 0, 0, 5)
        Fond:Dock(TOP)
        Fond:SetText("")
		Fond.Paint = function(self, w,h)
			draw.RoundedBox(5, 0, 0, w, h,Color(75, 131, 161, 255))

			draw.DrawText(CarDealerInfos.ID, "Trebuchet24", (w / 9) * 2 + 0, h / 2 - 14, color_white, TEXT_ALIGN_LEFT)
		end
 
        local Model = vgui.Create("SpawnIcon", Fond)
        Model:SetPos(20, 5)
        Model:SetSize(55, 55)
        Model:SetModel(v.Model)
 
	    local WeaponPickUp = vgui.Create( "DButton", Fond )
	    WeaponPickUp:SetPos( Liste:GetWide()-145, 17 )
	    WeaponPickUp:SetSize( 125, 35 )
	    WeaponPickUp:SetText( "Prendre" )
	    WeaponPickUp:SetFont( "XerosCommunityFont20" )
	    WeaponPickUp:SetTextColor(Color(255, 255, 255, 200))
	    WeaponPickUp.OnCursorEntered = function(self) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
	    WeaponPickUp.OnCursorExited = function(self) self.hover = false end
	    WeaponPickUp.Paint = function(self,w,h)
	        draw.RoundedBox(3, 0, 0, w, h-2, Color(0, 0, 0, 50))
	        if self.hover then
	            draw.RoundedBox(3, 0, 0, w, h-1, Color(0, 0, 0, 50))
	            draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 50))
	        end
	        draw.RoundedBox(3, 0, 0, w, h-3,Color( 54, 57, 62, 255 ))
	    end
	    WeaponPickUp.DoClick = function()
	    	net.Start("XCGivePoliceWeapons")
	    	net.WriteFloat(k)
	    	net.SendToServer()
	    	
	        Base:Close()
	    end
	end
end)