--[[
Name: LibNameplate-1.0
Author(s): Cyprias (cyprias@gmail.com)
Documentation: http://www.wowace.com/addons/libnameplate-1-0/pages/main/
SVN:  svn://svn.wowace.com/wow/libnameplate-1-0/mainline/trunk
Description: Alerts addons when a nameplate is shown or hidden. Has API to get info such as name, level, class, ect from the nameplate. LibNameplate tries to function with the default nameplates, Aloft, caelNamePlates and TidyPlates (buggy).
Dependencies: LibStub, CallbackHandler-1.0
]]

--[[
	Todo

	Notes
		- hooking plates OnEnter requires the plates enable mouse. But doing that stops the mouseover ID being available. 
]]

local MAJOR, MINOR = "LibNameplate-1.0", 14
if not LibStub then error(MAJOR .. " requires LibStub.") return end

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
if not lib.callbacks then	error(MAJOR .. " CallbackHandler-1.0.") return end

-- Globals
local _G					= _G
local tostring				= tostring
local WorldFrame			= WorldFrame
local select				= select
local UnitExists			= UnitExists
local UnitGUID				= UnitGUID
local UnitName				= UnitName
local pairs					= pairs
local table_insert			= table.insert
local GetMouseFocus			= GetMouseFocus
local GetNumRaidMembers		= GetNumRaidMembers
local GetNumPartyMembers	= GetNumPartyMembers
local UnitIsUnit			= UnitIsUnit
local GetRaidTargetIndex	= GetRaidTargetIndex
local print					= print
local table_getn			= table.getn
local _ --localized underscore so FindGlobals doesn't bug me about it.
local IsAddOnLoaded			= IsAddOnLoaded
local unpack = unpack
local math_floor = math.floor
local tonumber = tonumber
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitClass = UnitClass
local UnitInRange = UnitInRange


--Conts
local scanDelay		= 1 -- Scan for new nameplates every 1 seconds. We hook OnShow so this doesn't need to be done rapidly.
local updateDelay	= 1 -- Update nameplate info every 1 seconds. This checks if a nameplate has a raid icon then trys to find the GUID to that icon.


local DEBUG = false
--[===[@debug@
DEBUG = true
--@end-debug@]===]

lib.realPlate = lib.realPlate or {}
lib.fakePlate = lib.fakePlate or {}

local function CmdHandler()
	DEBUG = not DEBUG
end
_G.SlashCmdList["LIBNAMEPLATEDEBUG"] = CmdHandler
_G.SLASH_LIBNAMEPLATEDEBUG1 = "/lnbug"
local function debugPrint(...)
	if DEBUG then
		print(...)
	end
end
lib.debugPrint = debugPrint

lib.nameplates		= lib.nameplates or {}
lib.GUIDs			= lib.GUIDs or {}
lib.names			= lib.names or {}
lib.onShowHooks = lib.onShowHooks or {}
lib.onHideHooks = lib.onHideHooks or {}
lib.onUpdateHooks = lib.onUpdateHooks or {}
--~ lib.setAlphaHooks = lib.setAlphaHooks or {}
lib.healthOnValueChangedHooks = lib.healthOnValueChangedHooks or {}

lib.plateGUIDs = lib.plateGUIDs or {}
lib.isOnScreen = lib.isOnScreen or {}
lib.isOnUpdating = lib.isOnUpdating or {}


--Region locations
lib.name_region = lib.name_region or {}
lib.level_region = lib.level_region or {}
lib.boss_region = lib.boss_region or {}
lib.elite_region = lib.elite_region or {}
lib.threat_region = lib.threat_region or {}
lib.hightlight_region = lib.hightlight_region or {}
lib.raidicon_region = lib.raidicon_region or {}

--bar locations
lib.health_bar = lib.health_bar or {}
lib.cast_bar = lib.cast_bar or {}


lib.combatStatus = lib.combatStatus or {}

--[[
TidyPlate region names
	old: "threatGlow", "healthBorder", "castBorder", "castNostop", "spellIcon", "highlightTexture", "nameText", "levelText", "dangerSkull", "raidIcon", "eliteIcon"
	new: "threatGlow", "healthborder", "castborder", "castnostop", "spellicon", "highlight", "name", "level", "dangerskull", "raidicon", "eliteicon"
TidyPlate child names
	old: "healthBar", "castBar"
	new: "castbar", "healthbar"
	
TidyPlate 'frame.regions' names.
	castborder, castnostop, dangerskull, eliteicon, healthborder, highlight, level, name, raidicon, specialArt, specialText, specialText2, threatGlow, threatborder
TidyPlate 'frame.bars' names.
	cast (real), castbar, health (real), healthbar, 
]]
local regionNames = { "threatGlow", "healthBorder", "castBorder", "castNostop", "spellIcon", "highlightTexture", "nameText", "levelText", "dangerSkull", "raidIcon", "eliteIcon" }
local regionIndex = {}
for i, name in pairs(regionNames) do 
	regionIndex[name] = i
end

local barNames = { "healthBar", "castBar"}
local barIndex = {}
for i, name in pairs(barNames) do 
	barIndex[name] = i
end





--[[
	these always return nil
	frame:IsClampedToScreen(), frame:IsIgnoringDepth(), frame:IsMovable(), frame:IsToplevel(), frame:GetDepth(), frame:GetEffectiveDepth(), 

]]
local function IsNamePlateFrame(frame)
	if frame:GetName() then
