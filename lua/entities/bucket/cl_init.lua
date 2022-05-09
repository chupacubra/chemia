include('shared.lua')

function ENT:SetupDataTables()
	self:NetworkVar( "String", 1,"Content" )
end

function ENT:Draw()
  self:DrawModel()
end

local mat = Material( "editor/wireframe" ) -- The material (a wireframe)
local obj = Mesh() -- Create the IMesh object

local verts = { -- A table of 3 vertices that form a triangle
	{ pos = Vector( 0,  0,  0 ), u = 0, v = 0 }, -- Vertex 1
	{ pos = Vector( 10, 0,  0 ), u = 1, v = 0 }, -- Vertex 2
	{ pos = Vector( 10, 10, 0 ), u = 1, v = 1 }, -- Vertex 3
	{ pos = Vector( 10, 0, 10 ), u = 1, v = 1 }, -- Vertex 3
	{ pos = Vector( 0, 20, 10 ), u = 1, v = 0 }, -- Vertex 3
}

mesh.Begin( obj, MATERIAL_TRIANGLES, 1 ) -- Begin writing to the static mesh
for i = 1, #verts do
	mesh.Position( verts[i].pos ) -- Set the position
	mesh.TexCoord( 0, verts[i].u, verts[i].v ) -- Set the texture UV coordinates
	mesh.AdvanceVertex() -- Write the vertex
end
mesh.End() -- Finish writing to the IMesh

hook.Add( "PostDrawOpaqueRenderables", "MeshLibTest", function()

	render.SetMaterial( mat ) -- Apply the material
	obj:Draw() -- Draw the mesh
end )
 
