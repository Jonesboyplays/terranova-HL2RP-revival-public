--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Standard-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatc.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A vacuum-sealed ration packet that's only slightly better than it's lesser version."
ITEM.category = "Rations"

ITEM.contains = {
    [1] = {
        uniqueID = "standardgradesupppack",
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
        amount = 30,
        data = {}
	}
}
