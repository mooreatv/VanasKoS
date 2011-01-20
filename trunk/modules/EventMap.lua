﻿--[[----------------------------------------------------------------------
      EventMap Module - Part of VanasKoS
Displays PvP Events on World Map
------------------------------------------------------------------------]]

local L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS/EventMap", false);

-- Global wow strings
local WIN, LOSS = WIN, LOSS

VanasKoSEventMap = VanasKoS:NewModule("EventMap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0");

local VanasIconFrame = nil;
local VanasKoSEventMap = VanasKoSEventMap;
local Cartographer3_Data = nil;
local zoneContinentZoneID = {};

local useIcons = nil;
local ICONSIZE = 16;
local DOTSIZE = 16;
local POIGRIDALIGN = 16;
VanasKoSEventMap.lastzoom = 20;
VanasKoSEventMap.lastzone = "";
VanasKoSEventMap.lastcontinent = "";
local trackedPlayers = { };


local function GetColor(which)
	return VanasKoSEventMap.db.profile[which .. "R"], VanasKoSEventMap.db.profile[which .. "G"], VanasKoSEventMap.db.profile[which .. "B"], VanasKoSEventMap.db.profile[which .. "A"];
end

local function SetColor(which, r, g, b, a)
	VanasKoSEventMap.db.profile[which .. "R"] = r;
	VanasKoSEventMap.db.profile[which .. "G"] = g;
	VanasKoSEventMap.db.profile[which .. "B"] = b;
	VanasKoSEventMap.db.profile[which .. "A"] = a;

	VanasKoSEventMap:RedrawMap();
end

function VanasKoSEventMap:POI_Resize(frame)
	if (useIcons) then
		frame:SetWidth(ICONSIZE);
		frame:SetHeight(ICONSIZE);
	else
		frame:SetWidth(DOTSIZE);
		frame:SetHeight(DOTSIZE);
	end
end

function VanasKoSEventMap:POI_OnShow(frame)
	frame:Resize(frame);
end

function VanasKoSEventMap:POI_OnClick(frame, button, down)
	if(button == "RightButton") then
		local x, y = GetCursorPosition();
		local uiScale = UIParent:GetEffectiveScale();
		local menuItems = {
			{
				text = L["Remove events"],
				func = function()
					VanasKoSEventMap:RemoveEventsInPOI(frame);
				end
			}
		};

		EasyMenu(menuItems, VanasKoSGUI.dropDownFrame, UIParent, x/uiScale, y/uiScale, "MENU");
	end
end

function VanasKoSEventMap:RemoveEventsInPOI(POI)
	local pvplog = VanasKoS:GetList("PVPLOG");
	for i, hash in ipairs(POI.event) do
		local event = pvplog.event[hash];
		if (event) then
			local remove = nil;
			if (event.enemyname) then
				for j, zhash in ipairs(pvplog.player[event.enemyname] or {}) do
					if (zhash == hash) then
						--print("removing " .. hash .. " from player log");
						tremove(pvplog.player[event.enemyname], j);
						break;
					end
					if (pvplog.player[event.enemyname] and next(pvplog.player[event.enemyname]) == nil) then
						pvplog.player[event.enemyname] = nil;
					end
				end
			end
		end
		if (event.zone) then
			for j, zhash in ipairs(pvplog.zone[event.zone] or {}) do
				if (zhash == hash) then
					--print("removing " .. hash .. " from pvp zone log");
					tremove(pvplog.zone[event.zone], j);
					break;
				end
			end
			if (pvplog.zone[event.zone] and next(pvplog.zone[event.zone]) == nil) then
				pvplog.zone[event.zone] = nil;
			end
		end
		pvplog.event[hash] = nil;
		removed = true;
	end
	wipe(POI.event);
	POI:Hide();
end

