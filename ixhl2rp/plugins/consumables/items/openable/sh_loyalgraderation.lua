--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Priority-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatp.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "This is a loyalty-grade ration reserved for CWU workers or for those given loyalist status."
ITEM.category = "Rations"
ITEM.contains = {
    [1] = {
        uniqueID = "loyalgradesupppack",
        amount = 1,
        data = {}
    },
    [2] = {
        uniqueID = "unionwater",
        amount = 1,
        data = {}
    },
    [3] = {
        uniqueID = "money"
        amount = 35,
        data = {}
	}
	[4] = {
		uniqueID = "loyalgrademealkit"
		amount = 1,
        data = {}
	}
	[5] = {
		uniqueID = "unionchocolate"
		amount = 1,
		data = {}
	}
}
