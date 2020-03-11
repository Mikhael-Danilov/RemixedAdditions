--
-- User: mike
-- Date: 29.01.2019
-- Time: 20:33
-- This file is part of Remixed Pixel Dungeon.
--

local RPD = require "scripts/lib/revampedCommonClasses"
local item = require "scripts/lib/item"
local mob = require "scripts/lib/mob"
local quest = require "scripts/lib/quest"
local storage = require "scripts/lib/storage"

local mob
local DeathCounter = "DeathCounter"
local Mobs = {"Rat","Gnoll","Albino","Mimic","MimicPie","MimicAmulet","TombRaider","SandWorm","TombWorm","BoneDragon","Goo","Tengu","CactusMimic","Wraith","TempMoney","Shopkeeper","CockerSpaniel","CockerSpanielNPC","BlackCat","BlackCatNPC"}
local summon

return item.init{
    desc  = function (self, item)

        return {
            image         = 5,
            imageFile     = "items/rings.png",
            name          = "Testing Item",
            info          = "Item for tests and target dummies.",
            stackable     = false,
            upgradable    = false,
            identified    = true,
            defaultAction = "Get Level Data",
            price         = 0
        }
    end,
    actions = function(self, item, hero)
        if not storage.get("MobData") then
            storage.put("MobData",{class="Nothing",name="Nothing",ai=nil,ht=nil,hp=nil})
        end
        if not summon then
            summon = storage.get("MobData")
        end
        local godMode
        if hero:buffLevel("GodMode") > 0 then
            godMode = "Turn off God Mode"
        else
            godMode = "Turn on God Mode"
        end
        return {"Get Level Data","Get Mob Data","Get Specific Mob Data","Summon Money Giver","Summon Target","Summon Shopkeeper","Summon Pet","Summon "..summon.name,"Hurt Everything","Tp to Yog","Tp to Bone Dragon","Tp to Test Level",godMode,"Death Counter"}
    end,

    cellSelected = function(self, item, action, cell)
        if action == "Get Specific Mob Data" then
            local level = RPD.Dungeon.level
            local target = RPD.Actor:findChar(cell)
            if target then
                if target ~= item:getUser() then
                    RPD.glog("Mob: "..target:name()..",\nMob Id: "..tostring(target:getId())..",\nMob Class: "..target:getMobClassName()..",\nAi State: "..tostring(target:getState())..",\nAi State Tag: "..tostring(target:getState():getTag())..",\nHt: "..tostring(target:ht()).."\nHp: "..tostring(target:hp())..",\nPos X: "..tostring(level:cellX(target:getPos()))..",\nPos Y: "..tostring(level:cellY(target:getPos()))..",\nOwner Id: "..tostring(target:getOwnerId()))
                    storage.put("MobData",{class=target:getMobClassName(),name=target:name(),ai=tostring(target:getState():getTag()),ht=target:ht(),hp=target:hp()})
                    summon = storage.get("MobData")
                else
                    RPD.glog("Mob: "..target:name()..",\nClass Name: "..target:className()..",\nLevel: "..target:lvl()..",\nHt: "..tostring(target:ht()).."\nHp: "..tostring(target:hp())..",\nMt: "..tostring(target:getSkillPointsMax())..",\nMp: "..tostring(target:getSkillPoints())..",\nStr: "..tostring(target:STR())..",\nDr: "..tostring(target:dr())..",\nPos X: "..tostring(level:cellX(target:getPos()))..",\nPos Y: "..tostring(level:cellY(target:getPos())))
                end
            end
        end
    end,

    execute = function(self, item, hero, action)
        local hero = RPD.Dungeon.hero
        local levelId = RPD.Dungeon.levelId
        local level = RPD.Dungeon.level
        local cellPos = RPD.getXy(hero)

        if action == "Get Level Data" then
            RPD.glog("Level: "..tostring(level)..",\nLevel ID: "..tostring(levelId)..",\nCell X: "..cellPos[1]..",\nCell Y: "..cellPos[2]..",\nMax Width: "..level:getWidth()..",\nMax Height: "..level:getHeight())
        end

        if action == "Get Mob Data" then
            local level = RPD.Dungeon.level
            local target
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() then
                            RPD.glog("Mob: "..target:name()..",\nMob Id: "..tostring(target:getId())..",\nMob Class: "..target:getMobClassName()..",\nAi State: "..tostring(target:getState())..",\nAi State Tag: "..tostring(target:getState():getTag())..",\nHt: "..tostring(target:ht()).."\nHp: "..tostring(target:hp())..",\nPos X: "..tostring(level:cellX(target:getPos()))..",\nPos Y: "..tostring(level:cellY(target:getPos()))..",\nOwner Id: "..tostring(target:getOwnerId()))
                            storage.put("MobData",{class=target:getMobClassName(),name=target:name(),ai=tostring(target:getState():getTag()),ht=target:ht(),hp=target:hp()})
                            summon = storage.get("MobData")
                        else
                            RPD.glog("Mob: "..target:name()..",\nClass Name: "..target:className()..",\nLevel: "..target:lvl()..",\nHt: "..tostring(target:ht()).."\nHp: "..tostring(target:hp())..",\nMt: "..tostring(target:getSkillPointsMax())..",\nMp: "..tostring(target:getSkillPoints())..",\nStr: "..tostring(target:STR())..",\nDr: "..tostring(target:dr())..",\nPos X: "..tostring(level:cellX(target:getPos()))..",\nPos Y: "..tostring(level:cellY(target:getPos())))
                        end
                    end
                end
            end
        end

        if action == "Get Specific Mob Data" then
            item:selectCell(action, "Get Mob Data")
        end

        if action == "Summon Money Giver" then
            local cell = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(cell) then
                mob = RPD.MobFactory:mobByName("TempMoney")
                mob:setPos(cell)
                RPD.setAi(mob, "Wandering")
                level:spawnMob(mob)
                RPD.glogp("Summoned Money Giver.")
                return true
            end
            RPD.glogn("There's not enough space for the summon.")
            return false
        end

        if action == "Summon Target" then
            local cell = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(cell) then
                mob = RPD.MobFactory:mobByName("MazeShadow")
                mob:setPos(cell)
                mob:ht(2^31-1)
                mob:hp(mob:ht())
                RPD.permanentBuff(mob, RPD.Buffs.Roots)
                RPD.setAi(mob, "Wandering")
                level:spawnMob(mob)
                RPD.glogp("Summoned Target.")
                return true
            end
            RPD.glogn("There's not enough space for the summon.")
            return false
        end

        if action == "Summon Shopkeeper" then
            local cell = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(cell) then
                mob = RPD.MobFactory:mobByName("Shopkeeper")
                mob:setPos(cell)
                RPD.setAi(mob, "Wandering")
                level:spawnMob(mob)
                RPD.glogp("Summoned Shopkeeper.")
                return true
            end
            RPD.glogn("There's not enough space for the summon.")
            return false
        end

        if action == "Summon Pet" then
            local cell = level:getEmptyCellNextTo(hero:getPos())
            if level:cellValid(cell) then
                mob = RPD.MobFactory:mobByName("MazeShadow")
                mob:setPos(cell)
                mob:makePet(mob, hero)
                RPD.setAi(mob, "Wandering")
                level:spawnMob(mob)
                RPD.glogp("Summoned Pet.")
                return true
            end
            RPD.glogn("There's not enough space for the summon.")
            return false
        end

        if summon then
            if action == "Summon "..summon.name then
                if summon.class == "Nothing" then
                    RPD.glogn("There's nothing to summon.")
                    return true
                end
                local cell = level:getEmptyCellNextTo(hero:getPos())
                if level:cellValid(cell) then
                    mob = RPD.MobFactory:mobByName(summon.class)
                    mob:setPos(cell)
                    level:spawnMob(mob)
                    RPD.glogp("Summoned "..summon.name)
                    return true
                end
                RPD.glogn("There's not enough space for the summon.")
                return false
            end
        end

        if action == "Hurt Everything" then
            for x = 0, level:getWidth() do
                for y = 0, level:getHeight() do
                    local target = RPD.Actor:findChar(level:cell(x,y))
                    if target then
                        if target ~= item:getUser() and not target:isPet() then
                            target:damage(target:hp()-1, item:getUser())
                        end
                    end
                end
            end
        end

        if action == "Tp to Yog" then
            local portal = {kind="PortalGateSender",target={levelId="31",x=16,y=16}}
            RPD.createLevelObject(portal, hero:getPos())
        end

        if action == "Tp to Bone Dragon" then
            local portal = {kind="PortalGateSender",target={levelId="tombFinal",x=7,y=11}}
            RPD.createLevelObject(portal, hero:getPos())
        end

        if action == "Tp to Test Level" then
            local portal = {kind="PortalGateSender",target={levelId="testLevel"}}
            RPD.createLevelObject(portal, hero:getPos())
        end

        if action == "Turn on God Mode" then
            RPD.permanentBuff(hero, "GodMode")
            RPD.glogp("Enabled God Mode.")
        end

        if action == "Turn off God Mode" then
            RPD.removeBuff(hero, "GodMode")
            RPD.glogn("Disabled God Mode.")
        end

        if action == "Death Counter" then
            for i = 1, #Mobs do
                if storage.get(Mobs[i].." kills") then
                    RPD.glog(Mobs[i].." kills: "..tostring(storage.get(Mobs[i].." kills")))
                else
                    RPD.glog(Mobs[i].." kills: 0")
                end
            end
        end
    end,

    bag = function(self, item)
        return "Keyring"
    end
}
