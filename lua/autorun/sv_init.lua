AddCSLuaFile("cl_init.lua")
--AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_button.lua")

include("shared.lua")
include("cl_init.lua")
--include("config.lua")
include("chemicals.lua")

if SERVER then
  util.AddNetworkString("Chem_ChemDisp_GC")
  util.AddNetworkString("Chem_ChemDisp_GC2")
  util.AddNetworkString("Chem_ChemDisp")
  util.AddNetworkString("Chem_ChemDisp_Ej")
  util.AddNetworkString("Chem_ChemDisp_RC")
  util.AddNetworkString("Chem_ChemDisp_D")
  util.AddNetworkString("Chem_ChemDisp_SD")
  util.AddNetworkString("Chem_CLChemicalsList")
end