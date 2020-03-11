--[[
    Created by mike.
    DateTime: 19.01.19 21:24
    This file is part of pixel-dungeon-remix
]]

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local npc

local dialog = function(index)
    if index == 0 then
        RPD.showQuestWindow(npc, "What's New in v2.\n\nNew Areas:\n  Hero's Home,\n  Crossroads,\n  Desert,\n  Desert Tombs,\n  Shed,\n  Library Attic.\nNew Entities:\n  Cactus Mimic,\n  Sand Worm,\n  Tomb Raider,\n  Tomb Worm,\nWorm Larva,\n  Mummy,\n  Husk,\n  Bone Dragon,\n  Cocker Spaniel (npc and mob),\n  Monika,\n  Guard Dog Keeper.\nNew Items:\n  Catching Capsule,\n  Ultimate Catching Capsule,\n  Old Bandage,\n  Cactus Fruit,\n  Charmful Ring.\nNew Spells:\n  Undead Summon.\nNew Buffs:\n  Charmful,\n  Damage Immune (for npcs).\nNew Ai:\n  Cocker Spaniel.\nNew Actor:\n  Mob Death Counter.\nNew Easter Egg:\n  Involves the snowman by the house that involves a specific class.")
    end

    if index == 1 then
        RPD.showQuestWindow(npc, "Bugs fixed in v2.1\n\nShadow")
    end

    if index == 2 then
        RPD.showQuestWindow(npc, "Credits go to Marshall for the sprites of Shady Man, Old Knight Shield, Board, Light Elemental, Dark Elemental, and Lost Soul.\n\nKrauzxe for the sprites of Ghost Bosses, Bone Dragon, Cocker Spaniel, Mummy, Cactus, Cactus Mimic, Sand Worm, Tomb Worm, Husk, Mutated Spider, Catching Capsule, Ultimate Catching Capsule, Monika, Old Bandage, and Cactus Fruit and helped me with the desert and desert tombs tiles.\n\nSprites by me: Magic Gun, Blazing Ring, Charmful Ring, Blazing Fiery Icon, Charmful Icon, Chef, Elemental Mages, Undead Summon Icon, Elemental Summon Icon, Desert Tiles, and Desert Tomb Tiles.\n\nGabidal.G for the music of Desert and Desert Tombs.")
    end

    if index == 3 then
        RPD.showQuestWindow(npc, "Music Links:\n  Desert Theme: https://www.youtube.com/watch?v=Ae6yeNBgjOg\n  Tomb Theme: https://www.youtube.com/watch?v=HNyPo2WY2nE")
    end
end


return mob.init({
    interact = function(self, chr)
        npc = self

        RPD.chooseOption( dialog,
            "Monika",
            "Hi I'm Monika, The dev of this mod.\nCurrent version of this mod: v2 (aka the Desert Update)",
            "What's New",
            "Bug Fixes",
            "Credits",
            "Links",
            "Bye"
        )
    end,

    spawn = function(self, level)
        RPD.setAi(self, "Monika")
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
