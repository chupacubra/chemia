ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Chemical Dispenser"
ENT.Author			= "Ricky26"
ENT.Contact			= "Don't"
ENT.Purpose			= "Exemplar material"
ENT.Instructions	= "Use with care. Always handle with gloves."
ENT.Spawnable = true
ENT.Category = "Chemia"

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 1, "LastPly" )
	if ( SERVER ) then
		self:NetworkVarNotify( "LastPly", self.OnVarChanged )
	end
end