--~ 		debugPrint("IsNamePlateFrame","No name!")
		return false
	end

	if frame:GetID() ~= 0 then
		return false
	end
	
	if frame:GetObjectType() ~= "Frame" then
--~ 		debugPrint("IsNamePlateFrame","Not a frame!")
		return false
	end
		
	if frame.extended or frame.aloftData then
		--Tidyplates = extended, Aloft = aloftData
		--They sometimes remove & replace the children so this needs to be checked first.
		return true
	end

	if frame.done then --caelNP
		return true
	end
	
	if frame:GetNumChildren() == 0 then
--~ 		debugPrint("IsNamePlateFrame","No children?!!", frame:GetName(), frame.extended and frame.extended.bars)
		return false
	end
		
	if frame:GetNumRegions() == 0 then
		return false
	end
	
	return true
end



--[===[@debug@
function LC_TEST()--		/run LC_TEST()
	local c = {WorldFrame:GetChildren()}
	local frame, cFrame
	for i = 1, table_getn(c) do
		frame = c[i]
		if frame:IsShown() then
			--frame.extended
			debugPrint(IsNamePlateFrame(frame), "ID:"..tostring(frame:GetID()), "C:"..tostring(frame:GetNumChildren()), "R:"..tostring(frame:GetNumRegions()))
			
		end
	end
end
--@end-debug@]===]

local function ScanWorldFrameChildren(n, ...)
    for i = 1, n do
        local frame = select(i, ...)
        if frame:IsShown() and IsNamePlateFrame(frame) then
            if not lib.nameplates[frame] then
				lib:NameplateFirstLoad(frame)
                lib:SetupNameplate(frame)                    
            end
        end    
    end
end


local lastChildren = 0
local function FindNameplates()
    local curChildren = WorldFrame:GetNumChildren()
    if curChildren ~= lastChildren then
        lastChildren = curChildren
        ScanWorldFrameChildren(curChildren, WorldFrame:GetChildren())
    end
end



---------------------------
-- Get region locations
----------------------------
function lib:GetNameRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.name then --TidyPlates
		return frame.extended.regions.name
		
	elseif frame.aloftData and frame.aloftData.nameTextRegion then --Aloft
		return frame.aloftData.nameTextRegion
		
	elseif frame.oldname then --dNameplates
		return frame.oldname
	end
	
	return select(regionIndex.nameText, frame:GetRegions())
end

function lib:GetLevelRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.level then--TidyPlates
		return frame.extended.regions.level
		
	elseif frame.aloftData and frame.aloftData.levelTextRegion then --Aloft
		return frame.aloftData.levelTextRegion
		
	elseif frame.level then --dNameplates
		return frame.level
	end
	
	return select(regionIndex.levelText, frame:GetRegions() )
end

function lib:GetBossRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.dangerskull then --tidyPlates
		return frame.extended.regions.dangerskull
	elseif frame.aloftData and frame.aloftData.bossIconRegion then --aloft
		return frame.aloftData.bossIconRegion
	elseif frame.boss then --dNameplates
		return frame.boss
	end
	return select(regionIndex.dangerSkull, frame:GetRegions())
end

function lib:GetEliteRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.eliteicon then --tidyPlates
		return frame.extended.regions.eliteicon
	elseif frame.aloftData and frame.aloftData.stateIconRegion then --aloft
		return frame.aloftData.stateIconRegion
	elseif frame.elite then --dNameplates
		return frame.elite
	end
	return  select(regionIndex.eliteIcon, frame:GetRegions())
end


function lib:GetThreatRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.threatGlow then
		return frame.extended.regions.threatGlow
	elseif frame.aloftData and frame.aloftData.nativeGlowRegion then
		return frame.aloftData.nativeGlowRegion
	elseif frame.oldglow then --dNameplates
		return frame.oldglow
	end
	
	return select(regionIndex.threatGlow, frame:GetRegions() )
end


function lib:GetHightlightRegion(frame)
	if frame.extended then
		if frame.extended.regions then
			if frame.extended.regions.highlight then
				return frame.extended.regions.highlight
			elseif frame.extended.regions.highlightTexture then --old tidyplates
				return frame.extended.regions.highlightTexture
			end
		end
	elseif frame.aloftData and frame.aloftData.highlightRegion then
		return frame.aloftData.highlightRegion
	elseif frame.highlight then --dNameplates
		return frame.highlight
	end
	
	return select(regionIndex.highlightTexture, frame:GetRegions())
end


function lib:GetRaidIconRegion(frame)
	if frame.extended and frame.extended.regions and frame.extended.regions.raidicon then
		return frame.extended.regions.raidicon
	elseif frame.aloftData and frame.aloftData.raidIconRegion then
		return frame.aloftData.raidIconRegion
	end
	return select(regionIndex.raidIcon, frame:GetRegions())
end

----------------------
-- Get bar frames
----------------------
function lib:GetHealthBar(frame)
	if frame.extended and frame.extended.bars and frame.extended.bars.health then
		return frame.extended.bars.health
--~ 	elseif frame.aloftData then
		--Aloft changes the bar color. Our functions will have to use aloftData.originalHealthBarR
	elseif frame.healthOriginal then --dNameplates
		return frame.healthOriginal
	end
	return select(barIndex.healthBar, frame:GetChildren())
end


