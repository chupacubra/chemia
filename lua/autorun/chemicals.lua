CHEMICALS = {} -- all components
CHEMIC    = CHEMIC or {} -- for func
RECEIPTS  = {} -- all receipts
FAST_REC  = {} -- FAST receipts without perebor
FOR_CL    = {} -- information about chemicals for clients
chem = {}

function CHEMIC:AddComp(name,unit,bucket)
    if !CHEMICALS[name] or !bucket then
      return
    end
    --PrintTable(bucket.content)
    if bucket.content[name] then
      bucket.content[name]:AddUnit(unit)
      return
    elseif bucket.content[name] == nil and unit > 1 then
      
    end
    
    if unit < 1 then
      return
    end
    
    local obj = {}
    --obj.data = CHEMICALS["data"]
    obj.unit = unit
    obj.name = name
    obj.fm   = false
    
    function obj:getName()
      return self.name
    end
    
    function obj:getUnits()
      return self.unit
    end
    
    function obj:AddUnit(int)
      self.unit = self.unit + int
      if self.unit < 1 then
        bucket.content[name] = nil
        return
      end
    end
    
    function obj:OnPlyClbck(ply)
      CHEMICALS[self:getName()]["callbackInPly"](self,ply)
    end
    
    function obj:OnFirstMix(bucket)
      if self.fm then
        return
      end
      CHEMICALS[self:getName()]["callBackInMix"](self,bucket)
      self.fm = true
    end
    
    setmetatable(obj, self)
    self.__index = self; bucket.content[name] = obj
end

function CHEMIC:New(name,data --[[{simpleName,callbackInPly,callBackInMix,receipt}--]])
  CHEMICALS[data["simpleName"]] = {
    simpleName    = data["simpleName"],
    normalName    = name,
    callbackInPly = data["callbackInPly"],
    callBackInMix = data["callBackInMix"],
    activeid      = data["activeid"],
    active        = data["active"],
    notdispense   = data["notdispense"] or false
  }
  if data["receipt"] then
    RECEIPTS[data["simpleName"]] = data["receipt"]
  end

end

function list_length( t )
 
    local len = 0
    for _,_ in pairs( t ) do
        len = len + 1
    end
 
    return len
end

local function CanMake(have,need)
  local count = list_length(need)
  for k,v in pairs(need) do
    if have[k] == nil then
      return false
    elseif have[k] >= need[k] then
      count = count - 1
    else
      return false
    end
  end
  if count == 0 then
    return true
  end
end

function FormContent(bucket)
  local arr = {}
  for k,v in pairs(bucket.content) do
    arr[k] = v:getUnits()
  end
  return arr
end

function CHEMIC:MixComp(bucket)
  local finalcomp = {}
  for k,v in pairs(bucket.content) do
    if FAST_REC[k] then
      for kk,vv in pairs(FAST_REC[k]) do
        local count = 0
        --FormContent(bucket)
        local recept = RECEIPTS[kk]
        if CanMake(FormContent(bucket),recept["inp"]) then
          while CanMake(FormContent(bucket),recept["inp"]) != false do
            for kkk,vvv in pairs(recept["inp"]) do
              bucket.content[kkk]:AddUnit(vvv * -1)
            end
            count = count + 1
          end
          for i = 1,count do
            for kkk,vvv in pairs(recept["out"]) do
              CHEMIC:AddComp(kkk,vvv,bucket)
              finalcomp[kkk] = true
              --bucket.content[kkk]:OnFirstMix(bucket)
              
            end
          end
          CHEMIC:MixComp(bucket)
          --return
        end
      end
    end
  end
  PrintTable(finalcomp)
  for k,v in pairs(finalcomp) do
    if bucket.content[k] then
      bucket.content[k]:OnFirstMix(bucket)
    end
  end
end

CHEMIC:New("Oxygen",{
    simpleName = "oxygen",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Nitrogen",{
    simpleName = "nitrogen",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Sugar",{
    simpleName = "sugar",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Hydrogen",{
    simpleName = "hydrogen",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Phosphorus",{
    simpleName = "phosphorus",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Saltpetre",{
    simpleName = "saltpetre",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
    receipt = {
      inp = {
        oxygen = 3,
        nitrogen = 1,
        potassium = 1,
      },
      out = {
        saltpetre =  1,
      }
    }
})

CHEMIC:New("Water",{
    simpleName = "water",
    normalName = "Water",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
    receipt = {
      inp = {
        oxygen = 1,
        hydrogen = 2,
      },
      out = {
        water =  1,
      }
    }
})

CHEMIC:New("Tea",{
    simpleName = "tea",
    normalName = "Tea",
    callbackInPly = function() end,
    callBackInMix = function(comp,bucket)
      for k, v in pairs(ents.FindByClass("player")) do
        local dist = v:GetPos():Distance(v:GetPos())
        if (dist <= 64) then
          v:ChatPrint( "Запахло чаем..." )
        end
      end
    end,
    activeid = -1,
    active = function() end,
    receipt = {
      inp = {
        water = 1,
        tealeaf = 1,
      },
      out = {
        tea =  1,
      },
      notdispense = true
    }
})

