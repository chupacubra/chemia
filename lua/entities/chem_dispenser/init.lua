AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 1,"LastPly" )
  self:NetworkVar("Int",1,"ChemDose")
  self:NetworkVar("Entity",2,"Bucket")
	if ( SERVER ) then
		self:NetworkVarNotify( "LastPly", self.OnVarChanged )
    self:SetChemDose(1)
	end
end

function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
  self:SetUseType(SIMPLE_USE)
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
  self.canins = true
end
 
function ENT:Use( activator, caller )
  net.Start("Chem_ChemDisp")
    net.WriteEntity(self)
  net.Send(activator)
  
  self:SetLastPly(activator)
end

function ENT:Think()
  if self:GetBucket() == Entity(-1) then
    if self.canins then
      for k, v in pairs(ents.FindByClass("bucket")) do
        local dist = self:GetPos():Distance(v:GetPos())
        if (dist <= 64) then
          constraint.NoCollide( self, v, 0, 0 )
          v:SetPos(self:LocalToWorld( Vector(-7,-18,-17.8) ))
          v:SetAngles( self:GetAngles() )
          self.constr = constraint.Weld( self, v, 0, 0, 0,true, false )
          self:SetBucket(v)
        end
      end
    end
  end
end


function ENT:EjectBucket()
  if self:GetBucket() != Entity(-1) then
    self.constr:Remove()
    self:SetBucket(Entity(-1))
    self.canins = false
    timer.Simple( 3, function()
      self.canins = true
    end)
  end
end

net.Receive("Chem_ChemDisp_D",function() 
  local disp = net.ReadEntity()
  local chem = net.ReadString()
  
  if disp:GetBucket() != Entity(-1) then
    CHEMIC:AddComp(chem,disp:GetChemDose(),disp:GetBucket())
    CHEMIC:MixComp(disp:GetBucket())
  end
end)

net.Receive("Chem_ChemDisp_SD",function() 
  local disp = net.ReadEntity()
  local chem = net.ReadInt(10)
  
  disp:SetChemDose(chem)
end)

net.Receive("Chem_ChemDisp_Ej",function()
  local disp = net.ReadEntity()
  disp:EjectBucket()
end)

net.Receive("Chem_ChemDisp_RC",function()
  local disp = net.ReadEntity()
  local chem = net.ReadString()
  
  if disp:GetBucket() != Entity(-1) then
    CHEMIC:AddComp(chem,disp:GetChemDose()*-1,disp:GetBucket())
    CHEMIC:MixComp(disp:GetBucket())
  end
end)