--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Called when we are being hit and need to be scaling limb damage based on various modifiers
function ix.limb.TakeDamage(client, group, info, diff)
    local character = client:GetCharacter()
    local damage = info:GetDamage()
    local damageType = info:GetDamageType()

    if(group > 0 and damage > 0) then
        -- Armor will halve the damage.
        if(client:Armor() - damage > 0) then
            damage = damage * 0.75
        end

        ix.limb.SetHealth(character, group, damage * (diff or 1))

        local health = ix.limb.GetHealth(character, group)

        -- Different damage types can cause different types of wounds
        if(damageType) then
            local limbHitgroup = ix.limb.GetHitgroup(group)
            local canBleed = ix.limb.config.createBleed[damageType] or false
            local canFracture = ix.limb.config.createFracture[damageType] or false

            if(canBleed and (damage * (diff or 1)) >= limbHitgroup.bleedThreshold) then
                ix.limb.SetBleeding(character, group, true)
            end

            if(canFracture and (damage * (diff or 1)) >= limbHitgroup.fractureThreshold) then
                ix.limb.SetFracture(character, group, true)
            end
        end

        -- Called for any plugins that might need to use it
        hook.Run("LimbTakeDamage", client, group, damage, health, info)
    end
end

-- A function to instantly kill the player if their limbs are gone.
function ix.limb.RunDamage(character, hitgroup)
    local limbHP = character:GetLimbHP(hitgroup)
    local limbType = ix.limb.GetName(hitgroup)

    if(limbType == "Chest" or limbType == "Head") then
        if(limbHP >= 0) then
            character:GetPlayer():Kill()
        end
    end
end

-- A function to subtract or add to a limb's health
function ix.limb.SetHealth(character, group, damage)
    local limbs = character:GetLimbs()
    local limb = limbs[group]
    
    if (limb) then
        limb.health = math.Clamp((limb.health or 0) + math.ceil(damage), 0, ix.limb.GetHitgroup(group).maxHealth)
		character:SetLimbs(limbs)
	end
end

-- A function to set the bleed status of a character's limb.
function ix.limb.SetBleeding(character, group, bleeding)
    local limbs = character:GetLimbs()

    if(limbs[group]) then
        limbs[group].bleeding = bleeding

        character:SetLimbs(limbs)

        if(bleeding == false) then
            ix.limb.SetBleedDamage(character, group, 0)
        end
    end
end

-- A function to have different bleed damages.
function ix.limb.SetBleedDamage(character, group, damage)
    local limbs = character:GetLimbs()

    if(limbs) then
        data[group].bleedDamage = damage

        character:SetLimbs(limbs)
    end
end

-- A function to change the fracture status of a character's limb.
function ix.limb.SetFracture(character, group, fracture)
    local limbs = character:GetLimbs()

    if(limbs[group]) then
        limbs[group].fracture = fracture

        character:SetLimbs(limbs)
    end
end

function ix.limb.CreateBloodEffects(pos, decals, entity, fScale)
	if (!entity.limbNextBlood or CurTime() >= entity.limbNextBlood) then
		local effectData = EffectData()
			effectData:SetOrigin(pos)
			effectData:SetEntity(entity)
			effectData:SetStart(pos)
			effectData:SetScale(fScale or 0.5)
		util.Effect("BloodImpact", effectData, true, true)
		
		for i = 1, decals do
			local trace = {}
				trace.start = pos
				trace.endpos = trace.start
				trace.filter = entity
			trace = util.TraceLine(trace)
			
			util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
		
		entity.limbNextBlood = CurTime() + 0.5
	end
end

-- A function to get scale damage.
function ix.limb.GetScaleDamage(group)
    local limb = ix.limb.GetHitgroup(group)

	if (limb) then
		return limb.scale
	end
	
	return 0
end

function ix.limb.BleedTick()
    for _, v in pairs(player.GetAll()) do
        local client = v

        if(IsValid(client) and client:Alive() and client:GetCharacter()) then
            local character = client:GetCharacter()
            local isBleeding, bleedingLimbs = character:GetBleeds()

            if(isBleeding and !client:IsNoclipping()) then
                for k, v in pairs(bleedingLimbs) do
                    local newHealth = client:Health() - 1

                    if(newHealth <= 0) then
                        client:Kill()
                    else
                        client:SetHealth(newHealth)
                    end
                end
            end
        end
    end
end

function ix.limb.FractureTick()
    for k, v in pairs(player.GetAll()) do
        if(!v:GetCharacter() or v:GetCharacter():GetFractures() == false) then
            return
        end

        local client = v
        local character = client:GetCharacter()

		local leftLeg = ix.limb.GetHealthPercentage(client, HITGROUP_LEFTLEG, true) / 100
		local rightLeg = ix.limb.GetHealthPercentage(client, HITGROUP_RIGHTLEG, true) / 100
        local legDamage = leftLeg + rightLeg / 2

        if(legDamage < 0.65) then
            legDamage = 0.65
        end

        local walkSpeed = ix.config.Get("walkSpeed") * legDamage
        local runSpeed = ix.config.Get("runSpeed") * legDamage

        if(legDamage > 0) then
            client:SetWalkSpeed(math.Clamp(walkSpeed, 0, ix.config.Get("walkSpeed")))
            client:SetRunSpeed(math.Clamp(runSpeed, 0, ix.config.Get("runSpeed")))
        end
    end 
end

function ix.limb.ResetMovement(client)
    client:SetWalkSpeed(ix.config.Get("walkSpeed"))
    client:SetRunSpeed(ix.config.Get("runSpeed"))
end

-- A function to reset a player's limb data.
function ix.limb.ResetLimbData(character)
    local limbs = {}	
    
	for i = 1, #ix.limb.hitgroup do
		limbs[i] = {
			health = 0, 
			bleeding = false, 
			fracture = false,
			bleedDamage = 0
		}
	end
	
	character:SetLimbs(limbs)
end