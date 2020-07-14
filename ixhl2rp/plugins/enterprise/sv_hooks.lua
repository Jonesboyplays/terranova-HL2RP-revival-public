--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Enterprise UI information transfer
util.AddNetworkString("ixEnterpriseRequestInformation")
util.AddNetworkString("ixEnterpriseReceiveInformation")
util.AddNetworkString("ixEnterprisePerformAction")
util.AddNetworkString("ixEnterpriseReceiveActionResponse")

-- Character functions
util.AddNetworkString("ixCharacterEnterpriseLeave")

-- Application item derma data transfer
util.AddNetworkString("ixBusinessApplicationUpdate")
util.AddNetworkString("ixBusinessApplicationEdit")

net.Receive("ixEnterpriseRequestInformation", function(length, client)
    local id = net.ReadInt(16)
    local enterprise = ix.enterprise.stored[id]

    if(!enterprise) then
        return
    end

    net.Start("ixEnterpriseReceiveInformation")
        net.WriteTable(enterprise)
    net.Send(client)
end)

net.Receive("ixCharacterEnterpriseLeave", function(length, client)
    local charID = net.ReadInt(16)
    local enterpriseID = net.ReadInt(16)
    local character = client:GetCharacter()
    local enterprise = ix.enterprise.stored[enterpriseID]

    -- Data validation. These values cannot change unless clientside scripts are manipulated.
    if(!character or character:GetID() != charID) then
        return
    end

    if(character:GetEnterprise() != enterpriseID) then
        return
    end

    if(!enterprise) then
        return
    end

    if(enterprise.owner == charID) then
        if(#enterprise.members > 1) then
            client:Notify("You can't leave an enterprise as the owner if there are still members in the enterprise.")

            return
        else
            ix.enterprise.Delete(enterpriseID)
        end
    end

    -- SetEnterprise will update this, but it doesn't do it instantly, and the data must be done instantly. 
    -- So therefore we do it before the operation updates automatically.
    local query = mysql:Select("ix_characters")
        query:Update("enterprise", nil)
        query:Update("enterpriserank", nil)
        query:Where("id", charID)
        query:Limit(1)
    query:Execute()

    character:SetEnterprise(nil)
    character:SetEnterpriseRank(nil)
end)

net.Receive("ixBusinessApplicationUpdate", function(length, client)
    local data = net.ReadTable()

    if (!IsValid(client) or !client:GetCharacter()) then
        return
    end

    local character = client:GetCharacter()
    local item = ix.item.instances[data.id]

    -- Check if the client actually owns this item
    if(!item or item:GetOwner() != client) then
        return
    end

    item:SetData("businessCharID", character:GetID())
    item:SetData("businessOwner", character:GetName())
    item:SetData("businessName", data.name)
    item:SetData("businessDescription", data.description)
    item:SetData("businessPermits", data.permits)
end)