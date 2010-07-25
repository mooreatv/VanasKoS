﻿--[[----------------------------------------------------------------------
      WarnFrame Module - Part of VanasKoS
Creates the WarnFrame to alert of nearby KoS, Hostile and Friendly
------------------------------------------------------------------------]]

local L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS/WarnFrame", false);

local SML = LibStub("LibSharedMedia-3.0");

-- Global wow strings
local LEVEL = LEVEL

VanasKoSWarnFrame = VanasKoS:NewModule("WarnFrame", "AceEvent-3.0", "AceTimer-3.0");

local VanasKoSWarnFrame = VanasKoSWarnFrame;
local VanasKoS = VanasKoS;

local WARN_BUTTONS_MAX = 40;

local warnFrame = nil;
local normalFont = nil;
local kosFont = nil;
local enemyFont = nil;
local friendlyFont = nil;
local warnButtonsOOC = nil;
local warnButtonsCombat = nil;
local classIcons = nil;
local tooltipFrame = nil;
local testFontFrame = nil;
local testFontString = nil;

local nearbyKoS = nil;
local nearbyEnemy = nil;
local nearbyFriendly = nil;
local nearbyKoSCount = 0;
local nearbyEnemyCount = 0;
local nearbyFriendlyCount = 0;

local dataCache = nil;
local buttonData = nil;

local timer = nil;
local currentButtonCount = 0;
local CursorPosition, gsub, strfind = CursorPosition, gsub, strfind
local InCombatLockdown = InCombatLockdown

local function GetColor(which)
	return VanasKoSWarnFrame.db.profile[which .. "R"], VanasKoSWarnFrame.db.profile[which .. "G"], VanasKoSWarnFrame.db.profile[which .. "B"], VanasKoSWarnFrame.db.profile[which .. "A"];
end

local function SetBgColor(which, r, g, b, a)
	warnFrame:SetBackdropColor(r, g, b, a);

	VanasKoSWarnFrame.db.profile[which .. "R"] = r;
	VanasKoSWarnFrame.db.profile[which .. "G"] = g;
	VanasKoSWarnFrame.db.profile[which .. "B"] = b;
	VanasKoSWarnFrame.db.profile[which .. "A"] = a;
end

local function CreateWarnFrameFonts(size)
	if (testFontFrame == nil) then
		testFontFrame = CreateFrame("Button", nil, UIParent);
		testFontFrame:SetText("XXXXXXXXXXXX [00+]");
		testFontFrame:Hide();
	end

	if (kosFont == nil) then
		kosFont = CreateFont("VanasKoS_FontKos");
		kosFont:SetFont(SML:Fetch("font"), size);
	end	
	kosFont:SetTextColor(VanasKoSWarnFrame.db.profile.KoSTextColorR,
				VanasKoSWarnFrame.db.profile.KoSTextColorG,
				VanasKoSWarnFrame.db.profile.KoSTextColorB);

	if (enemyFont == nil) then
		enemyFont = CreateFont("VanasKoS_FontEnemy");
		enemyFont:SetFont(SML:Fetch("font"), size);
	end
	enemyFont:SetTextColor(VanasKoSWarnFrame.db.profile.EnemyTextColorR,
				VanasKoSWarnFrame.db.profile.EnemyTextColorG,
				VanasKoSWarnFrame.db.profile.EnemyTextColorB);

	if (friendlyFont == nil) then
		friendlyFont = CreateFont("VanasKoS_FontFriendly");
		friendlyFont:SetFont(SML:Fetch("font"), size);
	end
	friendlyFont:SetTextColor(VanasKoSWarnFrame.db.profile.FriendlyTextColorR,
				VanasKoSWarnFrame.db.profile.FriendlyTextColorG,
				VanasKoSWarnFrame.db.profile.FriendlyTextColorB);

	if (normalFont == nil) then
		normalFont = CreateFont("VanasKoS_FontNormal");
		normalFont:SetFont(SML:Fetch("font"), size);
	end
	normalFont:SetTextColor(VanasKoSWarnFrame.db.profile.NormalTextColorR,
				VanasKoSWarnFrame.db.profile.NormalTextColorG,
				VanasKoSWarnFrame.db.profile.NormalTextColorB);

	testFontFrame:SetNormalFontObject("VanasKoS_FontNormal");
	local h = math.floor(testFontFrame:GetTextHeight() + 5);
	local w = math.floor(testFontFrame:GetTextWidth() + 5) + h;
	VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT = h;
	VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH = w;
end

local function SetTextColor(which, r, g, b)
	VanasKoSWarnFrame.db.profile[which .. "R"] = r;
	VanasKoSWarnFrame.db.profile[which .. "G"] = g;
	VanasKoSWarnFrame.db.profile[which .. "B"] = b;

	CreateWarnFrameFonts(VanasKoSWarnFrame.db.profile.FontSize)
end

local function GetTooltipText(name, data)
	local result = "";
	local data = VanasKoS:GetPlayerData(name);
	
	if (data and data.level ~= nil) then
		result = result .. LEVEL .. " " .. data.level .. " ";
	end
	if (data and data.race ~= nil) then
		result = result .. data.race .. " ";
	end
	if (data and data.class ~= nil) then
		result = result .. data.class .. " ";
	end
	if (data and data.guild ~= nil) then
		result = result .. "<" .. data.guild .. "> ";
	end

	local playerkos = VanasKoS:IsOnList("PLAYERKOS", name) and VanasKoS:IsOnList("PLAYERKOS", name).reason;
	local nicelist = VanasKoS:IsOnList("NICELIST", name) and VanasKoS:IsOnList("NICELIST", name).reason;
	local hatelist = VanasKoS:IsOnList("HATELIST", name) and VanasKoS:IsOnList("HATELIST", name).reason;
	local guildkos = nil;
	if (showDetails and data.guild) then
		guildkos = VanasKoS:IsOnList("GUILDKOS", data.guild) and VanasKoS:IsOnList("GUILDKOS", data.guild).reason;
	end

	local reason = nil;
	if (playerkos ~= nil) then
		reason = playerkos;
	elseif (nicelist ~= nil) then
		reason = nicelist;
	elseif (hatelist ~= nil) then
		reason = hatelist;
	elseif (guildkos ~= nil) then
		reason = guildkos;
	end

	if (reason ~= nil) then
		result = result .. "(" .. reason .. ") ";
	end

	if(result == "") then
		result = L["No Information Available"];
	end

	return result;
end

local function UpdateTooltipPosition()
	if(not VanasKoSWarnFrame.db.profile.ShowMouseOverInfos) then
		if(tooltipFrame:IsVisible()) then
			tooltipFrame:Hide();
		end
		return;
	end

	tooltipFrame:ClearAllPoints();

	local x, y = GetCursorPosition(); -- gets coordinates based on WorldFrame position
	local scale = UIParent:GetEffectiveScale();

	if(WorldFrame:GetRight() < (x + (tooltipFrame:GetTextWidth()+10)*scale)) then
		tooltipFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", x/scale, y/scale + 5);
	else
		tooltipFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x/scale, y/scale + 5);
	end
