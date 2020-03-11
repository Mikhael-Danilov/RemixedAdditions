---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 04.08.18 18:14
---

local RPD = require "scripts/lib/revampedCommonClasses"
local actor = require "scripts/lib/actor"
local storage = require "scripts/lib/storage"

return actor.init({
    act = function()
        return true
    end,
    actionTime = function()
        return 1
    end,
    activate = function()
        local level = RPD.Dungeon.level
        local hero = RPD.Dungeon.hero
        local heroClass = hero:className()
        local snowman
        local pos
        local snowmanPlaced = storage.get("SnowmanPlaced") or false
        if heroClass == "Gnoll" then
            snowman = {kind="Deco",object_desc="snowgnoll"}
            pos = level:cell(14,8)
        else
            snowman = {kind="Deco",object_desc="snowman"}
            pos = level:cell(16,8)
        end
        if not snowmanPlaced then
            RPD.createLevelObject(snowman,pos)
            storage.put("SnowmanPlaced", true)
            level:set(pos,4)
            RPD.GameScene:updateMap()
        end
        local levelSize = level:getLength()
        for i = 0 , levelSize - 1 do
            local emitter = RPD.Sfx.CellEmitter:get(i)
            emitter:pour(RPD.Sfx.SnowParticle.FACTORY, 2)
        end
    end
})