function VanasKoSEventMap:POI_OnEnter(frame, motion)
	if (not self.db.profile.showTooltip) then
		return
	end

	local anchor = "ANCHOR_RIGHT";
	if (WorldMapButton:GetCenter() < frame.x) then
		anchor = "ANCHOR_LEFT";
	end

	local tooltip = WorldMapTooltip
	tooltip:ClearLines();
	tooltip:SetOwner(frame, anchor);
	if(frame.trackedPlayer) then
		local name = frame.playerName;
		tooltip:AddLine(format("Tracking: %s (%s)", name,
					SecondsToTime(time() - trackedPlayers[name:lower()].lastseen)));
	else	
		tooltip:AddLine(format(L["PvP Encounter"]));

		local pvplog = VanasKoS:GetList("PVPLOG");
		for i, eventIdx in ipairs(frame.event) do
			local event = pvplog.event[eventIdx];
			local player = "";
			if (event.myname) then
				player = player .. event.myname;
			end
			if (event.mylevel) then
				player = player .. " (" .. event.mylevel .. ")";
			end

			local playerdata = VanasKoS:GetPlayerData(event.enemyname);
			local enemy = (playerdata and playerdata.displayname) or string.Capitalize(event.enemyname);
			local enemyNote = event.enemylevel or "";

			if (playerdata) then
				enemy = playerdata.displayname or string.Capitalize(event.enemyname);
				if (playerdata.guild) then
					enemy = enemy .. " <" .. playerdata.guild .. ">";
				end
				if (playerdata.race) then
					enemyNote = enemyNote .. " " .. playerdata.race;
				end
				if (playerdata.class) then
					enemyNote = enemyNote .. " " .. playerdata.class;
				end
			end

			if (enemyNote ~= "") then
				enemy = enemy .. " (" .. enemyNote .. ")";
			end

			if (event.type == "loss") then
				tooltip:AddLine(format(L["|cffff0000%s - %s killed by %s|r"], date("%c", event.time), player, enemy));
			elseif (event.type == "win") then
				tooltip:AddLine(format(L["|cff00ff00%s - %s killed %s|r"], date("%c", event.time), player, enemy));
			end
		end
	end
	WorldMapPOIFrame.allowBlobTooltip = false;
	tooltip:Show();
end

function VanasKoSEventMap:POI_OnLeave(frame)
	WorldMapTooltip:Hide();
	WorldMapPOIFrame.allowBlobTooltip = true;
end

function VanasKoSEventMap:CreatePOI(x, y)
	local POI = CreateFrame("Button", "VanasKoSEventMapPOI"..self.POICnt, VanasIconFrame);
	local id = self.POICnt + 1;
	POI:SetWidth(16);
	POI:SetHeight(16);
	POI:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	POI:SetFrameLevel(VanasIconFrame:GetFrameLevel() + 1);

	POI.Resize = function(frame) VanasKoSEventMap:POI_Resize(frame, id); end;
	POI:SetScript("OnEnter", function(self, motion) VanasKoSEventMap:POI_OnEnter(self, motion); end);
	POI:SetScript("OnLeave", function(self) VanasKoSEventMap:POI_OnLeave(self); end);
	POI:SetScript("OnClick", function(self, button, down) VanasKoSEventMap:POI_OnClick(self, button, down); end);
	POI:SetScript("OnShow", function(self, id) VanasKoSEventMap:POI_OnShow(self); end)
	POI:SetBackdrop({bgFile = "Interface\\Addons\\VanasKoS\\Artwork\\dot"});

	POI:SetBackdropColor(0, 0, 0, 0);
	if (useIcons) then
		POI.x = floor(x/POIGRIDALIGN) * POIGRIDALIGN;
		POI.y = floor(y/POIGRIDALIGN) * POIGRIDALIGN;
	else
		POI.x = x;
		POI.y = y;
	end

	POI.score = 0;
	POI.event = {};

	self.POIList[id] = POI;

	if (not self.POIGrid[POI.x]) then
		self.POIGrid[POI.x] = {[POI.y] = POI};
	else
		self.POIGrid[POI.x][POI.y] = POI;
	end
	self.POICnt = self.POICnt + 1;

	return self.POIList[id];
end

function VanasKoSEventMap:GetPOI(x, y)
	if (useIcons) then
		local xAlign = floor(x/POIGRIDALIGN) * POIGRIDALIGN;
		local yAlign = floor(y/POIGRIDALIGN) * POIGRIDALIGN;

		if (self.POIGrid[xAlign] and
		    self.POIGrid[xAlign][yAlign]) then
			return self.POIGrid[xAlign][yAlign];
		end

		self.POIUsed = self.POIUsed + 1;
		if (self.POIUsed <= self.POICnt) then
			local POI = self.POIList[self.POIUsed];
			POI.x = xAlign;
			POI.y = yAlign;
			if (not self.POIGrid[xAlign]) then
				self.POIGrid[xAlign] = {[yAlign] = POI};
			else
				self.POIGrid[xAlign][yAlign] = POI;
			end
			return POI;
		end
	else
		self.POIUsed = self.POIUsed + 1;
		if (self.POIUsed <= self.POICnt) then
			local POI = self.POIList[self.POIUsed];
			POI.x = x;
			POI.y = y;
			return POI;
		end
	end

	return self:CreatePOI(x, y);
