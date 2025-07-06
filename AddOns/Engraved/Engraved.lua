-- --------------------
-- Engraved
-- by lieandswell
-- Nephthys of Hyjal-US
-- --------------------


-- ENGRAVED = {};		-- defined in Engraved_Localization.lua, which must be loaded first
Engraved = {};			-- this file must be loaded second

ENGRAVED.VERSION = "1.5";

ENGRAVED.RUNE_DEFAULTS = {
	[1]	= { Scale = 0.45, Position = { "CENTER", "CENTER", 350, -50 } },
	[5]	= { Scale = 0.45, Position = { "CENTER", "CENTER", 350, -175 } },
	[3]	= { Scale = 0.45, Position = { "CENTER", "CENTER", 350, -300 } },
	[2]	= { Scale = 0.30, Position = { "CENTER", "CENTER", 660, -100 } },
	[6]	= { Scale = 0.30, Position = { "CENTER", "CENTER", 660, -290 } },
	[4]	= { Scale = 0.30, Position = { "CENTER", "CENTER", 660, -480 } },
};
ENGRAVED.THEME_LIST = { "Glyph", "Nexus", "Ulduar", "Greatsword", "Circle" };
ENGRAVED.TIMER_LIST = { "Almost ready", "Fill" };
ENGRAVED.FILL_SIZE = 128;

ENGRAVED.DEFAULTS = {
	Version 			= ENGRAVED.VERSION,
	RuneSettings		= CopyTable(ENGRAVED.RUNE_DEFAULTS),
	Locked 				= false,

	Position			= { "CENTER", "CENTER", 0, 0 };
	RuneColor = {
		[1]	= { 0.8, 0.1, 0.0 },	-- blood
		[2]	= { 0.3, 0.6, 0.0 },	-- unholy
		[3]	= { 0.0, 0.4, 0.6 },	-- frost
		[4]	= { 0.6, 0.0, 0.7 },	-- death
	},
	InCombatOpacity		= 1,
	OutOfCombatOpacity	= 1,
	UnusableOpacity		= 0.2,
	AlmostOpacity		= 1,

	Prioritize			= true,
	AlmostTime			= 1.5,
	Theme				= "Glyph",
	TimerMethod			= "Almost ready",
	AnimateGlow			= true, 	-- not yet implemented
};

function Engraved.Test(stuff)
	if ( stuff ) then
		DEFAULT_CHAT_FRAME:AddMessage("Engraved test: "..stuff);
	else
		DEFAULT_CHAT_FRAME:AddMessage("Engraved test");
	end
end



-- ------------
-- PARENT FRAME
-- ------------

function Engraved.RuneFrame_OnLoad(self)
	local _, class = UnitClass("player");
	if ( class ~= "DEATHKNIGHT" ) then
		self:Hide();
		return;
	end

	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");

	self.runes = {};
	for runeID = 1, 6 do
		self.runes[runeID] = _G["Engraved_Rune"..runeID];
		self.runes[runeID]["workingID"] = runeID;		
		-- have to do this because frame:GetID() *links* to the the ID instead of copying it.  :/
	end
end

