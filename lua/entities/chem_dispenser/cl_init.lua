include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 1, "LastPly" )
  self:NetworkVar("Int",1,"ChemDose")
  self:NetworkVar("Entity",2,"Bucket")
end

function ENT:Draw()
  self:DrawModel()
end
 
net.Receive("Chem_ChemDisp",function()
  local cont = {}
  local cnstr = ""
  disp = net.ReadEntity()
  local dose ={1,5,10,20,30,50,100}
  local Frame = vgui.Create( "DFrame" )
  Frame:SetPos( 5, 5 ) 
  Frame:SetSize( 300, 500 ) 
  Frame:SetTitle( "ChemDispenser-25000" ) 
  Frame:SetVisible( true ) 
  Frame:SetDraggable( true ) 
  Frame:ShowCloseButton( true ) 
  Frame:MakePopup()
  
  local DPanel = vgui.Create( "DPanel",Frame )
  DPanel:SetPos( 1, 25 )
  DPanel:SetSize( 298, 500 )
  DPanel:SetBackgroundColor(Color(54,54,54))
  
  local SetPanel = MakeInforPanel(DPanel)
  SetPanel:SetHeader("Setting")
  SetPanel:SetPos(3,5)
  SetPanel:SetSize(292,65)
  
  local DispPanel = MakeInforPanel(DPanel)
  DispPanel:SetHeader("Dispense")
  DispPanel:SetPos(3,75)
  DispPanel:SetSize(292,200)
  
  local grid = vgui.Create( "DGrid", DispPanel )
  grid:SetPos( 10, 40 )
  grid:SetCols( 3 )
  grid:SetColWide( 100 )
  
  local grid2 = vgui.Create( "DGrid", SetPanel )
  grid2:SetPos( 10, 40 )
  grid2:SetCols( 7 )
  grid2:SetColWide( 35 )
  
  
  for k,v in pairs(dose) do
    local but = MakeColourButton(panel,true,disp)
    but:SetText( v )
    but:SetSize( 20, 20 )
    
  	function but:DoClick()
      -- Chem_ChemDisp_SD
      net.Start("Chem_ChemDisp_SD")
        net.WriteEntity(disp)
        net.WriteInt(tonumber(v),10)
      net.SendToServer()
    end
    grid2:AddItem( but )
  end
  
  for k,v in pairs(GL_CLIENT_CHEM) do
    local but = MakeColourButton(panel)
    but:SetText( v )
    but:SetSize( 75, 20 )
  	function but:DoClick()
      net.Start("Chem_ChemDisp_D")
        net.WriteEntity(disp)
        net.WriteString(k)
      net.SendToServer()
    end
    grid:AddItem( but )
  end
    function DPanel:Think()
      if disp:GetBucket() != Entity(-1) then
        local gcont = {}
        local cstr = disp:GetBucket():GetContent()
        for k,v in pairs(string.Explode("/",cstr)) do
          local tbl = string.Explode("=",v)
          if tbl[1] != nil or tbl[1] != "" then
            gcont[tbl[1]] = tbl[2]
          end
        end
          
        if cstr != cnstr then
          cnstr = cstr
          cont = gcont
          local AppList = vgui.Create( "DListView", DPanel )
          AppList:SetPos(3,280)
          AppList:SetSize(292,155)
          AppList:SetDataHeight( 25 )
          AppList:SetMultiSelect( false )
          AppList:SetHideHeaders( true )
          AppList:AddColumn( "Chemical" )
          AppList:AddColumn( "Units" )
          for k,v in pairs(cont) do
            AppList:AddLine( k, v )
          end
          
          for k,v in pairs(AppList:GetLines())do
            v:SetColumnText( 1, v:GetColumnText( 1 ) ):SetTextColor(Color(255,255,255))
            v:SetColumnText( 2, v:GetColumnText( 2 ) ):SetTextColor(Color(255,255,255))
          end
          
          function AppList:Paint(w,h)
            surface.SetDrawColor(Color(23,23,23))
            surface.DrawRect( 0,0, w, h )
          end
          AppList.OnRowSelected = function( lst, index, pnl )
            net.Start("Chem_ChemDisp_RC")
              net.WriteEntity(disp)
              net.WriteString(pnl:GetColumnText(1))
            net.SendToServer()
          end
        end
      end
    end
      local ejb = MakeColourButton(DPanel)
      ejb:SetText("Eject")
      ejb:SizeToContentsX( 40 )
      ejb:SetSize(50, 25)
      ejb:SetPos(245,440)
      
      function ejb:DoClick()
        net.Start("Chem_ChemDisp_Ej")
          net.WriteEntity(disp)
        net.SendToServer()
      end
      
end)