end

function VanasKoSEventMap:drawPOI(POI)
	local alpha = 1;

	-- sanity check
	if (POI == nil) then
		return;
	end

	POI:Hide();
	POI:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", POI.x, POI.y);
	POI:SetFrameLevel(WorldMapPlayer:GetFrameLevel() - 1);
	
	if(POI.trackedPlayer) then
		POI:SetNormalTexture(nil);
		POI:SetBackdropColor(GetColor("LossColor"));
		POI:Resize();
		POI:Show();
		return;
	end
	
	if (not useIcons) then
		POI:SetNormalTexture(nil);
	else
		POI:SetBackdropColor(0, 0, 0, 0);
	end

	if (POI.score < 0) then
		if (useIcons) then
			POI:SetNormalTexture("Interface\\Addons\\VanasKoS\\Artwork\\loss");
		else
			POI:SetBackdropColor(GetColor("LossColor"));
		end
	elseif (POI.score > 0) then
		if (useIcons) then
			POI:SetNormalTexture("Interface\\Addons\\VanasKoS\\Artwork\\win");
		else
			POI:SetBackdropColor(GetColor("WinColor"));
		end
	else
		if (useIcons) then
			POI:SetNormalTexture("Interface\\Addons\\VanasKoS\\Artwork\\tie");
		else
			-- Hmmm this shouldn't have happened...
			POI:SetBackdropColor(0, 0, 0, 0);
		end
	end
	POI:Resize();
	POI:Show();
end

function VanasKoSEventMap:TrackPlayer(playername, continent, zone, posX, posY)
	--VanasKoS:Print(format("%s %d %d %f %f", playername, continent, zone, posX, posY));
	local playerData = trackedPlayers[playername:lower()];
	if(playerData == nil) then
		playerData = {
			['continent'] = continent,
			['zone'] = zone,
			['posX'] = posX,
			['posY'] = posY,
			['lastseen'] = time()
		};
		trackedPlayers[playername:lower()] = playerData;
	end
	
	self:RedrawMap();
end

function VanasKoSEventMap:CreateTrackingPoints()
	local mapWidth = WorldMapDetailFrame:GetWidth();
	local mapHeight = WorldMapDetailFrame:GetHeight();
	for k, v in pairs(trackedPlayers) do
		if(v.continent ~= GetCurrentMapContinent() or v.zone ~= GetCurrentMapZone()) then
			--VanasKoS:Print(format("break %d %d %d %d", v.continent, v.zone, GetCurrentMapContinent(), GetCurrentMapZone()));
		else 
			local x = v.posX * mapWidth;
			local y = -v.posY * mapHeight;
			local POI = self:GetPOI(x, y);

			POI.trackedPlayer = true;
			POI.show = true;
			POI.playerName = k;
			
			self:drawPOI(POI);
		end
	end
end

function VanasKoSEventMap:CreatePoints(enemyIdx)
	self:CreateTrackingPoints();

	local pvplog = VanasKoS:GetList("PVPLOG");
	local zoneid = GetCurrentMapZone();
	local zones = {GetMapZones(GetCurrentMapContinent())};
	local zoneName = zones and zones[zoneid];
	local drawAlts = self.db.profile.drawAlts;
	local mapWidth = WorldMapDetailFrame:GetWidth();
	local mapHeight = WorldMapDetailFrame:GetHeight();

	if (pvplog and pvplog.zone[zoneName]) then
		local i = 0;
		local myname = UnitName("player");
		local zonelog = pvplog.zone[zoneName] or {};
		for idx = enemyIdx, #zonelog do
			local event = pvplog.event[zonelog[idx]];
			if (drawAlts or event.myname == myname) then
				local x = event.posX * mapWidth;
				local y = -event.posY * mapHeight;
				local POI = self:GetPOI(x, y);
				if (event.type == "loss") then
					POI.score = POI.score - 1;
				elseif (event.type == "win") then
					POI.score = POI.score + 1;
				end
				POI.show = true;

				tinsert(POI.event, zonelog[idx]);
				self:drawPOI(POI);
			end
			i = i + 1;
			if (i >= 100) then
				self:ScheduleTimer("CreatePoints", 0, idx + 1);
				return;
			end
		end
	end

	VanasIconFrame:Show();