function lib:GetCastBar(frame)
	if frame.extended and frame.extended.bars and frame.extended.bars.castbar then
		return frame.extended.bars.castbar
	elseif frame.aloftData and frame.aloftData.castBar then
		return frame.aloftData.castBar
	end
	return select(barIndex.healthBar, frame:GetChildren())
end

------------------------------------------------------------------------------------------------------------------
local function HideMouseoverRegion(frame)																		--
-- If we move the camera angle while the mouse is over a plate, that plate won't hide the mouseover texture.	--
-- So if we're mousing over someone's feet and a plate has the mouseover texture visible, 						--
-- it fools our code into thinking we're mousing over that plate.												--
-- This can be recreated by placing the mouse over a nameplate then holding rightclick and moving the canera.	--
-- Our UpdateNameplateInfo will see that the texture is still visible but no mouseover ID is available. 		--
------------------------------------------------------------------------------------------------------------------

	local region = lib.hightlight_region[frame] or lib:GetHightlightRegion(frame)
	if region and region.Hide then
		region:Hide()
	end
end



local function RecycleNameplate(frame)
--~ 	debugPrint("RecycleNameplate", frame)

	lib.callbacks:Fire("LibNameplate_RecycleNameplate", lib.fakePlate[frame] or frame)
	
	if lib.plateGUIDs[frame] then
		lib.GUIDs[lib.plateGUIDs[frame]] = false
	end
	
	local plateName = lib:GetName(frame)
	
	if plateName and lib.names[plateName] then
		lib.names[plateName] = false
	end
	
	
	
	lib.plateGUIDs[frame] = false
	local fake = lib.fakePlate[frame]
	if fake then
		lib.realPlate[fake] = false
	end
	lib.fakePlate[frame] = false
end

local function FoundPlateGUID(frame, GUID, unitID)
	lib.plateGUIDs[frame] = GUID
--~ 	lib.checkForHPUnitMatch[frame] = false
	
	lib.GUIDs[GUID] = frame
	lib.callbacks:Fire("LibNameplate_FoundGUID", lib.fakePlate[frame] or frame, GUID, unitID)
	
	
end

local function GetMouseoverGUID(frame)
	local unitID = "mouseover"
	if UnitExists(unitID) then
		FoundPlateGUID(frame, UnitGUID(unitID), unitID)
	end
end

local function FindPlateWithRaidIcon(iconNum)
	for frame in pairs(lib.nameplates) do 
		if lib:IsMarked(frame) and lib:GetRaidIcon(frame) == iconNum then
			return frame
		end
	end
	return nil
end

local function CheckRaidIconOnUnit(unitID, frame, raidNum, from)
	local targetID = unitID.."target"
	local targetIndex
	
	if UnitExists(targetID) and not UnitIsUnit("target", targetID) then
		targetIndex = GetRaidTargetIndex(targetID)
		if targetIndex and targetIndex == raidNum then
			debugPrint("FindGUIDByRaidIcon", from, "Icon:"..tostring(raidNum), "unitID:"..tostring(targetID), "GUID:"..tostring(UnitGUID(targetID)))
			FoundPlateGUID(frame, UnitGUID(targetID), targetID)
			return true
		end
	end
	return false
end

local function FindGUIDByRaidIcon(frame, raidNum, from)
	local group, num = "", 0
	if GetNumRaidMembers() > 1 then
		group, num = "raid", GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		group, num = "party", GetNumPartyMembers()
	else
		return
	end
	
	local unitID
	for i = 1, num do
		unitID = group..i;
		if CheckRaidIconOnUnit(unitID, frame, raidNum, from) then 
			return
		end
		
		if UnitExists(unitID.."pet") then
			if CheckRaidIconOnUnit(unitID.."pet", frame, raidNum, from) then 
				return
			end
		end
	end
end

local function UpdateNameplateInfo(frame)
	if lib:IsMouseover(frame) and not UnitExists("mouseover") then
		HideMouseoverRegion(frame)
	end

	if not lib.plateGUIDs[frame] then
		if lib:IsMouseover(frame) then
			GetMouseoverGUID(frame)
		elseif lib:IsMarked(frame) then
			local raidNum = lib:GetRaidIcon(frame)
			if raidNum and raidNum > 0 then
				FindGUIDByRaidIcon(frame, raidNum, "UpdateNameplateInfo")
			end
		end
	end

--~ 	debugPrint("Updated nameplate", lib:GetName(frame))
	frame.lnpLastUpdate = 0
end

local function CheckUnitIDForMatchingHP(unitID, frameName, current, max)
	local targetID = unitID.."target"
	
	if UnitName(targetID) == frameName then
		local health = UnitHealth(targetID)
		local maxHealth = UnitHealthMax(targetID)

		if health == current and maxHealth == max then
			return true
		end
	end
	return false
end

function lib:NewNameplateCheckHP(frame)
	local bar = self.health_bar[frame] or self:GetHealthBar(frame)
	if bar and bar.GetValue then --bar.GetMinMaxValues then
		local _, max = bar:GetMinMaxValues()
