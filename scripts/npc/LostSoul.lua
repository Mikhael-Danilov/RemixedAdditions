--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

return mob.init({
    interact = function(self, chr)
        RPD.showQuestWindow(self, RPD.textById("NotFinished_text"))
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
