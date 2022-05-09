
local ChemBtn = {}
ChemBtn.text = "Button"
ChemBtn.CI = Color( 61,95,135 )
ChemBtn.CH = Color( 77,145,33 )

function ChemBtn:Init()
  self:SetText_Base( "" )
  self:SetText( "debil?" )
end

function ChemBtn:Paint(w,h)
  local col = self.CI
  
  if self:IsDown() then
    col = self.CH
  end
  surface.SetDrawColor(col)
  surface.DrawRect( 0, 0, w, h )
  surface.SetFont( "DermaDefault" )
  
  --surface.SetDrawColor(Color(255,255,255))

  surface.SetTextColor(Color(255,255,255))
  surface.SetTextPos(5,4) 
	surface.DrawText( self.Text )
  --]]
end

ChemBtn.SetText_Base = FindMetaTable( "Panel" ).SetText

function ChemBtn:SetText(text)
  ChemBtn.Text = text
end 
vgui.Register("DispButton", ChemBtn, "DButton")
vgui.Register("DispButton2", ChemBtn, "DButton")