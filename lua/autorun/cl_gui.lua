function MakeInforPanel(frame,makehead)
  local panel = vgui.Create("DPanel",frame)
  
  function panel:Paint(w,h)
    
    surface.SetDrawColor(Color(23,23,23))
    surface.DrawRect( 0,0, w, h )
    if makehead != true then
      surface.SetDrawColor(Color(73,114,161))
      surface.DrawLine(  3, 30, w - 6, 30 )
      
      surface.SetDrawColor(Color(255,255,255))
      surface.SetFont( "CloseCaption_Normal" )
      surface.SetTextPos( 5,4) 
      surface.DrawText( self.Header )
    end
  end
  
  function panel:SetHeader(text)
    self.Header = text
  end
  
  return panel
end

function MakeColourButton(frame,selected,entity)
  local but = vgui.Create("DButton",frame)
  but:SetFont( "DermaDefault" )
  but:SetColor(Color(255,255,255))
  function but:IsHovered()
    but:SetColor(Color(255,255,255))
  end
  but.CI = Color( 61,95,135 )
  but.CH = Color( 77,145,33 )
  
  function but:Paint(w,h)
    local col = self.CI
    
    if self:IsDown() then
      col = self.CH
    end
    if selected then
      local int = entity:GetChemDose()
      if int == tonumber(self:GetText()) then
        col = self.CH
      end
    end
    surface.SetDrawColor(col)
    surface.DrawRect( 0, 0, w, h )
  end

  return but
end









--[[local InformPanel = {}


InformPanel.Header = "Header"

function InformPanel:Init()
  self:SetText_Base( "" )
  self:SetText( "debil?" )
end

InformPanel.SetText_Base = FindMetaTable( "Panel" ).SetText


function InformPanel:SetHeader(text)
  self.Header = text
end

function InformPanel:Paint(w,h)
  surface.SetDrawColor(Color(23,23,23))
  surface.DrawRect( 0,0, w, h )
  
  surface.SetDrawColor(Color(73,114,161))
  surface.DrawLine(  3, 30, w - 6, 30 )
  
  surface.SetDrawColor(Color(255,255,255))
	surface.SetFont( "CloseCaption_Normal" )
	surface.SetTextPos( 5,4) 
	surface.DrawText( self.Header )
end
 
vgui.Register("DispPanel", InformPanel, "DPanel")--]]