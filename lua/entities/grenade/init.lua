AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
--sprites/redglow1

function ENT:SetupDataTables()
  self:NetworkVar("Bool", 0, "Active")
end

function ENT:Initialize()
	self:SetModel( "models/Items/grenadeAmmo.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
  self:SetUseType(SIMPLE_USE)
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
  self.beakcontent = {}
  self.content = {}
  self.active = false
  self.tickdel = 0
end

function ENT:Use()
  if #self.beakcontent == 2 then
    self:MergeContent()
  else
    
  end
end

function ENT:MergeContent()
  for k,v in pairs(self.beakcontent) do
    for kk,vv in pairs(v) do
      CHEMIC:AddComp(kk,vv:getUnits(),self)
    end
  end
  PrintTable(self.content)
  --print(self:GetActive())
  self:SetActive(true)
  self.tick = CreateSound( self, "weapons/grenade/tick1.wav")
  self.mixtime = CurTime() + 5
  self.active = true
  --self.tick:Play()
end

function ENT:Think()
  if self.active then
    if self.mixtime <= CurTime() then
      CHEMIC:MixComp(self)
      self.active = false
      self:SetActive(false)
    end
    if self.tickdel >= CurTime() then return end
    EmitSound( Sound( "weapons/grenade/tick1.wav" ), self:GetPos(), self:EntIndex() , CHAN_AUTO, 1, 60, 0, 100 )
    self.tickdel = CurTime() + 1
  else
    if #self.beakcontent != 2 then
	  for k, v in pairs(ents.FindInSphere(self:GetPos(),16)) do
        if v:GetClass() == "bucket" or v:GetClass() == "beaker" then
          table.insert(self.beakcontent,v.content)
          v:Remove()
        end
      end
    end
  end
end
