---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 10/20/19 10:35 PM
---

local RPD  = require "scripts/lib/commonClasses"
local buff = require "scripts/lib/buff"
local shields = require "scripts/lib/strongerShields"
local mob = require "scripts/lib/mob"

return buff.init{
    icon = function(self, buff)
        if self.data.state then
            return 49
        end
        return 50
    end,

    name = function(self, buff)
        if self.data.state then
            return "NecroShieldBuffReady_Name"
        end
        return "NecroShieldBuffNotReady_Name"
    end,

    attachTo = function(self, buff, target)
        self.data.state = self.data.state or false
        return true
    end,

    act = function(self,buff)
        if not self.data.state then
            self.data.state = true
            RPD.BuffIndicator:refreshHero()
        end

        buff:spend(shields.rechargeTime(buff:level(),buff.target:effectiveSTR()))
    end,

    defenceProc = function(self, buff, enemy, damage)
        local chr = buff.target
        if self.data.state then -- shield was ready
            local level = RPD.Dungeon.level
            local lvl = buff:getSource():level() or 0
            local chrKind = enemy:getEntityKind()
            local cell
            if enemy:canBePet() and chrKind ~= "MirrorImage" then
                if math.random(1,100) <= 14 then
                    for i = 1,8 do
                        cell = level:getEmptyCellNextTo(chr:getPos())
                        if not RPD.Actor:findChar(cell) then
                            break
                        end
                    end

                    if level:cellValid(cell) then
                        local mob
                        if math.random(1,100) <= 7 then
                            mob = chrKind
                        else
                            mob = RPD.MobFactory:mobByName("Skeleton")
                        end
                        if mob:getEntityKind() == "Skeleton" then
                            if lvl <= 0 then
                                mob:ht(25)
                            else
                            mob:ht(25*lvl)
                        end
                        mob:hp(mob:ht()-(damage/2))
                        else
                            mob:ht(enemy:ht())
                            mob:hp(enemy:hp()-(damage/2))
                        end
                        mob:makePet(mob, chr)
                        mob:setPos(cell)
                        RPD.setAi(mob, "Wandering")
                        level:spawnMob(mob)
                        RPD.playSound("snd_mimic.mp3")
                        return damage/2
                    end
                end
            end
        end
        return damage
    end,

    attackProc = function(chr, buff, enemy, dmg)
        local chr = buff.target
        local chrKind = enemy:getEntityKind()
        if chr:name() == "you" then
            chr:setSoulPoints(dmg/3)
            chr:hunger():satisfy(dmg/4)
        end
        if enemy:canBePet() and chrKind ~= "MirrorImage" then
            if dmg >= enemy:hp() then
                if math.random(1,100) <= 8 then
                    mob:makePet(enemy, chr)
                    enemy:heal(enemy:ht(), chr)
                    RPD.setAi(enemy, "Wandering")
                    return 0
                end
            end
        end
        return dmg
    end,

    charAct = function(self, buff)
        local chr = buff.target
        if self.data.state then
            if math.random(1,100) <= 11 then
                if chr:name() == "you" then
                    chr:hunger():satisfy(math.random(1,3))
                end
            end
        end
    end
}
