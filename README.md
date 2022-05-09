# HOW TO ADD CHEMICAL

1 GO TO THE `chemical.lua`

2 
```
CHEMIC:New("Name",{
    simpleName = "name",
    callbackInPly = function(comp,ply)
    -- func for ply
    end,
    callBackInMix = function(comp,bucket)
    -- func call in mix (explosion,smoke)
    end,
    activeid = -1, -- testing
    active = function() end, -- testing
    receipt = { -- RECEPT
      inp = {
        comp1 = 1,
        comp2 = 2,
      },
      out = {
        name =  1,
      }
    }
})
```

beaker entity need model from [workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=436256590) and not working. need for test base_container