end

function VanasKoSEventMap:ClearEventMap()
	for i,POI in ipairs(self.POIList) do
		POI:Hide();
		POI.show = nil;
		POI.score = 0;
		wipe(POI.event);
		POI.x = 0;
		POI.y = 0;
	end
	wipe(self.POIGrid);
	self.POIUsed = 0;
	self:CancelAllTimers();
	VanasIconFrame:Hide();
end

function VanasKoSEventMap:RedrawMap()
	self.lastzone = "nowhere";
	self.lastcontinent = "nowhere";
	self:UpdatePOI();
end

function VanasKoSEventMap:UpdatePOI()
	local continent = GetCurrentMapContinent();
	local zone = GetCurrentMapZone();

	-- Only draw if the zone has changed
	if (self.lastzone == zone and self.lastcontinent == continent) then
		return
	end
	self.lastzone = zone;
	self.lastcontinent = continent;

	self:ClearEventMap();
	self:CreatePoints(1);
end

function VanasKoSEventMap:OnInitialize()
	self.db = VanasKoS.db:RegisterNamespace("EventMap", 
		{
			profile = {
				Enabled = true,
				drawAlts = true,
				dynamicZoom = true,
				showTooltip = true,
				icons = true,
				dotsize = 16,
				dotloss = {1, 0, 0, .2},
				dotwin = {0, 1, 0, .2},

				LossColorR = 1.0,
				LossColorG = 0.0,
				LossColorB = 0.0,
				LossColorA = 0.5,

				WinColorR = 0.0,
				WinColorG = 1.0,
				WinColorB = 0.0,
				WinColorA = 0.5,
			},
		}
	);

	VanasKoSGUI:AddModuleToggle("EventMap", L["PvP Event Map"]);
	VanasKoSGUI:AddConfigOption("EventMap", {
		type = 'group',
		name = L["PvP Event Map"],
		desc = L["PvP Event Map"],
		args = {
			drawAlts = {
				type = 'toggle',
				name = L["Draw Alts"],
				desc = L["Draws PvP events on map for all characters"],
				order = 1,
				set = function(frame, v) VanasKoSEventMap.db.profile.drawAlts = v; VanasKoSEventMap:RedrawMap(); end,
				get = function() return VanasKoSEventMap.db.profile.drawAlts; end,
			},
			icons = {
				type = 'select',
				name = L["Drawing mode"],
				desc = L["Toggle showing individual icons or simple dots"],
				order = 2,
				values = {L["Icons"], L["Colored dots"]},
				set = function(frame, v)
						VanasKoSEventMap.db.profile.icons = (v == 1);
						POIGRIDALIGN = ICONSIZE;
						VanasKoSEventMap:RedrawMap();
						useIcons = (v == 1);
					end,
				get = function() return (VanasKoSEventMap.db.profile.icons and 1) or 2; end
			},
			showTooltip = {
				type = 'toggle',
				name = L["Tooltips"],
				desc = L["Show tooltips when hovering over PvP events"],
				order = 3,
				set = function(frame, v) VanasKoSEventMap.db.profile.showTooltip = v; end,
				get = function() return VanasKoSEventMap.db.profile.showTooltip; end,
			},
			iconoptions = {
				type = 'header',
				name = L["Icon Options"],
				desc = L["Icon Options"],
				order = 10,
			},
			dynamicZoom = {
				type = 'toggle',
				name = L["Dynamic Zoom"],
				desc = L["Redraws icons based on Cartographer3 zoom level"],
				order = 11,
				set = function(frame, v) VanasKoSEventMap.db.profile.dynamicZoom = v; end,
				get = function() return VanasKoSEventMap.db.profile.dynamicZoom; end,
			},
			dotoptions = {
				type = 'header',
				name = L["Dot Options"],
				desc = L["Dot Options"],
				order = 20,
			},
			dotsize = {
				type = 'range',
				name = L["Size"],
				desc = L["Size of dots"],
				order = 21,
				set = function(frame, v)
					VanasKoSEventMap.db.profile.dotsize = v;
					DOTSIZE = v;
					VanasKoSEventMap:RedrawMap(); end,
				get = function() return VanasKoSEventMap.db.profile.dotsize; end,
				min = 4,
				max = 18,
				step = 1,
			},
			lossBackgroundColor = {
				type = 'color',
				name = LOSS,
				desc = L["Sets the loss color and opacity"],
				order = 22,
				set = function(frame, r, g, b, a) SetColor("LossColor", r, g, b, a); end,
				get = function() return GetColor("LossColor"); end,
				hasAlpha = true
			},
			winBackgroundColor = {
				type = 'color',
				name = WIN,
				desc = L["Sets the win color and opacity"],
				order = 23,
				set = function(frame, r, g, b, a) SetColor("WinColor", r, g, b, a); end,
				get = function() return GetColor("WinColor"); end,
				hasAlpha = true
			},
			dotreset = {
				type = 'execute',
				name = L["Reset"],
				desc = L["Reset dots to default"],
				order = 24,
				func = function()
						SetColor("LossColor", 1.0, 0.0, 0.0, 0.5);
						SetColor("WinColor", 0.0, 1.0, 0.0, 0.5);
						VanasKoSEventMap.db.profile.dotsize = 16;
						DOTSIZE = 16;
					end,
			},
		}
	});
	self.POICnt = 0;
	self.POIUsed = 0;
	self.POIList = {};
	self.POIGrid = {};

	VanasIconFrame = CreateFrame("Frame", "VanasKoSMapDetails", WorldMapButton);
	VanasIconFrame:SetAllPoints(true);
	VanasIconFrame:SetFrameLevel(WorldMapButton:GetFrameLevel() + 1);

	self:SetEnabledState(self.db.profile.Enabled);

	useIcons = self.db.profile.icons;
	DOTSIZE = self.db.profile.dotsize;
	POIGRIDALIGN = ICONSIZE;
