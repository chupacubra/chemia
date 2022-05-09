include("shared.lua")

local material =  Material( "sprites/redglow1" )

function ENT:SetupDataTables()
  self:NetworkVar("Bool", 0, "Active")
end

function ENT:Draw()
  if self:GetActive() then
    local pos = self:GetPos()
    cam.Start3D() -- Start the 3D function so we can draw onto the screen.
      render.SetMaterial( material ) -- Tell render what material we want, in this case the flash from the gravgun
      render.DrawSprite( pos, 16, 16, color_red) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
    cam.End3D()
  end
  
  self:DrawModel()
end
