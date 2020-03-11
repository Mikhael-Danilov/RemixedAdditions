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
            image         = 15,
            imageFile     = "items/rings.png",
            name          = "BlazingRing_Name",
            info          = "BlazingRing_Desc",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = ACThrow,
            price         = 89*5,
            isArtifact    = true
        }
    end,

    activate = function(self, item, hero)
        self.data.activationCount = (self.data.activationCount or 0) + 1
        RPD.glogp("Your now blazing with fiery.")
        RPD.affectBuff(hero, "BlazingFiery", 10)
        RPD.permanentBuff(hero, RPD.Buffs.Light)
    end,

    deactivate = function(self, item, hero)
        RPD.glogn("Your no longer blazing.")
        RPD.removeBuff(hero,"BlazingFiery")
        RPD.removeBuff(hero,RPD.Buffs.Light)
    end,

    bag = function(self, item)
        return "Keyring"
    end
}
