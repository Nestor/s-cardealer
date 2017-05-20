/*-----------------------------------------------------------------
    Auteur      = SlownLS
    Addon       = S-CarDealer
    Version     = 1.0
    Site        = http://slownls.fr
    Steam       = https://steamcommunity.com/id/slownls/
-----------------------------------------------------------------*/

AddCSLuaFile()

local function formatNumber(n)
    if not n then return "" end
    if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
    for i=dp-4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

net.Receive("OpenSCarDealerInventoryMenu",function()
	local VehicleTable = net.ReadTable()

	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 600, 400 )
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

    local InventoryIcon = vgui.Create( "DButton", Base )
    InventoryIcon:SetPos( 0, 0 )
    InventoryIcon:SetSize( 50, 50 )
    InventoryIcon:SetText( "" )
    InventoryIcon:SetImage("materials/s-cardealer/inventory.png")
    InventoryIcon.Paint = function() end
    InventoryIcon.DoClick = function() end    

    local StoreIcon = vgui.Create( "DButton", Base )
    StoreIcon:SetPos( 0, 40 )
    StoreIcon:SetSize( 50, 50 )
    StoreIcon:SetText( "" )
    StoreIcon:SetImage("materials/s-cardealer/store.png")
    StoreIcon.Paint = function() end
    StoreIcon.DoClick = function()    
    	net.Start("OpenSCarDealerMenu")
    	net.WriteString("OpenSCarDealerStoreMenu")
    	net.WriteTable(VehicleTable)
    	net.SendToServer()

    	Base:Close()
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

	for k, v in pairs(SCarDealerConfig.Cars) do
		if !table.HasValue(VehicleTable, v.class) then continue end

		local CarInfos = {}
		CarInfos = list.Get("Vehicles")[v.class]

		local Fond = vgui.Create("DPanel", Liste)
        Fond:SetSize(0, 65)
        Fond:DockMargin(0, 0, 0, 5)
        Fond:Dock(TOP)
        Fond:SetText("")
		Fond.Paint = function(self, w,h)
			draw.RoundedBox(5, 0, 0, w, h,Color(230, 92, 78))

			draw.DrawText(CarInfos.Name, "Trebuchet24", 85,20, color_white, TEXT_ALIGN_LEFT)
		end
 
        local Model = vgui.Create("SpawnIcon", Fond)
        Model:SetPos(5, 5)
        Model:SetSize(55, 55)
        Model:SetModel(CarInfos.Model)

        if table.HasValue(VehicleTable, v.class) then
		    local SpawnVehicle = vgui.Create( "DButton", Fond )
		    SpawnVehicle:SetPos( Liste:GetWide()-185, 17 )
		    SpawnVehicle:SetSize( 170, 35 )
		    SpawnVehicle:SetText( "" )
		    SpawnVehicle:SetTextColor(Color(255, 255, 255, 200))
		    SpawnVehicle.OnCursorEntered = function(self) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
		    SpawnVehicle.OnCursorExited = function(self) self.hover = false end
		    SpawnVehicle.Paint = function(self,w,h)
		        draw.RoundedBox(3, 0, 0, w, h-2, Color(0, 0, 0, 50))
		        if self.hover then
		            draw.RoundedBox(3, 0, 0, w, h-1, Color(0, 0, 0, 50))
		            draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 50))
		        end
		        draw.RoundedBox(3, 0, 0, w, h-3,Color( 54, 57, 62, 255 ))

		        draw.DrawText("Spawn", "SlownLSFont20", w / 2 + 0, h / 2 - 13, col, TEXT_ALIGN_CENTER)
		    end
		    SpawnVehicle.DoClick = function()
		    	net.Start("SCarDealerSpawnVehicle")
		    	net.WriteFloat(k)	    	
		    	net.WriteTable(VehicleTable)
		    	net.SendToServer()
		    	
		        Base:Close()
		    end
		end
	end
end)

net.Receive("OpenSCarDealerStoreMenu",function()
	local VehicleTable = net.ReadTable()

	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 600, 400 )
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

    local InventoryIcon = vgui.Create( "DButton", Base )
    InventoryIcon:SetPos( 0, 0 )
    InventoryIcon:SetSize( 50, 50 )
    InventoryIcon:SetText( "" )
    InventoryIcon:SetImage("materials/s-cardealer/inventory.png")
    InventoryIcon.Paint = function() end
    InventoryIcon.DoClick = function()    
    	net.Start("OpenSCarDealerMenu")
    	net.WriteString("OpenSCarDealerInventoryMenu")
    	net.WriteTable(VehicleTable)
    	net.SendToServer()

    	Base:Close()
    end

    local StoreIcon = vgui.Create( "DButton", Base )
    StoreIcon:SetPos( 0, 40 )
    StoreIcon:SetSize( 50, 50 )
    StoreIcon:SetText( "" )
    StoreIcon:SetImage("materials/s-cardealer/store.png")
    StoreIcon.Paint = function() end
    StoreIcon.DoClick = function() end

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

	for k, v in pairs(SCarDealerConfig.Cars) do
		if v.customCheck and !v.customCheck(LocalPlayer()) then continue end
		if table.HasValue(VehicleTable, v.class) then continue end

		local CarInfos = {}
		CarInfos = list.Get("Vehicles")[v.class]

		local Fond = vgui.Create("DPanel", Liste)
        Fond:SetSize(0, 65)
        Fond:DockMargin(0, 0, 0, 5)
        Fond:Dock(TOP)
        Fond:SetText("")
		Fond.Paint = function(self, w,h)
			draw.RoundedBox(5, 0, 0, w, h,Color(230, 92, 78))

			draw.DrawText(CarInfos.Name, "Trebuchet24", 85,20, color_white, TEXT_ALIGN_LEFT)
		end
 
        local Model = vgui.Create("SpawnIcon", Fond)
        Model:SetPos(5, 5)
        Model:SetSize(55, 55)
        Model:SetModel(CarInfos.Model)

        if !table.HasValue(VehicleTable, v.class) then
		    local BuyVehicle = vgui.Create( "DButton", Fond )
		    BuyVehicle:SetPos( Liste:GetWide()-185, 17 )
		    BuyVehicle:SetSize( 170, 35 )
		    BuyVehicle:SetText( "" )
		    BuyVehicle:SetTextColor(Color(255, 255, 255, 200))
		    BuyVehicle.OnCursorEntered = function(self) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
		    BuyVehicle.OnCursorExited = function(self) self.hover = false end
		    BuyVehicle.Paint = function(self,w,h)
		        draw.RoundedBox(3, 0, 0, w, h-2, Color(0, 0, 0, 50))
		        if self.hover then
		            draw.RoundedBox(3, 0, 0, w, h-1, Color(0, 0, 0, 50))
		            draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 50))
		        end
		        draw.RoundedBox(3, 0, 0, w, h-3,Color( 54, 57, 62, 255 ))

		        draw.DrawText("Acheter ("..formatNumber(v.price).."$)", "SlownLSFont20", w / 2 + 0, h / 2 - 13, col, TEXT_ALIGN_CENTER)
		    end
		    BuyVehicle.DoClick = function()
		    	net.Start("SCarDealerPurchaseVehicle")
		    	net.WriteFloat(k)	    	
		    	net.SendToServer()
		    	
		        Base:Close()
		    end
		end
	end
end)