function Engraved.RuneFrame_OnEvent(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( _G["RuneFrame"] ) then
			_G["RuneFrame"]:Hide();
		end
		Engraved.Update();

	elseif ( event == "VARIABLES_LOADED" ) then
		if ( not Engraved_Settings ) then
			Engraved_Settings = CopyTable(ENGRAVED.DEFAULTS);
		elseif ( Engraved_Settings["Version"] < ENGRAVED.VERSION ) then
			Engraved.SafeUpgrade();
		end
		--	SlashCmdList["ENGRAVED"] = Engraved.SlashCommand;
		--	SLASH_ENGRAVED1 = "/engraved";

	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		self:SetAlpha(Engraved_Settings["OutOfCombatOpacity"]);

	elseif ( event == "PLAYER_REGEN_DISABLED" ) then
		self:SetAlpha(Engraved_Settings["InCombatOpacity"]);

	end
end

function Engraved.SafeUpgrade()
	Engraved_Settings = Engraved.AddNewSettings(Engraved_Settings, ENGRAVED.DEFAULTS);
	Engraved_Settings["Version"] = ENGRAVED.VERSION;
end

function Engraved.AddNewSettings(settings, defaults)
	for k, v in pairs(defaults) do
		if ( not settings[k] ) then
			if ( type(v) == "table" ) then
				settings[k] = {};
				settings[k] = Engraved.AddNewSettings(settings[k], defaults[k]);
			else
				settings[k] = v;
			end
		elseif ( type(v) == "table" ) then
			settings[k] = Engraved.AddNewSettings(settings[k], defaults[k]);
		end
	end
	return settings;
end


function Engraved.Update()
	local runeFrame = _G["Engraved_RuneFrame"];
--[[
	runeFrame:ClearAllPoints();
	local point, relativePoint, xOfs, yOfs = unpack(Engraved_Settings.Position);
	runeFrame:SetPoint(point, UIParent, relativePoint, xOfs, yOfs);
--]]
	if ( InCombatLockdown() ) then 
		runeFrame:SetAlpha(Engraved_Settings["InCombatOpacity"]);
	else
		runeFrame:SetAlpha(Engraved_Settings["OutOfCombatOpacity"]);
	end
	for runeID = 1, 6 do
		Engraved.Rune_Update(runeFrame.runes[runeID]);	
	end
end



-- ----------------
-- INDIVIDUAL RUNES
-- ----------------

function Engraved.Rune_OnLoad(self)
	self:RegisterForDrag("LeftButton");

	local selfID = self:GetID();
	if ( selfID % 2 == 0 ) then
		self.otherRuneID = selfID - 1;
	else
		self.otherRuneID = selfID + 1;
	end

	self.background		= _G[self:GetName().."Background"];
	self.fill 			= _G[self:GetName().."Fill"];
	self.innerGlow 		= _G[self:GetName().."InnerGlow"];
	self.glow 			= _G[self:GetName().."Glow"];
	self.resizeButton 	= _G[self:GetName().."ResizeButton"];

	self:RegisterEvent("RUNE_POWER_UPDATE");
	self:RegisterEvent("RUNE_TYPE_UPDATE");
end

function Engraved.Rune_Update(rune)
	local runeID = rune:GetID();
	local settings = Engraved_Settings;
	local runeSettings = settings["RuneSettings"][runeID];

	if ( settings.Theme == "Glyph" ) then
		rune.background:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GlyphBackground"..runeID);
		rune.fill:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GlyphFill"..runeID);
		rune.glow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GlyphGlow"..runeID);
		rune.innerGlow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GlyphFill"..runeID);
		rune.background:SetVertexColor(0.7, 0.7, 0.7, 1);
		rune.innerGlow:SetAlpha(0.8);
	elseif ( settings.Theme == "Nexus") then
		rune.background:SetTexture("Interface\\AddOns\\Engraved\\Textures\\NexusBackground"..runeID);
		rune.fill:SetTexture("Interface\\AddOns\\Engraved\\Textures\\NexusFill"..runeID);
		rune.innerGlow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\NexusFill"..runeID);
		rune.glow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\NexusGlow"..runeID);
		rune.background:SetVertexColor(0.6, 0.6, 0.6, 1);
		rune.innerGlow:SetAlpha(0.85);
	elseif ( settings.Theme == "Ulduar") then
		rune.background:SetTexture("Interface\\AddOns\\Engraved\\Textures\\UlduarBackground"..runeID);
		rune.fill:SetTexture("Interface\\AddOns\\Engraved\\Textures\\UlduarFill"..runeID);
		rune.innerGlow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\UlduarFill"..runeID);
		rune.glow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\UlduarGlow"..runeID);
		rune.background:SetVertexColor(1,1,1,1);
		rune.innerGlow:SetAlpha(0.75);
	elseif ( settings.Theme == "Greatsword" ) then
		rune.background:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GreatswordBackground"..runeID);
		rune.fill:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GreatswordInnerGlow"..runeID);
		rune.innerGlow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GreatswordInnerGlow"..runeID);
		rune.glow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\GreatswordGlow"..runeID);
		rune.background:SetVertexColor(1,1,1,1);
		rune.innerGlow:SetAlpha(0.5);
	else
		rune.background:SetTexture("Interface\\AddOns\\Engraved\\Textures\\CircleBackground");
		rune.fill:SetTexture("Interface\\AddOns\\Engraved\\Textures\\CircleFill");
		rune.innerGlow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\CircleFill");
		rune.glow:SetTexture("Interface\\AddOns\\Engraved\\Textures\\CircleGlow");
		rune.background:SetVertexColor(1,1,1,1);
		rune.innerGlow:SetAlpha(0.25);
	end

	rune.prioritize = settings.Prioritize;
	rune.timerMethod = settings.TimerMethod;
	rune.almostTime = settings.AlmostTime;
	rune.unusableOpacity = settings.UnusableOpacity;
	rune.almostOpacity = settings.AlmostOpacity;

	rune:ClearAllPoints();
	local point, relativePoint, xOfs, yOfs = unpack(runeSettings.Position);
	rune:SetPoint(point, UIParent, relativePoint, xOfs, yOfs);
--	rune:SetPoint(point, self:GetParent(), relativePoint, xOfs, yOfs);
	rune:SetScale(runeSettings.Scale);

	-- overall opacity is set in the parent frame

	if ( settings.Locked ) then
		rune.resizeButton:Hide();
		rune:EnableMouse(0);
	else
		rune.resizeButton:Show();
		rune:EnableMouse(1);
	end

	Engraved.Rune_UpdateType(rune)
	-- add availability check here
end

function Engraved.Rune_OnEvent(self, event, ...)

	if ( event == "RUNE_POWER_UPDATE" ) then
		local runeID, usable = ...;
		if ( runeID == self.workingID ) then 
			if ( self.prioritize ) then

				local selfID = self:GetID();
				local tmpID;
				local otherRune = _G["Engraved_Rune"..self.otherRuneID];

				local start, duration, runeReady = GetRuneCooldown(self.workingID);
				local otherStart, otherDuration, otherRuneReady = GetRuneCooldown(otherRune.workingID);

				if ( runeReady and otherRuneReady ) then
					Engraved.Rune_Activate(self);

				elseif ( not runeReady and not otherRuneReady ) then
					local time = GetTime();
					if ( start+duration-time > otherStart+otherDuration-time ) then
						if ( selfID % 2 == 0 ) then
							Engraved.Rune_Inactivate(self);
						else
							tmpID = otherRune.workingID;
							otherRune.workingID = self.workingID;
							self.workingID = tmpID;
							Engraved.Rune_Inactivate(self);
							Engraved.Rune_UpdateType(self);
							Engraved.Rune_UpdateType(otherRune);
						end
					else
						if ( selfID % 2 == 0 ) then
							tmpID = otherRune.workingID;
							otherRune.workingID = self.workingID;
							self.workingID = tmpID;
							Engraved.Rune_Inactivate(self);
							Engraved.Rune_UpdateType(self);
							Engraved.Rune_UpdateType(otherRune);
						else
							Engraved.Rune_Inactivate(self);
						end
					end

				elseif ( runeReady and not otherRuneReady ) then
					if ( selfID % 2 == 0 ) then
						tmpID = otherRune.workingID;
						otherRune.workingID = self.workingID;
						self.workingID = tmpID;
						Engraved.Rune_Inactivate(self);
						Engraved.Rune_Activate(otherRune);
						Engraved.Rune_UpdateType(self);
						Engraved.Rune_UpdateType(otherRune);
					else
						Engraved.Rune_Activate(self);
						Engraved.Rune_Inactivate(otherRune);
					end

				elseif ( not runeReady and otherRuneReady ) then
					if ( selfID % 2 == 0 ) then
						Engraved.Rune_Inactivate(self);
						Engraved.Rune_Activate(otherRune);
					else
						tmpID = otherRune.workingID;
						otherRune.workingID = self.workingID;
						self.workingID = tmpID;
						Engraved.Rune_Activate(self);
						Engraved.Rune_Inactivate(otherRune);
						Engraved.Rune_UpdateType(self);
						Engraved.Rune_UpdateType(otherRune);
					end

				end

			else
				if ( not usable ) then
					Engraved.Rune_Inactivate(self)
				else
					Engraved.Rune_Activate(self)
				end
			end

		end

	elseif ( event == "RUNE_TYPE_UPDATE" ) then
		local runeID = ...;
		if ( runeID == self.workingID ) then
			Engraved.Rune_UpdateType(self);
		end

	end

end

function Engraved.Rune_Activate(rune)
	rune.fill:SetAlpha(1);
	rune.innerGlow:Show();
	rune.glow:Show();
end

function Engraved.Rune_Inactivate(rune)
	rune.innerGlow:Hide();
	rune.glow:Hide();
	if ( rune.timerMethod == "Fill" ) then
		rune:SetScript("OnUpdate", Engraved.Rune_OnUpdate_FillUp);
	else
		rune:SetScript("OnUpdate", Engraved.Rune_OnUpdate_AlmostReady);
	end
end

function Engraved.Rune_OnUpdate_AlmostReady(self, elapsed)
	local start, duration, usable = GetRuneCooldown(self.workingID);
	if ( ( start + duration - GetTime() ) > self.almostTime ) then
		self.fill:SetAlpha(self.unusableOpacity);
	else
		self.fill:SetAlpha(self.almostOpacity);
		self:SetScript("OnUpdate", nil);
	end
end

function Engraved.Rune_OnUpdate_FillUp(self, elapsed)
	local start, duration, usable = GetRuneCooldown(self.workingID);
	if ( not usable ) then
		self.fill:SetHeight( ENGRAVED.FILL_SIZE * (0.75*(GetTime() - start)/duration + 0.125) ); 
		self.fill:SetTexCoord( 0, 1, 0.875 - ((GetTime() - start)/duration)*0.75, 1 );
		self.fill:SetAlpha(self.almostOpacity);
	else
		self.fill:SetHeight(ENGRAVED.FILL_SIZE);
		self.fill:SetTexCoord(0, 1, 0, 1);
		self.fill:SetAlpha(1);
		self:SetScript("OnUpdate", nil);
	end
end


function Engraved.Rune_UpdateType(rune)
	local runeType = GetRuneType(rune.workingID);
	rune.fill:SetVertexColor(unpack(Engraved_Settings.RuneColor[runeType]));
	rune.glow:SetVertexColor(unpack(Engraved_Settings.RuneColor[runeType]));
end





