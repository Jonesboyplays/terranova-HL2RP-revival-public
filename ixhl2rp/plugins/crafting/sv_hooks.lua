--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

util.AddNetworkString("ixRecipeCraft")

net.Receive("ixRecipeCraft", function(length, client)
    local uniqueID = net.ReadString(16)
    local character = client:GetCharacter()
    local recipe = ix.recipe.Get(uniqueID)
    
    if(!character or !recipe) then
        return
    end

    if(recipe:CanCraft(client)) then
        recipe:OnCraft(client)
    end
end)

local PLUGIN = PLUGIN

-- Called when we need to add a blueprint to a character.
function PLUGIN:AddBlueprint(character, blueprint)
    if(!character:HasBlueprint(blueprint)) then
        local blueprints = character:GetVar("blueprints", {})

        table.insert(blueprints, blueprint)
        character:SetVar("blueprints", blueprints)
    end
end

-- Called when we are setting the mastery of a character.
function PLUGIN:SetMastery(character, uniqueID)
    local profession = ix.profression.Get(uniqueID)

    if(profession) then
        character:SetVar("mastery", uniqueID)
    end
end