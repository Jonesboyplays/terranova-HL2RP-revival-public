local CHAR = ix.meta.character

function CHAR:IsCombine()
	local faction = self:GetPlayer():Team();
	local isCombine = (faction == FACTION_OTA or faction == FACTION_SCN);

	if(faction == FACTION_MPF and !self:IsUndercover()) then
		isCombine = true;
	end;

	return isCombine;
end

function CHAR:IsUndercover()
	if(self:GetClass() != nil) then 
		if(self:GetFaction() == FACTION_MPF and self:GetClassName() == "Metropolice Unit Undercover") then
			return true;
		else
			return false;
		end;
	else
		return false;
	end;
end;

-- Returns if a character is a part of the MPF faction.
function CHAR:IsMetropolice()
    if(self:GetFaction() == FACTION_MPF) then
        return true;
    else
        return false;
    end;
end;

-- Called when a character has had data changed
function CHAR:UpdateCPStatus()
    local cpData = self:GetCPInfo()

    if(!self:IsUndercover()) then
        self:SetName(self:GetCPName());
		self:SetupRankBodygroups()
    elseif(self:IsUndercover() and self:GetName() != cpData.cpCitizenName) then
        self:SetName(cpData.cpCitizenName);
    end;
end;

-- Returns all of the plugin's character data as a single table
function CHAR:GetCPInfo(fullData)
    local data = {}

    if(self:IsMetropolice()) then 
		data.cpID = self:GetData("cpID");
        data.cpTagline = self:GetData("cpTagline");
	    data.cpDesc = self:GetData("cpDesc");
        data.cpCitizenName = self:GetData("cpCitizenName");
		data.cpCitizenDesc = self:GetData("cpCitizenDesc");
		data.rank = self:GetData("rank");
		data.spec = self:GetData("spec")
		data.certs = self:GetData("certs")
	end;
	
	-- Sometimes this whole table is netstreamed, seperate less essential (but expensive) data if we dont need it.
	if(fullData) then
		data.rankObject = self:GetRank()
		data.fullTagline = self:GetCPTagline()
	end 
    
    return data;
end;

-- Returns full civil protection name as a single string
function CHAR:GetCPName()
    local template = ix.config.Get("Naming Scheme");
    
	replacements = {
		["city"] = ix.config.Get("City Name"),
        ["abbreviation"] = ix.config.Get("Abbreviation"),
        ["division"] = self:GetData("cpDivision"),
		["rank"] = self:GetData("rank"),
		["tagline"] = self:GetData("cpTagline"),
		["id"] = self:GetData("cpID")
    }

    local name = string.gsub(template, "%a+", 
	function(str)
		return replacements[str];
    end)
    
    return name;
end;

-- Returns tagline and id together as a single string
function CHAR:GetCPTagline()
    return string.match(self:GetCPName(), self:GetData("cpTagline")..'.-$');
end;
