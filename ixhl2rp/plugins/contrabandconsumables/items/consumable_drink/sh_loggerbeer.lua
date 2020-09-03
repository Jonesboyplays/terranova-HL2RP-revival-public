--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Logger Beer";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_Logger.mdl";
ITEM.width = 1;
ITEM.height = 2;
ITEM.description = "An obnoxiously branded lager that tastes suprisingly good.";
ITEM.permit = "consumables";
ITEM.price = 10;
ITEM.capacity = 355
ITEM.restoreStamina = 20;
ITEM.category = "Alcohol"
ITEM.flag = "R"
ITEM.tool = "cement_stone"
ITEM.breakdown = {
    [1] = {
        uniqueID = "scrap_glass",
        amount = 1,
        data = {}
    }
}