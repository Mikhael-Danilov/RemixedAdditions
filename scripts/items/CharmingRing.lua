--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

return item.init{
    desc  = function (self, item)

        return {
            image         = 14,
            imageFile     = "items/rings.png",
            name          = "CharmRing_Name",
            info          = "CharmRing_Desc",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = ACThrow,
            price         = 89*2.5,
            isArtifact    = true
        }
    end,

    activate = function(self, item, hero)
        self.data.activationCount = (self.data.activationCount or 0) + 1
        RPD.glogp("Your now charming.")
        RPD.affectBuff(hero,"Charmful",10)
    end,

    deactivate = function(self, item, hero)
        RPD.glogn("Your no longer charming.")
        RPD.removeBuff(hero,"Charmful")
    end,

    bag = function(self, item)
        return "Keyring"
    end
}
