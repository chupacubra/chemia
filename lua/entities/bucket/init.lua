AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
--[[
function ENT:SetupDataTables()
	self:NetworkVar( "String", 1,"Content" )
end
--]]
function ENT:Initialize()
	self:SetModel( "models/props_junk/MetalBucket01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
  self:SetUseType(SIMPLE_USE)
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
  self.content = {}
end
--[[
function ENT:Use( activator, caller )
  --PrintTable(self.content)
  CHEMIC:AddComp("water",50,self)
  --CHEMIC:AddComp("potassi",50,self)
  CHEMIC:AddComp("tealeaf",5,self)
  CHEMIC:MixComp(self)
  PrintTable(self.content)
end


function ENT:Think()
  local tbl = FormContent(self)
  local str = ""
  for k,v in pairs(tbl) do
    str= str..k .."="..v.."/"
  end
  self:SetContent(str)
end
-]]