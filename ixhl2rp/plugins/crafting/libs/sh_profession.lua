--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN;

ix.profession = {}
ix.profession.stored = {}

function ix.profession.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/sh_*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		
		PROFESSION = setmetatable({uniqueID = niceName}, PLUGIN.meta.profession)

		ix.util.Include(directory.."/"..v, "shared")
		ix.profession.stored[niceName] = PROFESSION

		PROFESSION = nil
	end
end

function ix.profession.Get(uniqueID)
	if(ix.profession.stored[uniqueID]) then
		return ix.profession.stored[uniqueID]
	end

	return nil
end

function ix.profession.GetDisplayable()
	local displayable = {}

	for k, v in pairs(ix.profession.stored) do
		if(v:ShouldDisplay()) then
			table.insert(v, displayable)
		end
	end

	return displayable
end

hook.Add("DoPluginIncludes", "ixCrafting", function(path, pluginTable)
	if (!PLUGIN.paths) then
		PLUGIN.paths = {}
	end

	table.insert(PLUGIN.paths, path)
end)
