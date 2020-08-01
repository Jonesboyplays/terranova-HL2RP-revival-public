--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local character = ix.meta.character

function character:GetClassName()
    if(self:GetClass()) then
        return ix.class.list[self:GetClass()].name
    end

    return ix.faction.indices[self:GetFaction()].name
end

function character:GetClassScoreboardPriority()
    if(self:GetClass()) then
        return ix.class.list[self:GetClass()].order
    end

    return 10
end


function character:GetClassColor()
    if(self:GetClass()) then
        return ix.class.list[self:GetClass()].color or Color(255,255,255)
    end

    return team.GetColor(self:GetPlayer():Team() or Color(255,255,255))
end 