CHEMIC:New("Tea leaf",{
    simpleName = "tealeaf",
    normalName = "Tea leaf" ,
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Potassium",{
    simpleName = "potassium",
    callbackInPly = function() end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Toxin",{
    simpleName = "toxin",
    callbackInPly = function(comp,ply)
      ply:TakeDamage( 4, Entity(0), Entity(0))
    end,
    callBackInMix = function() end,
    activeid = -1,
    active = function() end,
})

CHEMIC:New("Explosion",{
    simpleName = "explosion",
    callbackInPly = function() end,
    callBackInMix = function(comp,bucket)
      local val = comp:getUnits()
      local effectdata = EffectData()
      effectdata:SetOrigin( bucket:GetPos() )
      util.Effect( "HelicopterMegaBomb", effectdata )	 -- Big flame
      
      local explo = ents.Create( "env_explosion" )
        --explo:SetOwner(  )
        explo:SetPos( bucket:GetPos())
        explo:SetKeyValue( "iMagnitude",val)
        --CEffectData:SetRadius( number radius )
        explo:Spawn()
        explo:Activate()
        explo:Fire( "Explode", "", 0 )
      
      
      local shake = ents.Create( "env_shake" )
        shake:SetOwner( bucket.Owner )
        shake:SetPos( bucket:GetPos())
        shake:SetKeyValue( "amplitude", tostring(100 * val) )	-- Power of the shake
        shake:SetKeyValue( "radius", tostring(100 * val))	-- Radius of the shake
        shake:SetKeyValue( "duration", "2.5" )	-- Time of shake
        shake:SetKeyValue( "frequency", "1000" )	-- How har should the screenshake be
        shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
        shake:Spawn()
        shake:Activate()
        shake:Fire( "StartShake", "", 0 )
      
      local ar2Explo = ents.Create( "env_ar2explosion" )
        --ar2Explo:SetOwner( self.GrenadeOwner )
        ar2Explo:SetPos( bucket:GetPos())
        ar2Explo:Spawn()
        ar2Explo:Activate()
        ar2Explo:Fire( "Explode", "", 0 )

      for k, v in pairs ( ents.FindInSphere( bucket:GetPos(), 500 ) ) do
        v:Fire( "EnableMotion", "", math.random( 0, 0.5 ) )
      end
      bucket:Remove()
    end,
    receipt = {
      inp = {
        water = 1,
        potassium = 1,
      },
      out = {
        explosion = 1,
      }
    },
    activeid = -1,
    active = function() end,
    notdispense = true
})

CHEMIC:New("Smoke",{
    simpleName = "smoke",
    callbackInPly = function(comp,ply)
      local i = math.random(1,4)
      EmitSound( Sound( "ambient/voices/cough"..i..".wav" ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
    end,
    callBackInMix = function(comp,bucket)
      local val = comp:getUnits()
        
      exp = ents.Create("env_smoketrail")
      exp:SetKeyValue("startsize","700")
      exp:SetKeyValue("endsize","200")
      exp:SetKeyValue("spawnradius","200")
      exp:SetKeyValue("minspeed","0.1")
      exp:SetKeyValue("maxspeed","0.5")
      exp:SetKeyValue("startcolor","100 100 100")
      exp:SetKeyValue("endcolor","155 155 155")
      exp:SetKeyValue("opacity","1")
      exp:SetKeyValue("spawnrate","15")
      exp:SetKeyValue("lifetime","15")
      exp:SetPos(bucket:GetPos())
      exp:SetParent(bucket)
      
      local smoke = ents.Create( "smoke" )
      smoke:SetPos( bucket:GetPos())
      smoke:SetParent(bucket)
      smoke:Spawn()
      local endtime = CurTime() + 15
      local delay  = 0
      function smoke:Think()
        --print("sdsd")
        if endtime <= CurTime() then
          smoke:Remove()
          return
        end
        if delay >= CurTime() then return end
        delay = CurTime() + 2
        
        for k, v in pairs(ents.FindInSphere( bucket:GetPos(), 300 )) do
          if v:GetClass() != "player" then 
            continue 
          end
          for kk,vv in pairs(bucket.content) do
            vv:OnPlyClbck(v)
          end
        end
      end
      exp:Spawn()
      
      --local delay = 0

      exp:Fire("kill","",15)
    end,
    receipt = {
      inp = {
        phosphorus = 1,
        potassium = 1,
        sugar = 1,
      },
      out = {
        smoke = 1,
      }
    },
    activeid = -1,
    active = function() end,
    notdispense = true
})

if SERVER then
  for k,v in pairs(CHEMICALS) do
    for kk,vv in pairs(RECEIPTS) do
      if RECEIPTS[kk]["inp"][k] then
        if !FAST_REC[k] then FAST_REC[k] = {} end
        FAST_REC[k][kk] = true
      end
    end
  end

  local cl_chem = {}
  for k,v in pairs(CHEMICALS) do
    if v["notdispense"] == true then
    else
      cl_chem[k] = v["normalName"]
    end
  end
  
  timer.Simple( 5, function()
    net.Start("Chem_CLChemicalsList")
      local int = tonumber(list_length(cl_chem))
      net.WriteInt(int,10)
      for k,v in pairs(cl_chem) do
        net.WriteString(k.."/"..v)
      end
    net.Broadcast()
  end)

  PrintTable(CHEMIC)
  PrintTable(FAST_REC)
end