end

local function ShowTooltip(buttonNr)
	if(not VanasKoSWarnFrame.db.profile.ShowMouseOverInfos) then
		if(tooltipFrame:IsVisible()) then
			tooltipFrame:Hide();
		end
		return;
	end

	local name = buttonData[buttonNr];
	tooltipFrame:SetText(GetTooltipText(name), dataCache[name]);

	UpdateTooltipPosition();

	tooltipFrame:SetWidth(tooltipFrame:GetTextWidth()+10);
	tooltipFrame:SetHeight(VanasKoSWarnFrame.db.profile.WARN_TOOLTIP_HEIGHT);

	tooltipFrame:Show();
end

local function SetProperties(self, profile)
	if(self == nil) then
		return;
	end

	self:SetWidth(profile.WARN_FRAME_WIDTH);
	self:SetHeight(profile.WARN_BUTTONS * profile.WARN_BUTTON_HEIGHT +
			    profile.WARN_FRAME_HEIGHT_PADDING * 2 + 1);
	if(profile.WARN_FRAME_POINT) then
		VanasKoS_WarnFrame:ClearAllPoints();
		self:SetPoint(profile.WARN_FRAME_POINT,
					"UIParent",
					profile.WARN_FRAME_ANCHOR,
					profile.WARN_FRAME_XOFF,
					profile.WARN_FRAME_XOFF);
	else
		self:SetPoint("CENTER");
	end

	if(profile.WarnFrameBorder) then
		VanasKoS_WarnFrame:SetBackdrop( {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
					insets = { left = 5, right = 4, top = 5, bottom = 5 },
		});
		self:EnableMouse(true);
	else
		VanasKoS_WarnFrame:SetBackdrop({bgfile = nil, edgeFile = nil});
		self:EnableMouse(false);
	end

	-- set the default backdrop color
	local r, g, b, a = GetColor("DefaultBGColor");
	self:SetBackdropColor(r, g, b, a);
	self:Hide();
end

local function CreateWarnFrame()
	if(warnFrame ~= nil) then
		return;
	end
	-- Create the Main Window
	warnFrame = CreateFrame("Button", "VanasKoS_WarnFrame", UIParent);
	warnFrame:SetToplevel(true);
	warnFrame:SetMovable(true);
	warnFrame:SetFrameStrata("LOW");

	-- allow dragging the window
	warnFrame:RegisterForDrag("LeftButton");
	warnFrame:SetScript("OnDragStart", function()
						if(VanasKoSWarnFrame.db.profile.Locked) then
							return;
						end
						warnFrame:StartMoving();
					end);
	warnFrame:SetScript("OnDragStop", function()
						warnFrame:StopMovingOrSizing();
						local point, _, anchor, xOff, yOff = warnFrame:GetPoint()
						VanasKoSWarnFrame.db.profile.WARN_FRAME_POINT = point
						VanasKoSWarnFrame.db.profile.WARN_FRAME_ANCHOR = anchor
						VanasKoSWarnFrame.db.profile.WARN_FRAME_XOFF = xOff
						VanasKoSWarnFrame.db.profile.WARN_FRAME_YOFF = yOff
					end);

	SetProperties(warnFrame, VanasKoSWarnFrame.db.profile);
end

local function CreateTooltipFrame()
	if(tooltipFrame) then
		return;
	end

	tooltipFrame = CreateFrame("Button", nil, UIParent);
	tooltipFrame:SetWidth(400);
	tooltipFrame:SetHeight(VanasKoSWarnFrame.db.profile.WARN_TOOLTIP_HEIGHT);
	tooltipFrame:SetPoint("CENTER");
	tooltipFrame:SetFrameStrata("DIALOG");
	tooltipFrame:SetToplevel(true);
	tooltipFrame:SetBackdrop( {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 4, top = 5, bottom = 5 }
	});
	local r, g, b, a = GetColor("DefaultBGColor");
	tooltipFrame:SetBackdropColor(r, g, b, a);
	tooltipFrame:SetNormalFontObject("GameFontWhite");

	tooltipFrame:Hide();
end

-- tnx to pitbull =)
local classIconNameToCoords = {
	["WARRIOR"] = {0, 0.25, 0, 0.25},
	["MAGE"] = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"] = {0, 0.25, 0.25, 0.5},
	["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"] = {0, 0.25, 0.5, 0.75},
	["DEATHKNIGHT"] = {0.25, 0.49609375, 0.5, 0.75},
}

local function CreateWarnFrameFonts(size)
	if (testFontFrame == nil) then
		testFontFrame = CreateFrame("Button", nil, UIParent);
		testFontFrame:SetText("XXXXXXXXXXXX [00+]");
		testFontFrame:Hide();
	end

	if (kosFont == nil) then
		kosFont = CreateFont("VanasKoS_FontKos");
		kosFont:SetFont(SML:Fetch("font"), size);
	end	
	kosFont:SetTextColor(VanasKoSWarnFrame.db.profile.KoSTextColorR,
				VanasKoSWarnFrame.db.profile.KoSTextColorG,
				VanasKoSWarnFrame.db.profile.KoSTextColorB);

	if (enemyFont == nil) then
		enemyFont = CreateFont("VanasKoS_FontEnemy");
		enemyFont:SetFont(SML:Fetch("font"), size);
	end
	enemyFont:SetTextColor(VanasKoSWarnFrame.db.profile.EnemyTextColorR,
				VanasKoSWarnFrame.db.profile.EnemyTextColorG,
				VanasKoSWarnFrame.db.profile.EnemyTextColorB);

	if (friendlyFont == nil) then
		friendlyFont = CreateFont("VanasKoS_FontFriendly");
		friendlyFont:SetFont(SML:Fetch("font"), size);
	end
	friendlyFont:SetTextColor(VanasKoSWarnFrame.db.profile.FriendlyTextColorR,
				VanasKoSWarnFrame.db.profile.FriendlyTextColorG,
				VanasKoSWarnFrame.db.profile.FriendlyTextColorB);

	if (normalFont == nil) then
		normalFont = CreateFont("VanasKoS_FontNormal");
		normalFont:SetFont(SML:Fetch("font"), size);
	end
	normalFont:SetTextColor(VanasKoSWarnFrame.db.profile.NormalTextColorR,
				VanasKoSWarnFrame.db.profile.NormalTextColorG,
				VanasKoSWarnFrame.db.profile.NormalTextColorB);

	testFontFrame:SetNormalFontObject("VanasKoS_FontNormal");
	local h = math.floor(testFontFrame:GetTextHeight() + 5);
	local w = math.floor(testFontFrame:GetTextWidth() + 5) + h;
	VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT = h;
	VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH = w;
