---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 11/5/19 11:02 PM
---

local RPD = require "scripts/lib/revampedCommonClasses"

local swords = {}

local stats = require "scripts.stats.swords"

local strForLevel = stats.strForLevel

function damageMin (str, swordLevel)
    return math.max(str - 10, 0)
end

function damageMax (str, swordLevel)
    return math.max(str - 10, 0) ^ (1 + swordLevel * 0.1) + swordLevel
end

swords.info = function(baseDesc, item, str, swordLevel, itemLevel)
    local lvl = item:level()
    if lvl == 0 then
        lvl = lvl+1
    end
    local avgDamage = damageMin(str, swordLevel) + damageMax(str, swordLevel)*lvl
    return RPD.textById(baseDesc)
            .. "\n\n"
            .. RPD.textById("WeaponInfo"):format(item:name(),tostring(swordLevel),tostring(avgDamage))
end

swords.makeSword = function(swordLevel, swordDesc)
    return {
        activate = function(self, item, hero)
            item:setDefaultAction(RPD.Actions.unequip)
        end,

        deactivate = function(self, item, hero)
            item:setDefaultAction(RPD.Actions.equip)
        end,

        info = function(self, item)
            local hero = RPD.Dungeon.hero --TODO fix me
            local str  = hero:effectiveSTR()
            return swords.info(swordDesc, item, str, swordLevel, item:level())
        end,

        typicalSTR = function(self, item)
            return strForLevel[swordLevel]
        end,

        requiredSTR = function(self, item)
            return strForLevel[swordLevel]
        end,

        slot = function(self, item, belongings)
            if belongings:slotBlocked("WEAPON") then
                return "LEFT_HAND"
            end
            return "WEAPON"
        end,

        accuracyFactor = function(self, item, user)
            return 1
        end,

        damageRoll = function(self, item, user)
            local str = user:effectiveSTR()
            local lvl = item:level()
            if lvl == 0 then
                lvl = lvl+1
            end
            return math.random(damageMin(str,swordLevel), damageMax(str,swordLevel))*lvl
        end,

        attackDelayFactor = function(self, item, user)
            return 1
        end,

        attackProc = function(self, item, attacker, defender, damage)
            return damage
        end,

        goodForMelee = function(self, item)
            return true
        end
    }
end

return swords