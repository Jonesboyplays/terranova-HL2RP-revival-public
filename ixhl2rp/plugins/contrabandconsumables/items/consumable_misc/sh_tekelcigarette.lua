--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Tekel Cigarette"
ITEM.model = Model("models/phycinnew.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Delicious, authentic lung-killing addiction sticks. There's a little branding on the filter of the cigarette, reading 'TEKEL'."
ITEM.category = "Contraband Consumables Misc"

ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		client:RestoreStamina(12)
	end
}

