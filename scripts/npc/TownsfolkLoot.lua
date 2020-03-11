--
-- User: mike
-- Date: 25.11.2017
-- Time: 22:56
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"

local mob = require"scripts/lib/mob"

local quest = require"scripts/lib/quest"

local npc
local client

local hero = RPD.Dungeon.hero

local questName = "Kill "..RPD.MobFactory:mobByName("Thief"):name().."s"

return mob.init({
    interact = function(self, chr)
        client = chr
        npc = self
        if not quest.isGiven(questName) then
            RPD.showQuestWindow( npc,"Hi adventurer! I need you to kill 25 "..RPD.MobFactory:mobByName("Thief"):name().."s!")
            RPD.Journal:add(npc:name().." "..questName)
            quest.give(questName, npc, {kills={"Thief"}})
            quest.debug(true)
            return
        end

        if quest.isCompleted(questName) then
            RPD.showQuestWindow( npc,"Thank you so much!\nHope you enjoy what was left in that house.")
            quest.debug(true)
            return
        end

        local thiefKilled = quest.state(questName).kills.Thief or 0

        if thiefKilled < 25 then
            RPD.showQuestWindow( npc,thiefKilled.." out of 25 "..RPD.MobFactory:mobByName("Thief"):name().."s killed so far, please keep going!")
        else
            RPD.showQuestWindow( npc,"Great job, Here's your reward!")
            RPD.Journal:remove(npc:name().." "..questName)
            local key = RPD.createItem("IronKey", {levelId="house2",depth=0})
            hero:collect(key)
            local book = RPD.createItem("Codex", {text="abandonedHouse_Info"})
            hero:collect(book)
            RPD.showQuestWindow( npc,"The book that I just gave you I made it to give you info about what that key goes to and what happened.")
            quest.complete(questName)
        end
        quest.debug(true)
    end,

    spawn = function(self, level)
        RPD.permanentBuff(self, "DmgImmune")
    end,
})