end

function VanasKoSEventMap:ReadjustCamera(...)
	--Call original function
	self.hooks[Cartographer3.Utils]["ReadjustCamera"](Cartographer3.Utils, ...);

	-- Cartographer Zoom must not work the way I think it does. Using the
	-- zoom causes the icons to remain tiny no matter how close we zoom in.
	-- So using the WorldMapFrame Scale is a decent workaround for now.
	--[[
	local zoom = 20;
	if (Cartographer3_Data and Cartographer3_Data.cameraZoom > 20) then
		zoom = Cartographer3_Data.cameraZoom;
	end
	self.ICONSIZE = 20 * 16 / zoom;
	]]

	local zoom = WorldMapDetailFrame:GetScale();
	if (zoom < 1) then
		zoom = 1;
	end
	ICONSIZE = 16 / zoom;
	DOTSIZE = self.db.profile.dotsize / zoom;

	if (self.lastzoom == zoom) then
		return;
	end
	self.lastzoom = zoom;

	if (self.db.profile.dynamicZoom == true and useIcons) then
		POIGRIDALIGN = ICONSIZE;

		-- redraw all the points based on new zoom
		self.lastzone = "";
		self:UpdatePOI();
	else
		-- Resize all points
		for i,POI in ipairs(self.POIList) do
			POI:Resize();
		end
	end
end

function VanasKoSEventMap:WORLD_MAP_UPDATE()
	self:UpdatePOI();
end

function VanasKoSEventMap:OnEnable()
	self:RegisterEvent("WORLD_MAP_UPDATE");
	self:RegisterMessage("VanasKoS_PvPDeath", "PvPDeath");
	if (Cartographer3) then
		Cartographer3_Data = Cartographer3.Data;
		self:RawHook(Cartographer3.Utils, "ReadjustCamera");
	end

	DOTSIZE = self.db.profile.dotsize;
	POIGRIDALIGN = ICONSIZE;
end

function VanasKoSEventMap:OnDisable()
	self:UnregisterEvent("WORLD_MAP_UPDATE");
	if (Cartographer3) then
		self:Unhook(Cartographer3.Utils, "ReadjustCamera");
	end
	self:ClearEventMap();
end

function VanasKoSEventMap:PvPDeath(message, name)
	self:RedrawMap();
end

-- /script for i=1,5000 do VanasKoSPvPDataGatherer:AddEntry("PVPLOG", "test" .. i, {enemyname="test" .. i, time=time(), myname="bob", mylevel=15, enemylevel=16, zone="Wetlands", type="loss", posX=math.random(), posY=math.random()}) end
