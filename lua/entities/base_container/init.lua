AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar( "String", 1,"Content" )
end

function ENT:Think()
  local tbl = FormContent(self)
  local str = ""
  for k,v in pairs(tbl) do
    str= str..k .."="..v.."/"
  end
  self:SetContent(str)
end