--~ 		return tonumber(max or 0)
		local current = bar:GetValue()
		lib.prevHealth[frame] = current
		
		if current > 0 and current ~= max then
			
		
			local group, num = "", 0
			if GetNumRaidMembers() > 1 then
				group, num = "raid", GetNumRaidMembers()
			elseif GetNumPartyMembers() > 0 then
				group, num = "party", GetNumPartyMembers()
			else
				return
			end
		
			local possibleUnits = {}

			local frameName = self:GetName(frame)
			local unitID, targetID, targetIndex
			for i = 1, num do
				unitID = group..i;
				if CheckUnitIDForMatchingHP(unitID, frameName, current, max) then
					table_insert(possibleUnits, #possibleUnits+1, unitID.."target")
				end
				
				if UnitExists(unitID.."pet") then
					if CheckUnitIDForMatchingHP(unitID.."pet", frameName, current, max) then
						table_insert(possibleUnits, #possibleUnits+1, unitID.."pettarget")
					end
				end
				
			end
			
			if #possibleUnits == 1 then
--~ 				debugPrint("OnNameplateShow","Found nameplate HP match", self:GetName(frame), UnitName(possibleUnits[1]))
				FoundPlateGUID(frame, UnitGUID(possibleUnits[1]), possibleUnits[1])
				return true
			end
		
		end
	end
end

lib.prevHealth = lib.prevHealth or {}

function lib.OnNameplateShow(frame, ...)
--~ 	local plateName = lib:GetName(frame)
--~ 	debugPrint("OnNameplateShow",frame, plateName)

	lib:SetupNameplate(frame)
	lib:NewNameplateCheckHP(frame)
end
local function ourOnShow(...) return lib.OnNameplateShow(...) end

function lib.OnNameplateHide(frame, ...)
	lib.isOnScreen[frame] = false
	lib.isOnUpdating[frame] = false
	lib.combatStatus[frame] = false
--~ 	lib.checkForHPUnitMatch[frame] = false
	
	RecycleNameplate(frame)
end
local function ourOnHide(...) return lib.OnNameplateHide(...) end

--[[
local function ourOnHide(self, ...)
	lib.isOnScreen[self] = false
	RecycleNameplate(self)
end
]]

--[[
function lib.callbacks:OnUsed(target, eventname)
end

function lib.callbacks:OnUnused(target, eventname)
end
]]


function lib.OnNameplateUpdate(frame, elapsed, ...)
	lib.isOnUpdating[frame] = true --to make sure our hooks don't break.
	if frame.lnpCheckForTarget then --Check on the first OnUpdate after the frame's shown.
		frame.lnpCheckForTarget = false
		if not lib.plateGUIDs[frame] and frame:IsShown() and ((frame:GetAlpha() == 1) and UnitExists("target")) then
			FoundPlateGUID(frame, UnitGUID("target"), "target")
		end
	end

	frame.lnpLastUpdate = (frame.lnpLastUpdate or 0) + elapsed
	if frame.lnpLastUpdate > updateDelay then
		UpdateNameplateInfo(frame)

		if not lib.fakePlate[frame] and frame.extended then
			lib.realPlate[frame.extended] = frame
			lib.fakePlate[frame] = frame.extended

			lib.callbacks:Fire("LibNameplate_RecycleNameplate", frame)--Hide real plate so addon unhook their stuff.
			lib.callbacks:Fire("LibNameplate_NewNameplate", lib.fakePlate[frame])
		end

		local inCombat = lib:IsInCombat(frame)
		
		if lib.combatStatus[frame] ~= inCombat then
			lib.combatStatus[frame] = inCombat
			lib.callbacks:Fire("LibNameplate_CombatChange", lib.fakePlate[frame] or frame, inCombat)
		end
		
	end
end
local function ourOnUpdate(...) return lib.OnNameplateUpdate(...) end



--[[
function lib.OnSetAlpha(frame, ...)
	local plateName = lib:GetName(frame)
	debugPrint("OnSetAlpha", plateName, ...)
end
local function ourSetAlpha(...) return lib.OnSetAlpha(...) end
]]

--~ lib.checkForHPUnitMatch = lib.checkForHPUnitMatch or {}

--------------------------------------------------------------------------------------
function lib.healthOnValueChanged(frame, ...)										--
-- This fires before OnShow fires and the regions haven't been updated yet. 		--
-- So I make sure lib.isOnScreen[plate] is true before working on the HP change.	--
--------------------------------------------------------------------------------------
	local plate = frame:GetParent()
	local currentHP = ...
	
	--strange, when a nameplate's not on screen, we still get HP changes. It's not relyable but might be of use somehow...
--~ 	if plate and plate:IsShown() and not lib.prevHealth[plate] or lib.prevHealth[plate] ~= currentHP then
	if plate and lib.isOnScreen[plate] and (not lib.prevHealth[plate] or lib.prevHealth[plate] ~= currentHP) then
		lib.callbacks:Fire("LibNameplate_HealthChange", frame, ...)
		local plateName = lib:GetName(plate)
--~ 		debugPrint("OnValueChanged", plateName, ...)

		if not lib.plateGUIDs[plate] then
			
--~ 			lib.checkForHPUnitMatch[plate] = true
			
--~ 			debugPrint("healthOnValueChanged",plate, "Checking HP change on "..tostring(plateName), ..., "onScreen:"..tostring(lib.isOnScreen[plate]))
			lib:NewNameplateCheckHP(plate)
			
		end

	end
end
local function ourHealthOnValueChanged(...) return lib.healthOnValueChanged(...) end

--[[
--~ --Castbars are only shown on your target's nameplate. No sense adding callbacks for this.
--~ --Castbar show
local testing = {}
lib.onCastbarShowHooks = lib.onCastbarShowHooks or {}
function lib.OnCastbarShow(self, ...)
	if not testing[self] then	
		if UnitExists("target") and (UnitCastingInfo("target") or UnitChannelInfo("target")) then
			testing[self] = true
			
			debugPrint("OnCastbarShow 2", UnitCastingInfo("target"), UnitChannelInfo("target"))
		end
	end
end
local function ourCastbarShow(...) return lib.OnCastbarShow(...) end

--~ --castbar hide
lib.onCastbarHideHooks = lib.onCastbarHideHooks or {}
function lib.OnCastbarHide(self, ...)
end
local function ourCastbarHide(...) return lib.OnCastbarHide(...) end
]]



function lib:SaveFrameRegions(frame)
	self.name_region[frame] = self:GetNameRegion(frame)
	self.level_region[frame]  = self:GetLevelRegion(frame)
	self.boss_region[frame]  = self:GetBossRegion(frame)
	self.elite_region[frame]  = self:GetEliteRegion(frame)
	self.threat_region[frame]  = self:GetThreatRegion(frame)
	self.hightlight_region[frame]  = self:GetHightlightRegion(frame)
	self.raidicon_region[frame]  = self:GetRaidIconRegion(frame)

end
--~ lib:GetHealthBar(frame)


function lib:SaveFrameBars(frame)
	self.health_bar[frame] =  self:GetHealthBar(frame)
	self.cast_bar[frame] =  self:GetCastBar(frame)

end

local testing = false

function lib:HookNameplate(frame)
	if frame:HasScript("OnHide") and not self.onHideHooks[frame] then
		self.onHideHooks[frame] = true
		frame:HookScript("OnHide", ourOnHide)
	end
	
	if frame:HasScript("OnShow") and not self.onShowHooks[frame] then
		self.onShowHooks[frame] = true
		frame:HookScript("OnShow", ourOnShow)
	end

	if frame:HasScript("OnUpdate") and not self.onUpdateHooks[frame] then
		self.onUpdateHooks[frame] = true
		frame:HookScript("OnUpdate", ourOnUpdate)
	end
	
	--[[if not self.setAlphaHooks[frame] then --nameRegion:HasScript("SetText") and 
		self.setAlphaHooks[frame] = true
		hooksecurefunc(frame, "SetAlpha", ourSetAlpha)
	end]]

	local healthBar = self.health_bar[frame]
	if healthBar and not self.healthOnValueChangedHooks[frame] then
		self.healthOnValueChangedHooks[frame] = true
		healthBar:HookScript("OnValueChanged", ourHealthOnValueChanged)
	end
end

function lib:NameplateFirstLoad(frame)
	--Save region and bar locations.
	lib:SaveFrameRegions(frame)
	lib:SaveFrameBars(frame)
	
	--Hook handlers.
	self:HookNameplate(frame)
	
	--Save frame's combat status as false.
	if self.combatStatus[frame] == nil then
		self.combatStatus[frame] = false --not in combat
	end
end

function lib:SetupNameplate(frame)
	self.isOnScreen[frame] = true --to make sure our hooks don't break.

	local plateName = self:GetName(frame)
	self.nameplates[frame] = plateName
	self.names[plateName] = frame
--~ 	local plateType = self:GetType(frame)
--~ 	local plateCombat = self:IsInCombat(frame)
--~ 	debugPrint("SetupNameplate", plateName, plateType, plateCombat)
	
	
	
	--TidyPlates replace the orginal frame with their own.
	--Lets save this and give that frame to addons. It's better for anchors.
	if frame.extended and not self.fakePlate[frame] then
		self.fakePlate[frame] = frame.extended
		self.realPlate[frame.extended] = frame
		
		--Without this was causing problems with PlateBuffs where it was never told the real plate was gone.
		self.callbacks:Fire("LibNameplate_RecycleNameplate", frame)
	end
	
	self.callbacks:Fire("LibNameplate_NewNameplate", self.fakePlate[frame] or frame)

	frame.lnpCheckForTarget = true
	UpdateNameplateInfo(frame)
end--	/lnbug

local function CheckForTargetGUID()
	local unitID = "target"
	local GUID
	for frame in pairs(lib.nameplates) do 
		if lib:IsTarget(frame) then
			lib.targeted = frame
			if not lib.plateGUIDs[frame] then
				FoundPlateGUID(frame, UnitGUID(unitID), unitID)
			end
			lib.callbacks:Fire("LibNameplate_TargetNameplate", lib.fakePlate[frame] or frame)
			return
		end
	end
--~ 	debugPrint("Failed to find target GUID")
end


local checkHPMatch = 1 --every 1 seconds

--lib.checkForHPUnitMatch[plate]
local function OnUpdate(frame, elapsed)
	if frame.checkTarget then
		frame.checkTarget = false
		CheckForTargetGUID()
	end

	FindNameplates()

	--code searches for broken OnShow/OnHide hooks.
	--some nameplate addons will use SetScript instead of HookScript and breaks our hooks.
	frame.lastUpdate = frame.lastUpdate + elapsed
	if frame.lastUpdate >= scanDelay then
		frame.lastUpdate = 0
		for frame, value in pairs(lib.isOnScreen) do 
			if (value == true and not frame:IsShown()) then --OnHide fail
				debugPrint("OnHide fail", frame, value, frame:IsShown())
				lib.onHideHooks[frame] = false
				lib.isOnScreen[frame] = false
				lib:HookNameplate(frame)
				lib.OnNameplateHide(frame)
				
			elseif (value == false and frame:IsShown()) then --OnShow fail
				debugPrint("OnShow fail", frame, value, frame:IsShown())
				lib.onShowHooks[frame] = false
				lib.isOnScreen[frame] = false
				lib:HookNameplate(frame)
				lib:SetupNameplate(frame, true)
				
			end
		end
		for frame, value in pairs(lib.isOnUpdating) do 
			if value == false and frame:IsShown() then
				debugPrint("OnUpdate fail?")
				lib.onUpdateHooks[frame] = false
				lib:HookNameplate(frame)
			end
		end
	end
	
	--[[
	--Check if HP has changed on frames which we don't know GUIDs for. If so, see if we can match that current/max HP to any group member's targets.
	frame.lastHPCheck = frame.lastHPCheck + elapsed
	if frame.lastHPCheck >= checkHPMatch then
		frame.lastHPCheck = 0
		local plateName
		for plate in pairs(lib.checkForHPUnitMatch) do 
			if plate:IsShown() then
				plateName = lib:GetName(plate)
				debugPrint("healthOnValueChanged",plate, "Checking HP change on "..tostring(plateName))
				lib:NewNameplateCheckHP(plate)
			else
				lib.checkForHPUnitMatch[plate] = false
			end
		end
	end
	]]
end


local function OnEvent(frame, event, ...)
	if event == "UPDATE_MOUSEOVER_UNIT" then
		if GetMouseFocus():GetName() == "WorldFrame" then
			local i = 0
			local mouseoverPlate
			for frame in pairs(lib.nameplates) do 
				if frame:IsShown() and lib:IsMouseover(frame) then
					i = i + 1
					mouseoverPlate = frame

				end
			end
			if i == 1 then
				if not lib.plateGUIDs[mouseoverPlate] then
					GetMouseoverGUID(mouseoverPlate)
				end
				lib.callbacks:Fire("LibNameplate_MouseoverNameplate", lib.fakePlate[mouseoverPlate] or mouseoverPlate)
			elseif i > 1 then
				debugPrint(i.." mouseover frames")
			end
			
		end
		
	elseif event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") then
			frame.checkTarget = true--Check for target nameplate on next OnUpdate. We can't do it now.
		else
			lib.targeted = nil
		end
		
	elseif event == "UNIT_TARGET" then
		local unitID = ...
		local targetID = unitID.."target"
		if UnitExists(targetID) and not UnitIsUnit("player", unitID) and UnitInRange(unitID) then
			local targetGUID = UnitGUID(targetID) 
			local iconNum = GetRaidTargetIndex(targetID)
			if iconNum and iconNum > 0 then
				local foundPlate = FindPlateWithRaidIcon(iconNum)
				if foundPlate and not lib.plateGUIDs[foundPlate] then
--~ 					debugPrint(event, "Found raid icon on ", UnitName(unitID), "'s target", UnitName(targetID), "icon:"..tostring(iconNum))
					FoundPlateGUID(foundPlate, targetGUID, targetID)
				end
			end
			
			
			if lib.GUIDs[targetGUID] and lib.GUIDs[targetGUID]:IsShown() then
				return
			end
			
			local health = UnitHealth(targetID)
			local maxHealth = UnitHealthMax(targetID)
			if health > 0 and health ~= maxHealth then
				
				local foundPlate = lib:GetNameplateByHealth(health, maxHealth)
--~ 				debugPrint(event, "A", foundPlate, health, maxHealth)
				if foundPlate and not lib.plateGUIDs[foundPlate] then
					local name = UnitName(targetID)
					if name == lib:GetName(foundPlate) then
--~ 						local class = lib:GetClass(foundPlate)
--~ 						local _, unitClass = UnitClass(targetID)
--~ 					
--~ 						debugPrint(event, "B", foundPlate, class, unitClass)
					
--~ 						if not class or class == unitClass then
--~ 							return lib.fakePlate[frame] or frame
							
--~ 							debugPrint(event, "C", "Found nameplate matching "..UnitName(unitID).."'s target.", UnitName(targetID))
							
							FoundPlateGUID(foundPlate, targetGUID, targetID)
							

--~ 						end
					end
				end
			end
			
			
			
		end
		
	elseif event == "RAID_TARGET_UPDATE" then
		for frame in pairs(lib.nameplates) do 
			if frame:IsShown() and not lib.plateGUIDs[frame] and lib:IsMarked(frame) then
				local raidNum = lib:GetRaidIcon(frame)
				if raidNum and raidNum > 0 then
					FindGUIDByRaidIcon(frame, raidNum, event)
				end
			end
		end
--~ 	elseif event == "PLAYER_ENTERING_WORLD" then
--~ 		debugPrint(event, MAJOR, _G.TidyPlates, _G.Aloft)
--~ 		if _G.TidyPlates then
--~ 			tidyPlatesRunning = true
--~ 		elseif _G.Aloft then
--~ 			aloftRunning = true
--~ 		if IsAddOnLoaded("caelNamePlates") then
--~ 			scanDelay = 0.1 --cael breaks our onhide/onshow hooks. 
--~ 		elseif IsAddOnLoaded("dNameplates") then
--~ 			scanDelay = 0.1 --cael breaks our onhide/onshow hooks. 
--~ 		end
		
	end
end

lib.frame = lib.frame or CreateFrame("Frame")

lib.frame.lastUpdate = 0
lib.frame.lastHPCheck = 0
lib.frame.checkTarget = false
lib.frame:SetScript("OnUpdate", OnUpdate)
lib.frame:SetScript("OnEvent", OnEvent)
lib.frame:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
lib.frame:RegisterEvent('PLAYER_TARGET_CHANGED')
lib.frame:RegisterEvent('UNIT_TARGET')
lib.frame:RegisterEvent('RAID_TARGET_UPDATE')
lib.frame:RegisterEvent('PLAYER_ENTERING_WORLD')



--------------------- API ------------------
local raidIconTexCoord = {--from GetTexCoord. input is ULx and ULy (first 2 values).
	[0]		= {
		[0]		= 1, --star 
		[0.25]	= 5, --moon
	},
	[0.25]	= {
		[0]		= 2, --circle 
		[0.25]	= 6, --square
	},
	[0.5]	= {
		[0]		= 3, --star 
		[0.25]	= 7, --cross
	},
	[0.75]	= {
		[0]		= 4, --star 
		[0.25]	= 8, --skull
	},
}


--Support functions for API.
local function reactionByColor(red, green, blue, a)																											
	if red < .01 and blue < .01 and green > .99 then return "FRIENDLY", "NPC" 
	elseif red < .01 and blue > .99 and green < .01 then return "FRIENDLY", "PLAYER"
	elseif red > .99 and blue < .01 and green > .99 then return "NEUTRAL", "NPC"
	elseif red > .99 and blue < .01 and green < .01 then return "HOSTILE", "NPC"
	else return "HOSTILE", "PLAYER" end
end
--[[
	RAID_CLASS_COLORS
	["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
	["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
	["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
	["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
	["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
	["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
	["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 },
	["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
]]

local colorToClass = {}
local function pctToInt(number) return math_floor((100*number) + 0.5) end
for classname, color in pairs(RAID_CLASS_COLORS) do
	colorToClass["C"..pctToInt(color.r)+pctToInt(color.g)+pctToInt(color.b)] = classname
end

local function threatByColor( region )
	if not region:IsShown() then return "LOW" end
	
	local redCan, greenCan, blueCan, alphaCan = region:GetVertexColor()
	if greenCan > .7 then return "MEDIUM" end
	if redCan > .7 then return "HIGH" end
end


local function combatByColor(r, g, b, a) 
	return (r > .5 and g < .5)
end


local function GetHealthBarColor(frame)
	if frame.aloftData then
		local r, g, b = frame.aloftData.originalHealthBarR, frame.aloftData.originalHealthBarG, frame.aloftData.originalHealthBarB
		return r, g, b
	end
	
	if frame.originalR and frame.originalG and frame.originalB then
		 --dNamePlates changes the color of the healthbar. r7 now saves the original colors. TY Dawn.
		return frame.originalR, frame.originalG, frame.originalB
	end
	
	local bar = lib.health_bar[frame] or lib:GetHealthBar(frame)
	if bar and bar.GetStatusBarColor then
		return bar:GetStatusBarColor()
	end
	return nil
end

--------------------------------------------------------------
local function RemoveHexColor(inputString)					--
-- Remove hex color code from string. 						--
-- Aloft uses hex codes to color name and level regions.	--
--------------------------------------------------------------
	local find = inputString:find("|c")
	if find then
		inputString = inputString:sub(find+10)
	end
	inputString = inputString:gsub("|r", "")
	return inputString
end

--API 

function lib:GetName(frame)
	local frame = self.realPlate[frame] or frame

	local nameRegion = self.name_region[frame] or self:GetNameRegion(frame)
	if nameRegion and nameRegion.GetText then
		return RemoveHexColor( nameRegion:GetText() )
	end

	return nil
end


function lib:GetLevel(frame)
	local frame = self.realPlate[frame] or frame
	local region = self.level_region[frame] or self:GetLevelRegion(frame)
	if region and region.GetText then
		return tonumber( RemoveHexColor( region:GetText() ) )
	end
	return 0
end


function lib:GetScale(frame)
	local frame = self.realPlate[frame] or frame
	if frame.extended then
		frame = frame.extended
	end
	return frame:GetScale()
end

function lib:GetVisibleFrame(frame)
	local frame = self.realPlate[frame] or frame
	if frame.extended then
		frame = frame.extended
	end
	return frame
end

	
function lib:GetReaction(frame)
	local frame = self.realPlate[frame] or frame

	local r,g,b = GetHealthBarColor(frame)
	if r then
		return reactionByColor(r, g, b )
	end

	return nil
end

function lib:GetType(frame)
	local frame = self.realPlate[frame] or frame
	
	local r, g, b = GetHealthBarColor(frame)
	if r then
		return select(2, reactionByColor( r, g, b ) )
	end

	return nil
end



function lib:IsBoss(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.boss_region[frame] or self:GetBossRegion(frame)
	if region and region.IsShown then
		return region:IsShown() and true or false
	end

	return nil
end


--This will return nil if we're not in a PvP zone (like in cities)
function lib:GetClass(frame)
	local frame = self.realPlate[frame] or frame

	local r, g, b = GetHealthBarColor(frame)
	if r then
		return colorToClass["C"..pctToInt(r)+pctToInt(g)+pctToInt(b)] or nil
	end

	return nil
end

function lib:IsElite(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.elite_region[frame] or self:GetEliteRegion(frame)
	if region and region.IsShown then
		return region:IsShown() and true or false
	end
	return nil
end



function lib:GetThreatSituation(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.threat_region[frame] or self:GetThreatRegion(frame)
	if region and region.GetVertexColor then
		return threatByColor(region)
	end

	return nil
end

function lib:IsTarget(frame)
	local frame = self.realPlate[frame] or frame
	return frame:IsShown() and frame:GetAlpha() == 1 and UnitExists("target") or false
end

function lib:GetHealthMax(frame)
	local frame = self.realPlate[frame] or frame

	local bar = self.health_bar[frame] or self:GetHealthBar(frame)
	if bar and bar.GetMinMaxValues then
		local _, max = bar:GetMinMaxValues()
		return tonumber(max or 0)
	end
	return nil
end

function lib:GetHealth(frame)
	local frame = self.realPlate[frame] or frame

	local bar = self.health_bar[frame] or self:GetHealthBar(frame)
	if bar and bar.GetValue then
		return bar:GetValue()
	end
	return nil
end

function lib:GetRaidIcon(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.raidicon_region[frame] or self:GetRaidIconRegion(frame)
	if region and region.IsShown and region:IsShown() and region.GetTexCoord then
		local ULx,ULy = region:GetTexCoord() --,LLx,LLy,URx,URy,LRx,LRy
		
		if ULx and ULy then
			return raidIconTexCoord[ULx] and raidIconTexCoord[ULx][ULy] or 0
		end
	end
	
	return nil
end

function lib:IsMouseover(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.hightlight_region[frame] or self:GetHightlightRegion(frame)
	if region and region.IsShown then
		return region:IsShown() and true or false
	end
	
	return nil
end


function lib:IsCasting(frame)
	local frame = self.realPlate[frame] or frame

	local bar = self.cast_bar[frame] or self:GetCastBar(frame)
	if bar and bar.IsShown then
		return bar:IsShown() and true or false
	end
	return nil
end


function lib:IsInCombat(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.name_region[frame] or self:GetNameRegion(frame)
	if region and region.GetTextColor then
		return combatByColor( region:GetTextColor() ) and true or false
	end
	
	return nil
end

function lib:IsMarked(frame)
	local frame = self.realPlate[frame] or frame

	local region = self.raidicon_region[frame] or self:GetRaidIconRegion(frame)
	if region and region.IsShown then
		return region:IsShown() and true or false
	end

	return nil
end


function lib:GetGUID(frame)
	local frame = self.realPlate[frame] or frame
	return self.plateGUIDs[frame]
end


function lib:GetTargetNameplate()
	if self.targeted and self.targeted:IsShown() then
		return self.fakePlate[self.targeted] or self.targeted
	end
end

function lib:GetNameplateByGUID(GUID)
	if self.GUIDs[GUID] and self.GUIDs[GUID]:IsShown() then
		return self.fakePlate[self.GUIDs[GUID]] or self.GUIDs[GUID]
	end
end


function lib:GetNameplateByName(name)
	if self.names[name] and self.names[name]:IsShown() then
		return self.fakePlate[self.names[name]] or self.names[name]
	end
end

function lib:GetNameplateByUnit(unitID)
	if UnitIsUnit(unitID, "target") then
		return self:GetTargetNameplate()
	end
	local GUID = UnitGUID(unitID)
	if self.GUIDs[GUID] and self.GUIDs[GUID]:IsShown() then
		return self.fakePlate[self.GUIDs[GUID]] or self.GUIDs[GUID]
	end
	
	local health = UnitHealth(unitID)
	local maxHealth = UnitHealthMax(unitID)
	local frame = self:GetNameplateByHealth(health, maxHealth)
	local name = UnitName(unitID)
	if frame then
		if name == lib:GetName(frame) then
--~ 			local class = self:GetClass(frame)
--~ 			local _, unitClass = UnitClass(unitID)
--~ 		
--~ 			if not class or class == unitClass then
				return self.fakePlate[frame] or frame
--~ 			end
		end
	end
	
	
	if self.names[GUID] and self.names[GUID]:IsShown() then
		return self.fakePlate[self.names[GUID]] or self.names[GUID]
	end
end

--Returns all known nameplates. Not just the one's visible.
function lib:GetAllNameplates()
	local frames = {}
	for frame in pairs(self.nameplates) do 
		table_insert(frames, #frames+1, self.fakePlate[frame] or frame)
	end
	return #frames, unpack(frames)
end

function lib:GetNameplateByHealth(current, max)
	local possibleFrames = {}
	local bar, barMax, barCurrent
	for frame in pairs(self.nameplates) do 
		if frame:IsShown() then
			bar = self.health_bar[frame] or self:GetHealthBar(frame)

			if bar and bar.GetMinMaxValues then
				_, barMax = bar:GetMinMaxValues()
				if barMax == max then
					if bar:GetValue() == current then
						table_insert(possibleFrames, #possibleFrames+1, frame)
					end
				end
			
			end
			
--~ 			table_insert(frames, #frames+1, self.fakePlate[frame] or frame)
		end
	end
	
	
	
--~ 	debugPrint("GetNameplateByHealth C", #possibleFrames)
	
	if #possibleFrames == 1 then
		return possibleFrames[1]
	end
	return nil
end

--[===[@debug@
function LC_TEST2()--		/run LC_TEST2()
	local health = UnitHealth("target")
	local maxHealth = UnitHealthMax("target")
	
	local frame = lib:GetNameplateByHealth(health, maxHealth)
	if frame then
		debugPrint("LC_TEST2","Found frame!", lib:GetClass(frame))
	end
end
--@end-debug@]===]