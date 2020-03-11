--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local item = require "scripts/lib/item"

local shields = require "scripts/lib/strongerShields"

local shieldLevel = 1
local shieldDesc  = "OldShield_Desc"

local baseDesc = shields.makeShield(shieldLevel,shieldDesc)

baseDesc.desc = function (self, item)
    return {
        image         = 5,
        imageFile     = "items/shields.png",
        name          = "OldShield_Name",
        info          = shieldDesc,
        price         = 15 * shieldLevel,
        equipable     = "left_hand",
        upgradable    = true
    }
end

return item.init(baseDesc)
