---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mike.
--- DateTime: 04.08.18 18:14
---

local RPD = require "scripts/lib/commonClasses"
local actor = require "scripts/lib/actor"
local storage = require "scripts/lib/storage"

local Walls = {[0]=true,[4]=true,[12]=true,[16]=true,[35]=true,[36]=true,[43]=true,[44]=true,[45]=true,[46]=true}

return actor.init({
    act = function()
        return true
    end,
    actionTime = function()
        return 1
    end,
    activate = function()
        local level = RPD.Dungeon.level
        local portal = {kind="PortalGateSender",target={levelId="home",x=9,y=3}}
        local portalSet = storage.get("PortalSet") or false
        if not portalSet then
            RPD.createLevelObject(portal,level:cell(level:getWidth()/2,level:getHeight()/2))
            storage.put("PortalSet",true)
        end
        for x = 0, level:getWidth() do
            for y = 0, level:getHeight() do
                if Walls[level.map[level:cell(x,y)]] or (x ~= 8 and y ~= 8) and level.map[level:cell(x,y)] == 7 then
                    level:set(level:cell(x-1,y),1)
                    RPD.GameScene:updateMap()
                end
            end
        end
        level:set(level:getLength()-1,1)
        RPD.GameScene:updateMap()
    end
})