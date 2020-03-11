--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/commonClasses"

local item = require "scripts/lib/item"

local shields = require "scripts/lib/strongerShields"

local shieldLevel = 2
local shieldDesc  = "WoodenShield_desc"

local baseDesc = shields.makeShield(shieldLevel,shieldDesc)

baseDesc.desc = function (self, item)
    return {
        image         = 0,
        imageFile     = "items/shields.png",
        name          = "WoodenShield_name",
        info          = shieldDesc,
        price         = 20 * shieldLevel,
        equipable     = "left_hand",
        upgradable    = true
    }
end

return item.init(baseDesc, poison)--[[

poison = function()
    return RPD.ItemFactory:itemByName("NecroShield")
end]]