end


local function CreateClassIcons()
	if(classIcons) then
		return;
	end

	classIcons = { };
	local i = 1;
	for i=1,WARN_BUTTONS_MAX do
			local classIcon = CreateFrame("Button", nil, warnFrame);
			classIcon:SetPoint("LEFT", warnButtonsCombat[i], "LEFT", 5, 0);
			classIcon:SetWidth(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
			classIcon:SetHeight(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);

			local texture = classIcon:CreateTexture(nil, "ARTWORK");
			texture:SetAllPoints(classIcon);
			texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");

			classIcon:Hide();

			classIcons[i] = { classIcon, texture };
		end
	end

	local function setButtonClassIcon(iconNr, class)
		if(class == nil) then
			classIcons[iconNr][1]:Hide();
			return;
		end

		local coords = classIconNameToCoords[class];
		if(not coords) then
			VanasKoS:Print("Unknown class " .. class);
			return;
		end
		classIcons[iconNr][2]:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		classIcons[iconNr][1]:Show();
	end

	local function CreateOOCButtons()
		if(warnButtonsOOC) then
			return;
		end
		warnButtonsOOC = { };
		
		local i=1;
		for i=1,WARN_BUTTONS_MAX do
			local warnButton = CreateFrame("Button", nil, warnFrame, "SecureActionButtonTemplate");
		if(i == 1) then
			warnButton:SetPoint("TOP", warnFrame, 0, -5);
		else
			warnButton:SetPoint("TOP", warnButtonsOOC[i-1], "BOTTOM", 0, 0);
		end

		warnButton:SetWidth(VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH);
		warnButton:SetHeight(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
		warnButton:EnableMouse(true);
		warnButton:SetFrameStrata("MEDIUM");
		warnButton:RegisterForClicks("AnyUp");
		warnButton:SetAttribute("type", "macro");
		warnButton:SetAttribute("macrotext", "/wave");

		warnButton:SetScript("OnEnter", function() ShowTooltip(i); end);
		warnButton:SetScript("OnLeave", function() tooltipFrame:Hide(); end);
		warnButton:SetScript("OnUpdate", function() UpdateTooltipPosition(); end);
		if (i <= currentButtonCount) then
			warnButton:Show();
		else
			warnButton:Hide();
		end

		warnButtonsOOC[i] = warnButton;
	end
end

local function CreateCombatButtons()
	if(warnButtonsCombat) then
		return;
	end
	warnButtonsCombat = { };

	local i = 0;
	for i=1,WARN_BUTTONS_MAX do
		local warnButton = CreateFrame("Button", nil, warnFrame);
		-- same size as OOC buttons
		warnButton:SetAllPoints(warnButtonsOOC[i]);
		warnButton:EnableMouse(true);
		warnButton:SetNormalFontObject("GameFontWhiteSmall");
		warnButton:RegisterForClicks("LeftButtonUp");
		warnButton:RegisterForClicks("RightButtonUp");
		warnButton:SetFrameStrata("HIGH");

		warnButton:SetScript("OnEnter", function() ShowTooltip(i); end);
		warnButton:SetScript("OnLeave", function() tooltipFrame:Hide(); end);

		warnButton:Hide();

		warnButtonsCombat[i] = warnButton;
	end
end

local function HideButton(buttonNr)
	if(not warnButtonsOOC or not warnButtonsOOC[buttonNr]) then
		return;
	end
	if(InCombatLockdown()) then
		warnButtonsOOC[buttonNr]:SetText("");
		warnButtonsOOC[buttonNr]:SetAlpha(0);
		warnButtonsCombat[buttonNr]:SetText("");
		warnButtonsCombat[buttonNr]:EnableMouse(false);
		warnButtonsCombat[buttonNr]:Hide();
	else
		warnButtonsOOC[buttonNr]:SetText("");
		warnButtonsOOC[buttonNr]:EnableMouse(false);
		warnButtonsOOC[buttonNr]:SetAlpha(0);
		warnButtonsOOC[buttonNr]:Hide();
		warnButtonsCombat[buttonNr]:SetText("");
		warnButtonsCombat[buttonNr]:EnableMouse(false);
		warnButtonsCombat[buttonNr]:Hide();
	end

	if (VanasKoSWarnFrame.db.profile.ShowClassIcons) then
		setButtonClassIcon(buttonNr, nil);
	end
	buttonData[buttonNr] = nil;
end

local function HideWarnFrame()
	if(not InCombatLockdown() and warnFrame:IsVisible()) then
		UIFrameFadeOut(warnFrame, 0.1, 1.0, 0.0);
		warnFrame.fadeInfo.finishedFunc = function() if(not InCombatLockdown()) then warnFrame:Hide(); end; end
	end
end

local function ShowWarnFrame()
	if(not InCombatLockdown() and not warnFrame:IsVisible()) then
		warnFrame:Show();
		UIFrameFadeIn(warnFrame, 0.1, 0.0, 1.0);
	end
end

local function UpdateWarnSize()
	local point, _, anchor, xOff, yOff = warnFrame:GetPoint();
	local oldH = warnFrame:GetHeight();
	warnFrame:SetWidth(VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH);
	local h = currentButtonCount * VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT +
				VanasKoSWarnFrame.db.profile.WARN_FRAME_HEIGHT_PADDING * 2 + 1;
	warnFrame:SetHeight(h);
	if(VanasKoSWarnFrame.db.profile.GrowUp) then
		if (point == "TOPRIGHT" or point == "TOP" or point == "TOPLEFT") then
			warnFrame:ClearAllPoints();
			warnFrame:SetPoint(point, "UIParent", anchor, xOff, yOff + h - oldH);

		elseif (point == "RIGHT" or point == "CENTER" or point == "LEFT") then
			warnFrame:ClearAllPoints();
			warnFrame:SetPoint(point, "UIParent", anchor, xOff, yOff + (h - oldH) / 2);
		end
	else
		if (point == "BOTTOMRIGHT" or point == "BOTTOM" or point == "BOTTOMLEFT") then
			warnFrame:ClearAllPoints();
			warnFrame:SetPoint(point, "UIParent", anchor, xOff, yOff - h + oldH);
		elseif (point == "RIGHT" or point == "CENTER" or point == "LEFT") then
			warnFrame:ClearAllPoints();
			warnFrame:SetPoint(point, "UIParent", anchor, xOff, yOff - (h - oldH) / 2);
		end
	end

	for i=currentButtonCount+1, WARN_BUTTONS_MAX do
		HideButton(i);
	end

	for i=1,WARN_BUTTONS_MAX do
		warnButtonsCombat[i]:SetWidth(VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH);
		warnButtonsCombat[i]:SetHeight(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
		warnButtonsOOC[i]:SetWidth(VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH);
		warnButtonsOOC[i]:SetHeight(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
		classIcons[i][1]:SetWidth(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
		classIcons[i][1]:SetHeight(VanasKoSWarnFrame.db.profile.WARN_BUTTON_HEIGHT);
	end
end

function VanasKoSWarnFrame:RegisterConfiguration()
	self.configOptions = {
		type = 'group',
		name = L["Warning Window"],
		desc = L["KoS/Enemy/Friendly Warning Window"],
		childGroups = 'tab',
		args = {
			locked = {
				type = 'toggle',
				name = L["Locked"],
				desc = L["Locked"],
				order = 1,
				set = function(frame, v) VanasKoSWarnFrame.db.profile.Locked = v; end,
				get = function() return VanasKoSWarnFrame.db.profile.Locked; end,
			},
			hideifinactive = {
				type = 'toggle',
				name = L["Hide if inactive"],
				desc = L["Hide if inactive"],
				order = 2,
				set = function(frame, v) VanasKoSWarnFrame.db.profile.HideIfInactive = v; VanasKoSWarnFrame:Update(); end,
				get = function() return VanasKoSWarnFrame.db.profile.HideIfInactive; end,
			},
			showBorder = {
				type = 'toggle',
				name = L["Show border"],
				desc = L["Show border"],
				order = 3,
				set = function(frame, v) 
					VanasKoSWarnFrame.db.profile.WarnFrameBorder = v;
					if (v == true) then
						VanasKoS_WarnFrame:SetBackdrop( {
							bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
							edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
							insets = { left = 5, right = 4, top = 5, bottom = 5 },
						});
						warnFrame:EnableMouse(true);
					else
						VanasKoS_WarnFrame:SetBackdrop({bgfile = nil, edgeFile = nil});
						warnFrame:EnableMouse(false);
					end
					VanasKoSWarnFrame:Update();
				end,
				get = function() return VanasKoSWarnFrame.db.profile.WarnFrameBorder; end,
			},
			growUp = {
				type = 'toggle',
				name = L["Grow list upwards"],
				desc = L["Grow list from the bottom of the WarnFrame"],
				order = 4,
				get = function() return VanasKoSWarnFrame.db.profile.GrowUp; end,
				set = function(frame, v)
					VanasKoSWarnFrame.db.profile.GrowUp = v;
					VanasKoSWarnFrame:Update();
				end,
			},
			hideInBattleground = {
				type = 'toggle',
				name = L["Hide in battleground"],
				desc = L["Hide in battlegrounds and pvp zones"],
				order = 5,
				get = function() return VanasKoSWarnFrame.db.profile.hideInBg; end,
				set = function(frame, v)
					VanasKoSWarnFrame.db.profile.hideInBg = v;
					VanasKoSWarnFrame:EnableZoneChangeEvent(v and VanasKoSWarnFrame.db.profile.hideInInstance);
					if(VanasKoS:IsInBattleground()) then
						VanasKoSWarnFrame:EnablePlayerDetectEvent(not v);
					end
				end
			},
			hideInInstance = {
				type = 'toggle',
				name = L["Hide in dungeon"],
				desc = L["Hide in dungeon instances"],
				order = 6,
				get = function() return VanasKoSWarnFrame.db.profile.hideInInstance; end,
				set = function(frame, v)
					VanasKoSWarnFrame.db.profile.hideInInstance = v;
					VanasKoSWarnFrame:EnableZoneChangeEvent(v and VanasKoSWarnFrame.db.profile.hideInBg);
					if(VanasKoS:IsInDungeon()) then
						VanasKoSWarnFrame:EnablePlayerDetectEvent(not v);
					end
				end
			},
			reset = {
				type = 'execute',
				name = L["Reset Position"],
				desc= L["Reset Position"],
				order = 7,
				func = function()
					VanasKoS_WarnFrame:ClearAllPoints();
					VanasKoS_WarnFrame:SetPoint("CENTER");
					VanasKoSWarnFrame.db.profile.WARN_FRAME_POINT = nil;
					VanasKoSWarnFrame.db.profile.WARN_FRAME_ANCHOR = nil;
					VanasKoSWarnFrame.db.profile.WARN_FRAME_XOFF = nil;
					VanasKoSWarnFrame.db.profile.WARN_FRAME_YOFF = nil;
				end,
			},
			contentGroup = {
				type = 'group',
				name = L["Content"],
				desc = L["What to show in the warning window"],
				order = 8,
				args = {
					setLines = {
						type = 'range',
						name = L["Number of lines"],
						desc = L["Sets the number of entries to display in the Warnframe"],
						order = 1,
						get = function() return VanasKoSWarnFrame.db.profile.WARN_BUTTONS; end,
						set = function(frame, v)
							VanasKoSWarnFrame.db.profile.WARN_BUTTONS = v;
							UpdateWarnSize();
							VanasKoSWarnFrame:Update();
						end,
						min = 1,
						max = WARN_BUTTONS_MAX,
						step = 1,
						isPercent = false,
					},
					dynamicResize = {
						type = 'toggle',
						name = L["Dynamic resize"],
						desc = L["Sets number of entries to display in the WarnFrame based on nearby player count"],
						order = 2,
						get = function() return VanasKoSWarnFrame.db.profile.DynamicResize; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.DynamicResize = v; end
					},
					contentShowLevel = {
						type = 'toggle',
						name = L["Show Target Level When Possible"],
						desc = L["Show Target Level When Possible"],
						order = 3,
						get = function() return VanasKoSWarnFrame.db.profile.ShowTargetLevel; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.ShowTargetLevel = v; VanasKoSWarnFrame:Update(); end
					},
					contentShowKoS = {
						type = 'toggle',
						name = L["Show KoS Targets"],
						desc = L["Show KoS Targets"],
						order = 4,
						get = function() return VanasKoSWarnFrame.db.profile.ShowKoS; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.ShowKoS = v; VanasKoSWarnFrame:Update(); end
					},
					contentShowHostile = {
						type = 'toggle',
						name = L["Show Hostile Targets"],
						desc = L["Show Hostile Targets"],
						order = 5,
						get = function() return VanasKoSWarnFrame.db.profile.ShowHostile; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.ShowHostile = v; VanasKoSWarnFrame:Update(); end
					},
					contentShowFriendly = {
						type = 'toggle',
						name = L["Show Friendly Targets"],
						desc = L["Show Friendly Targets"],
						order = 6,
						get = function() return VanasKoSWarnFrame.db.profile.ShowFriendly; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.ShowFriendly = v; VanasKoSWarnFrame:Update(); end
					},
					contentShowMouseOverInfos = {
						type = 'toggle',
						name = L["Show additional Information on Mouse Over"],
						desc = L["Toggles the display of additional Information on Mouse Over"],
						order = 7,
						get = function() return VanasKoSWarnFrame.db.profile.ShowMouseOverInfos; end,
						set = function(frame, v) VanasKoSWarnFrame.db.profile.ShowMouseOverInfos = v; VanasKoSWarnFrame:Update(); end
					},
					contentShowClassIcons = {
						type = 'toggle',
						name = L["Show class icons"],
						desc = L["Toggles the display of Class icons in the Warnframe"],
						order = 8,
						get = function() return VanasKoSWarnFrame.db.profile.ShowClassIcons; end,
						set = function(frame, v)
							VanasKoSWarnFrame.db.profile.ShowClassIcons = v;
							VanasKoSWarnFrame:Update();
							for i=1,currentButtonCount do
								setButtonClassIcon(i, nil);
							end
						end
					},
				},
			},
			designGroup = {
				type = 'group',
				name = L["Design"],
				desc = L["Controls the design of the warning window"],
				order = 9,
				args = {
					fontSize = {
						type = 'range',
						name = L["Font Size"],
						desc = L["Sets the size of the font in the Warnframe"],
						order = 1,
						get = function() return VanasKoSWarnFrame.db.profile.FontSize; end,
						set = function(frame, v)
							VanasKoSWarnFrame.db.profile.FontSize = v;
							CreateWarnFrameFonts(VanasKoSWarnFrame.db.profile.FontSize);
							UpdateWarnSize();
							VanasKoSWarnFrame:Update();
						end,
						min = 6,
						max = 20,
						step = 1,
						isPercent = false,
					},
					kos = {
						type = 'group',
						name = L["KoS"],
						desc = L["How kos content is shown"],
						order = 2,
						args = {
							designMoreKoSBackgroundColor = {
								type = 'color',
								name = L["Background Color"],
								desc = L["Sets the KoS majority Color and Opacity"],
								order = 1,
								get = function() return GetColor("MoreKoSBGColor"); end,
								set = function(frame, r, g, b, a) SetBgColor("MoreKoSBGColor", r, g, b, a); end,
								hasAlpha = true
							},
							kosTextColor = {
								type = 'color',
								name = L["Text"],
								desc = L["Sets the normal text color"],
								order = 2,
								get = function() return GetColor("KoSTextColor") end,
								set = function(frame, r, g, b) SetTextColor("KoSTextColor", r, g, b, 1.0); end,
								hasAlpha = false,
							},
							kosRemoveDelay = {
								type = 'range',
								name = L["Remove delay"],
								desc = L["Sets the number of seconds before entry is removed"],
								order = 3,
								get = function() return VanasKoSWarnFrame.db.profile.KoSRemoveDelay; end,
								set = function(frame, v)
									VanasKoSWarnFrame.db.profile.KoSRemoveDelay = v;
									VanasKoSWarnFrame:Update();
								end,
								min = 5,
								max = 300,
								step = 5,
								isPercent = false,
							},
							designKoSReset = {
								type = 'execute',
								name = L["Reset"],
								desc = L["Reset Settings"],
								order = 4,
								func = function()
									SetBgColor("MoreKoSBGColor", 1.0, 0.0, 0.0, 0.5);
									SetTextColor("KoSTextColor", 1.0, 0.82, 0.0);
									VanasKoSWarnFrame.db.profile.KoSRemoveDelay = 60;
									VanasKoSWarnFrame:Update();
								end,
							},
						},
					},
					hostile = {
						type = 'group',
						name = L["Hostile"],
						desc = L["How hostile content is shown"],
						order = 3,
						args = {
							designMoreHostilesBackdropBackgroundColor = {
								type = 'color',
								name = L["Background"],
								desc = L["Sets the more Hostiles than Allied Background Color and Opacity"],
								order = 1,
								get = function() return GetColor("MoreHostileBGColor"); end,
								set = function(frame, r, g, b, a) SetBgColor("MoreHostileBGColor", r, g, b, a); end,
								hasAlpha = true
							},
							enemyTextColor = {
								type = 'color',
								name = L["Text"],
								desc = L["Sets the normal text color"],
								order = 2,
								get = function() return GetColor("EnemyTextColor") end,
								set = function(frame, r, g, b) SetTextColor("EnemyTextColor", r, g, b, 1.0); end,
								hasAlpha = false,
							},
							enemyRemoveDelay = {
								type = 'range',
								name = L["Remove delay"],
								desc = L["Sets the number of seconds before entry is removed"],
								order = 3,
								get = function() return VanasKoSWarnFrame.db.profile.EnemyRemoveDelay; end,
								set = function(frame, v)
									VanasKoSWarnFrame.db.profile.EnemyRemoveDelay = v;
									VanasKoSWarnFrame:Update();
								end,
								min = 5,
								max = 300,
								step = 5,
								isPercent = false,
							},
							designEnemyReset = {
								type = 'execute',
								name = L["Reset"],
								desc = L["Reset Settings"],
								order = 4,
								func = function()
									SetBgColor("MoreHostileBGColor", 1.0, 0.0, 0.0, 0.5);
									SetTextColor("EnemyTextColor", 0.9, 0.0, 0.0);
									VanasKoSWarnFrame.db.profile.EnemyRemoveDelay = 10;
									VanasKoSWarnFrame:Update();
								end,
							},
						},
					},
					friendly = {
						type = 'group',
						name = L["Friendly"],
						desc = L["How friendly content is shown"],
						order = 4,
						args = {
							designMoreAlliedBackdropBackgroundColor = {
								type = 'color',
								name = L["Background Color"],
								desc = L["Sets the more Allied than Hostiles Background Color and Opacity"],
								order = 1,
								get = function() return GetColor("MoreAlliedBGColor"); end,
								set = function(frame, r, g, b, a) SetBgColor("MoreAlliedBGColor", r, g, b, a); end,
								hasAlpha = true
							},
							frendlyTextColor = {
								type = 'color',
								name = L["Text"],
								desc = L["Sets the normal text color"],
								order = 2,
								get = function() return GetColor("FriendlyTextColor") end,
								set = function(frame, r, g, b) SetTextColor("FriendlyTextColor", r, g, b, 1.0); end,
								hasAlpha = false,
							},
							friendlyRemoveDelay = {
								type = 'range',
								name = L["Remove delay"],
								desc = L["Sets the number of seconds before entry is removed"],
								order = 3,
								get = function() return VanasKoSWarnFrame.db.profile.FriendlyRemoveDelay; end,
								set = function(frame, v)
									VanasKoSWarnFrame.db.profile.FriendlyRemoveDelay = v;
									VanasKoSWarnFrame:Update();
								end,
								min = 5,
								max = 300,
								step = 5,
								isPercent = false,
							},
							designFriendlyReset = {
								type = 'execute',
								name = L["Reset"],
								desc = L["Reset Settings"],
								order = 4,
								func = function()
									SetBgColor("MoreAlliedBGColor", 0.0, 1.0, 0.0, 0.5);
									SetTextColor("FriendlyTextColor", 0.0, 1.0, 0.0);
									VanasKoSWarnFrame.db.profile.FriendlyRemoveDelay = 10;
									VanasKoSWarnFrame:Update();
								end,
							},
						},
					},
					neutral = {
						type = 'group',
						name = L["Neutral"],
						desc = L["How neutral content is shown"],
						order = 5,
						args = {
							designDefaultBackdropBackgroundColor = {
								type = 'color',
								name = L["Background"],
								desc = L["Sets the default Background Color and Opacity"],
								order = 1,
								get = function() return GetColor("DefaultBGColor") end,
								set = function(frame, r, g, b, a) SetBgColor("DefaultBGColor", r, g, b, a); end,
								hasAlpha = true,
							},
							normalTextColor = {
								type = 'color',
								name = L["Text"],
								desc = L["Sets the normal text color"],
								order = 2,
								get = function() return GetColor("NormalTextColor") end,
								set = function(frame, r, g, b) SetTextColor("NormalTextColor", r, g, b, 1.0); end,
								hasAlpha = false,
							},
							designNormalReset = {
								type = 'execute',
								name = L["Reset"],
								desc = L["Reset Settings"],
								order = 4,
								func = function()
									SetBgColor("DefaultBGColor", 0.5, 0.5, 1.0, 0.5);
									SetTextColor("NormalTextColor", 1.0, 1.0, 1.0);
								end,
							},
						},
					},
				},
			},
			macroGroup = {
				type = 'group',
				name = L["Macro"],
				desc = L["Macro to execute on click"],
				order = 10,
				args = {
					macroInfo = {
						type = 'description',
						name = L["Sets the text of the macro to be executed when a name is clicked. An example can be found in the macros.txt file"],
						order = 1,
					},
					macroText = {
						type ='input',
						name = L["Macro Text"],
						multiline = 8,
						order = 2,
						width = "full",
						get = function() return VanasKoSWarnFrame.db.profile.MacroText; end,
						set = function(frame, text)
							VanasKoSWarnFrame.db.profile.MacroText = text;
							VanasKoSWarnFrame:Update();
						end,
					},
					macroReset = {
						type = 'execute',
						name = L["Reset"],
						desc = L["Reset macro to default"],
						order = 3,
						func = function()
							self.db.profile.MacroText = "/targetexact ${name}";
						end,
					},
				},
			},
		},
	};

	VanasKoSGUI:AddModuleToggle("WarnFrame", L["Warning Window"]);
	VanasKoSGUI:AddConfigOption("WarnFrame", self.configOptions);
end

function VanasKoSWarnFrame:OnInitialize()
	self.db = VanasKoS.db:RegisterNamespace("WarnFrame", {
		profile = {
			Enabled = true,
			HideIfInactive = false,
			Locked = false,
			WarnFrameBorder = true,

			ShowTargetLevel = true,
			ShowKoS = true,
			ShowHostile = true,
			ShowFriendly = true,
			ShowMouseOverInfos = false,
			ShowClassIcons = true,
			GrowUp = false,

			DefaultBGColorR = 0.5,
			DefaultBGColorG = 0.5,
			DefaultBGColorB = 1.0,
			DefaultBGColorA = 0.5,

			MoreHostileBGColorR = 1.0,
			MoreHostileBGColorG = 0.0,
			MoreHostileBGColorB = 0.0,
			MoreHostileBGColorA = 0.5,

			MoreAlliedBGColorR = 0.0,
			MoreAlliedBGColorG = 1.0,
			MoreAlliedBGColorB = 0.0,
			MoreAlliedBGColorA = 0.5,

			MoreKoSBGColorR = 1.0,
			MoreKoSBGColorG = 0.0,
			MoreKoSBGColorB = 0.0,
			MoreKoSBGColorA = 0.5,

			EnemyTextColorR = 0.9,
			EnemyTextColorG = 0.0,
			EnemyTextColorB = 0.0,

			FriendlyTextColorR = 0.0,
			FriendlyTextColorG = 1.0,
			FriendlyTextColorB = 0.0,

			KoSTextColorR = 1.0,
			KoSTextColorG = 0.82,
			KoSTextColorB = 0.0,

			NormalTextColorR = 1.0,
			NormalTextColorG = 1.0,
			NormalTextColorB = 1.0,

			FriendlyRemoveDelay = 10,
			EnemyRemoveDelay = 10,
			KoSRemoveDelay = 60,

			FontSize = 10;
			WARN_FRAME_WIDTH = 130;
			WARN_FRAME_WIDTH_PADDING = 5;
			WARN_FRAME_WIDTH_EMPTY = 130;
			WARN_FRAME_HEIGHT_PADDING = 5;
			WARN_FRAME_HEIGHT_EMPTY = 5;

			WARN_TOOLTIP_HEIGHT = 24;

			WARN_BUTTON_HEIGHT = 16;
			WARN_BUTTONS = 5;

			MacroText = "/targetexact ${name}";
		}
	});

	nearbyKoS = { };
	nearbyEnemy = { };
	nearbyFriendly = { };
	dataCache = { };
	buttonData = { };

	CreateWarnFrame();
	self:RegisterConfiguration();
	
	self:SetEnabledState(self.db.profile.Enabled);
  	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function VanasKoSWarnFrame:OnEnable()
	CreateOOCButtons();
	CreateCombatButtons();
	CreateTooltipFrame();
	CreateClassIcons();
	CreateWarnFrameFonts(self.db.profile.FontSize);
	warnFrame:SetAlpha(1);
	self:Update();

	self:EnableZoneChangeEvent(self.db.profile.hideInBg or self.db.profile.hideInInstance);

	if(self.db.profile.hideInBg and VanasKoS:IsInBattleground()) then
		timer = nil;
		HideWarnFrame();
		self:EnablePlayerDetectEvent(false);
	elseif(self.db.profile.hideInInstance and VanasKoS:IsInDungeon()) then
		timer = nil;
		HideWarnFrame();
		self:EnablePlayerDetectEvent(false);
	else
		if (not timer) then
			timer = self:ScheduleRepeatingTimer("UpdateList", 1);
		end
		self:EnablePlayerDetectEvent(true);
	end

	self:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function VanasKoSWarnFrame:OnDisable()
	self:UnregisterAllEvents();
	self:CancelAllTimers();
	timer = nil;

	currentButtonCount = 0;
	wipe(nearbyKoS);
	wipe(nearbyEnemy);
	wipe(nearbyFriendly);
	wipe(dataCache);
	wipe(buttonData);
	
	self:Update();
	warnFrame:Hide();
end

function VanasKoSWarnFrame:RefreshConfig()
	SetProperties(warnFrame, self.db.profile);
	CreateWarnFrameFonts(VanasKoSWarnFrame.db.profile.FontSize);
	UpdateWarnSize();
	self:Update()
end

function VanasKoSWarnFrame:PLAYER_REGEN_ENABLED(event) -- ...
	self:Update();
end

local function RemovePlayer(name)
	if(nearbyKoS[name]) then
		nearbyKoS[name] = nil;
		nearbyKoSCount = nearbyKoSCount - 1;
	end

	if(nearbyEnemy[name]) then
		nearbyEnemy[name] = nil;
		nearbyEnemyCount = nearbyEnemyCount - 1;
	end

	if(nearbyFriendly[name]) then
		nearbyFriendly[name] = nil;
		nearbyFriendlyCount = nearbyFriendlyCount - 1;
	end

	if(dataCache[name]) then
		wipe(dataCache[name]);
		dataCache[name] = nil;
	end
end

function VanasKoSWarnFrame:UpdateList()
	local t = time();
	for k, v in pairs(nearbyKoS) do
		if(t-v > self.db.profile.KoSRemoveDelay) then
			RemovePlayer(k);
		end
	end
	for k, v in pairs(nearbyEnemy) do
		if(t-v > self.db.profile.EnemyRemoveDelay) then
			RemovePlayer(k);
		end
	end
	for k, v in pairs(nearbyFriendly) do
		if(t-v > self.db.profile.FriendlyRemoveDelay) then
			RemovePlayer(k);
		end
	end
	
	VanasKoSWarnFrame:Update();
end


-- /Script VanasKoSWarnFrame:Player_Detected("xxx", nil, "enemy"); VanasKoSWarnFrame:Player_Detected("xxx2", nil, "enemy");
-- /script local x = {  ['name'] = 'x', ['faction'] = 'enemy', ['class'] = 'Poser',  ['race'] = 'GM', ['level'] = "31336"} ; for i=1,10000 do x.name = "xxx" .. math.random(1, 1000); VanasKoSWarnFrame:Player_Detected("VanasKoS_Player_Detected", x); end
local UNKNOWNLOWERCASE = UNKNOWN:lower();


function VanasKoSWarnFrame:Player_Detected(message, data)
	if(not self.db.profile.Enabled) then
		return;
	end

	assert(data.name ~= nil);

	local name = data.name:trim():lower();
	local faction = data.faction;

	-- exclude unknown entitity entries
	if(name == UNKNOWNLOWERCASE) then
		return;
	end

	if(faction == "kos" and self.db.profile.ShowKoS) then
		if(not nearbyKoS[name]) then
			nearbyKoSCount = nearbyKoSCount + 1;
		end
		nearbyKoS[name] = time();
	elseif(faction == "enemy" and self.db.profile.ShowHostile) then
		if(not nearbyEnemy[name]) then
			nearbyEnemyCount = nearbyEnemyCount + 1;
		end
		nearbyEnemy[name] = time();
	elseif(faction == "friendly" and self.db.profile.ShowFriendly) then
		if(not nearbyFriendly[name]) then
			nearbyFriendlyCount = nearbyFriendlyCount + 1;
		end
		nearbyFriendly[name] = time();
	else
		return;
	end

	if (not dataCache[name]) then
		dataCache[name] = { };
	end
	dataCache[name].name = data.name:trim();
	dataCache[name].realm = data.realm;
	dataCache[name].guild = data.guild;
	dataCache[name].guildrank = data.guildrank;
	dataCache[name].class = data.class;
	dataCache[name].classEnglish = data.classEnglish;
	dataCache[name].race = data.race;
	dataCache[name].gender = data.gender;
	dataCache[name].faction = faction;
	dataCache[name].level = data.level;
	
	self:Update();
end

local playerDetectEventEnabled = false;
function VanasKoSWarnFrame:EnablePlayerDetectEvent(enable)
	if (enable and (not playerDetectEventEnabled)) then
		self:RegisterMessage("VanasKoS_Player_Detected", "Player_Detected");
		playerDetectEventEnabled = true;
	elseif ((not enable) and playerDetectEventEnabled) then
		self:UnregisterMessage("VanasKoS_Player_Detected");
		playerDetectEventEnabled = false;
	end
end

local zoneChangeEventEnabled = false;
function VanasKoSWarnFrame:EnableZoneChangeEvent(enable)
	if (enable and (not zoneChangeEventEnabled)) then
		self:RegisterMessage("VanasKoS_Zone_Changed", "ZoneChanged");
		zoneChangeEventEnabled = true;
	elseif ((not enable) and zoneChangeEventEnabled) then
		self:UnregisterMessage("VanasKoS_Zone_Changed");
		zoneChangeEventEnabled = false;
	end
end

function VanasKoSWarnFrame:ZoneChanged(message)
	if(self.db.profile.hideInBg and VanasKoS:IsInBattleground()) then
		HideWarnFrame();
		if (timer) then
			self:CancelTimer(timer);
			timer = nil;
		end
		self:EnablePlayerDetectEvent(false)
	elseif(self.db.profile.hideInInstance and VanasKoS:IsInDungeon()) then
		HideWarnFrame();
		if (timer) then
			self:CancelTimer(timer);
			timer = nil;
		end
		self:EnablePlayerDetectEvent(false)
	else
		if (not timer) then
			timer = self:ScheduleRepeatingTimer("UpdateList", 1);
		end
		self:EnablePlayerDetectEvent(true)
	end

end

local function GetButtonText(name, data)
	assert(name ~= nil);
	_, _, player, realm = strfind(name, "([^-]+)[-]?(.*)");
	local result = string.Capitalize(player);

	if(VanasKoSWarnFrame.db.profile.ShowTargetLevel) then
		local level = nil;

		-- If there is a player level coming in, record it.
		if (data and data.level and data.level ~= "") then
			level = data.level;
			if (tonumber(level) == -1) then
				level = "??";
			end
		else
			local pdata = VanasKoS:GetPlayerData(name);
			if (pdata and pdata.level) then
				level = pdata.level
			end
		end


		-- If we have a level, append it.
		if (level) then
			result = result .. " [" .. tostring(level) .. "]";
		end

		-- TODO: lookup in last seen list
	end

	return result;
end

local function GetFactionFont(faction)
	if(faction == "kos") then
		return "VanasKoS_FontKos";
	elseif(faction == "enemy") then
		return "VanasKoS_FontEnemy";
	elseif(faction == "friendly") then
		return "VanasKoS_FontFriendly";
	end

	return "VanasKoS_FontNormal";
end

local function SetButton(buttonNr, name, faction, data)
	-- This screws with the map too much, calling SetMapToCurrentZone is
	-- required to get good coordinates, but this is simply called to often
	-- and makes the map unusable in some zones, and makes the map dropdown
	-- stop working.

	-- local c = GetCurrentMapContinent();
	-- local z = GetCurrentMapZone();
	-- SetMapToCurrentZone();
	local zx, zy = GetPlayerMapPosition("player");
	-- SetMapZoom(c, z)
	local wx, wy = GetPlayerMapPosition
	if(InCombatLockdown()) then
		warnFrame:SetBackdropBorderColor(1.0, 0.0, 0.0);
		if(buttonData[buttonNr] ~= name) then
			-- new data for the button, we have to do something
			if(warnButtonsOOC[buttonNr]:GetAlpha() > 0) then
				-- ooc button visible
				warnButtonsOOC[buttonNr]:SetAlpha(0);
			end

			warnButtonsCombat[buttonNr]:SetNormalFontObject(GetFactionFont(faction));
			warnButtonsCombat[buttonNr]:SetText(GetButtonText(name, data));
			warnButtonsCombat[buttonNr]:Show();
		else
			warnButtonsOOC[buttonNr]:SetText(GetButtonText(name, data));
			warnButtonsCombat[buttonNr]:SetText(GetButtonText(name, data));
		end
	else
		warnFrame:SetBackdropBorderColor(0.8, 0.8, 0.8);
		if(buttonData[buttonNr] ~= name or warnButtonsOOC[buttonNr]:GetAlpha() == 0) then
			warnButtonsOOC[buttonNr]:SetAlpha(1);
			warnButtonsCombat[buttonNr]:Hide();
			warnButtonsOOC[buttonNr]:SetNormalFontObject(GetFactionFont(faction));
			warnButtonsOOC[buttonNr]:SetText(GetButtonText(name, data));
			warnButtonsOOC[buttonNr]:EnableMouse(true);
			local macroText = VanasKoSWarnFrame.db.profile.MacroText;
			_, _, player, realm = strfind(name, "([^-]+)[-]?(.*)");
			macroText = gsub(macroText, "${class}", (data and data.class) or "");
			macroText = gsub(macroText, "${classEnglish}", (data and data.classEnglish) or "");
			macroText = gsub(macroText, "${race}", (data and data.race) or "");
			macroText = gsub(macroText, "${guild}", (data and data.guild) or "");
			macroText = gsub(macroText, "${guildRank}", (data and data.guildRank) or "");
			macroText = gsub(macroText, "${level}", (data and data.level) or "");
			macroText = gsub(macroText, "${shortname}", player);
			macroText = gsub(macroText, "${realm}", realm);
			macroText = gsub(macroText, "${name}", name);
			macroText = gsub(macroText, "${gender}", (data and data.gender) or "");
			macroText = gsub(macroText, "${genderText}", data and (data.gender == 2 and L["male"]) or (data.gender == 3 and L["female"]) or "");
			macroText = gsub(macroText, "${realm}", (data and data.realm) or "");
			macroText = gsub(macroText, "${zoneX}", floor(zx * 100 + 0.5));
			macroText = gsub(macroText, "${zoneY}", floor(zy * 100 + 0.5));
			macroText = gsub(macroText, "${zone}", GetZoneText());
			warnButtonsOOC[buttonNr]:SetAttribute("macrotext", macroText);
			warnButtonsOOC[buttonNr]:Show();
		else
			warnButtonsOOC[buttonNr]:SetText(GetButtonText(name, data));
		end
	end

	buttonData[buttonNr] = name;
end

function VanasKoSWarnFrame:Update()
	local newButtonCount = 0;
	if(VanasKoSWarnFrame.db.profile.DynamicResize) then
		newButtonCount = nearbyKoSCount + nearbyEnemyCount + nearbyFriendlyCount + 1;
		if(newButtonCount > WARN_BUTTONS_MAX) then
			newButtonCount = WARN_BUTTONS_MAX;
		end
	else
		newButtonCount = VanasKoSWarnFrame.db.profile.WARN_BUTTONS;
	end

	if (newButtonCount ~= currentButtonCount and not InCombatLockdown()) then
		currentButtonCount = newButtonCount;
		UpdateWarnSize();
	end

	-- more hostile
	if( (nearbyKoSCount+nearbyEnemyCount) > (nearbyFriendlyCount)) then
		if (nearbyKoSCount > nearbyEnemyCount) then
			local r, g, b, a = GetColor("MoreKoSBGColor");
			warnFrame:SetBackdropColor(r, g, b, a);
		else
			local r, g, b, a = GetColor("MoreHostileBGColor");
			warnFrame:SetBackdropColor(r, g, b, a);
		end
	-- more allied
	elseif( (nearbyKoSCount+nearbyEnemyCount) < (nearbyFriendlyCount)) then
		local r, g, b, a = GetColor("MoreAlliedBGColor");
		warnFrame:SetBackdropColor(r, g, b, a);
	-- default
	else
		local r, g, b, a = GetColor("DefaultBGColor");
		warnFrame:SetBackdropColor(r, g, b, a);
	end

	local counter = 0;
	if(self.db.profile.GrowUp) then
		counter = currentButtonCount - 1;
	end
	if(self.db.profile.ShowKoS) then
		for k,v in pairs(nearbyKoS) do
			if(counter < currentButtonCount and counter >= 0) then
				SetButton(counter+1, k, "kos", dataCache[k]);
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache[k] and dataCache[k].classEnglish);
				end
			end

			if (self.db.profile.GrowUp == true) then
				counter = counter - 1;
			else
				counter = counter + 1;
			end
		end
	end

	if(self.db.profile.ShowHostile) then
		for k,v in pairs(nearbyEnemy) do
			if(counter < currentButtonCount and counter >= 0) then
				SetButton(counter+1, k, "enemy", dataCache[k]);
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache[k] and dataCache[k].classEnglish);
				end
			end

			if (self.db.profile.GrowUp == true) then
				counter = counter - 1;
			else
				counter = counter + 1;
			end
		end
	end

	if(self.db.profile.ShowFriendly) then
		for k,v in pairs(nearbyFriendly) do
			if(counter < currentButtonCount and counter >= 0) then
				SetButton(counter+1, k, "friendly", dataCache[k]);
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache[k] and dataCache[k].classEnglish);
				end
			end

			if (self.db.profile.GrowUp == true) then
				counter = counter - 1;
			else
				counter = counter + 1;
			end
		end
	end

	for i=0,currentButtonCount-1 do
		if ((i <= counter and self.db.profile.GrowUp == true) or
			(i >= counter and self.db.profile.GrowUp == false)) then
			HideButton(i+1);
		end
	end

	-- show or hide/fade frame according to settings
	if(self.db.profile.Enabled) then
		if(self.db.profile.hideInBg and VanasKoS:IsInBattleground()) then
			HideWarnFrame();
		elseif(self.db.profile.hideInInstance and VanasKoS:IsInDungeon()) then
			HideWarnFrame();
		elseif(self.db.profile.HideIfInactive) then
			if((counter > 0 and self.db.profile.GrowUp == false) or (counter < (currentButtonCount - 1) and self.db.profile.GrowUp == true)) then
				ShowWarnFrame();
			else
				HideWarnFrame();
			end
		else
			ShowWarnFrame();
		end
	else
		HideWarnFrame();
	end
end
