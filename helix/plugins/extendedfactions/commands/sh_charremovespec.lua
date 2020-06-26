--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharRemoveSpec", {
    description = "Removes a certification specialization from a civil protection unit.",
    permission = "Remove spec",
	arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        local character = client:GetCharacter()
        local cert = ix.certs.Get(text)
        local canChangeCert, error = ix.certs.CanChangeCert(character, target, cert)

        if(!cert) then
            if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Remove cert")) then
                if(canChangeCert) then
                    target:SetData("spec", nil)
                else
                    client:Notify(error)
                end
            end
        else
            client:Notify(string.format("The certification '%s' doesn't exist.", text))
        end
	end;
})