include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar( "String", 1,"Content" )
end

function ENT:Draw()
  self:DrawModel()
end
 
