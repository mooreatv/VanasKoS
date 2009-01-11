--[[----------------------------------------------------------------------
      EventMap Module - Part of VanasKoS
Displays PvP Events on World Map
------------------------------------------------------------------------]]

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "enUS", true);
if L then
	L["Enabled"] = true;
	L["PvP Event Map"] = true;
	L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "deDE", false);
if L then
	L["Enabled"] = "Aktiviert";
	--L["PvP Event Map"] = true;
	--L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	--L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	--L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "frFR", false);
if L then
	L["Enabled"] = "actif";
	--L["PvP Event Map"] = true;
	--L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	--L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	--L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "koKR", false);
if L then
	L["Enabled"] = "사용";
	--L["PvP Event Map"] = true;
	--L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	--L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	--L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "esES", false);
if L then
	L["Enabled"] = "Activado";
	--L["PvP Event Map"] = true;
	--L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	--L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	--L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS_EventMap", "ruRU", false);
if L then
	L["Enabled"] = "Включено";
	--L["PvP Event Map"] = true;
	--L["%s - %s killed by %s"] = "|cffff0000%s: %s killed by %s|r";
	--L["%s - %s killed %s"] = "|cff00ff00%s: %s killed %s|r";
	--L["PvP Encounter"] = true;
end

local L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS_EventMap", true);

VanasKoSEventMap = VanasKoS:NewModule("EventMap", "AceEvent-3.0", "AceHook-3.0");

local VanasKoSEventMap = VanasKoSEventMap;
local Cartographer3_Data = nil;

local function POI_Resize(self)
	local zoom = 20;
	if (Cartographer3_Data and Cartographer3_Data.cameraZoom > 20) then
		zoom = Cartographer3_Data.cameraZoom;
	end
	local size = 20 * 16 / zoom;

	self:SetWidth(size)
	self:SetHeight(size)
end

local function POI_OnShow(self, id)
	self:Resize(self);
end

local function POI_OnEnter(self, id)
	local x = WorldMapButton:GetCenter();
	local anchor = "ANCHOR_RIGHT";
	if (x < self.x) then
		anchor = "ANCHOR_LEFT";
	end
	WorldMapTooltip:ClearLines();
	WorldMapTooltip:SetOwner(self, anchor);
	WorldMapTooltip:AddLine(format(L["PvP Encounter"]));
	for i,v in ipairs(self.event) do
		local player = "";
		if (v.myname) then
			player = player .. v.myname;
		end
		if (v.mylevel) then
			player = player .. " (" .. v.mylevel .. ")";
		end

		local playerdata = VanasKoS:GetPlayerData(v.enemy);
		local enemy = (playerdata and playerdata.displayname) or string.Capitalize(v.enemy);
		local enemyNote = "";

		if (v.enemylevel) then
			enemyNote = v.enemylevel .. " " .. enemyNote;
		end

		if (playerdata) then
			enemy = playerdata.displayname or string.Capitalize(v.enemy);
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

		if (v.type == "loss") then
			WorldMapTooltip:AddLine(format(L["%s - %s killed by %s"], date("%c", v.time), player, enemy));
		elseif (v.type == "win") then
			WorldMapTooltip:AddLine(format(L["%s - %s killed %s"], date("%c", v.time), player, enemy));
		end
	end
	
	WorldMapTooltip:Show();
end


local function POI_OnLeave(self, id)
	WorldMapTooltip:Hide();
end

local function POI_OnClick(self, id)
end

local function VanasKoSEventMap_CreatePOI(x, y)
	local POI = CreateFrame("Button", "VanasKoSEventMapPOI"..VanasKoSEventMap.POICnt, WorldMapButton);
	local id = VanasKoSEventMap.POICnt + 1;
	POI:SetWidth(16);
	POI:SetHeight(16);
	POI:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	POI:SetToplevel(true);

	POI.Resize = POI_Resize;
	POI:SetScript("OnEnter", POI_OnEnter);
	POI:SetScript("OnLeave", POI_OnLeave);
	POI:SetScript("OnClick", POI_OnClick);
	POI:SetScript("OnShow", POI_OnShow)
	POI.x = x;
	POI.y = y;
	POI.score = 0;
	POI.event = {};
	POI:Hide();

	local tex = POI:CreateTexture("VanasKoSEventMapPOI" .. id .. "Texture");
	tex:SetAllPoints();
	tex:SetPoint("CENTER", 0, 0);

	VanasKoSEventMap.POIList[id] = POI;

	if (not VanasKoSEventMap.POIGrid[floor(x) % 16]) then
		VanasKoSEventMap.POIGrid[floor(x) % 16] = {[floor(y) % 16] = POI};
	else
		VanasKoSEventMap.POIGrid[floor(x) % 16][floor(y) % 16] = POI;
	end
	VanasKoSEventMap.POICnt = VanasKoSEventMap.POICnt + 1;

	return VanasKoSEventMap.POIList[id];
end

local function VanasKoSEventMap_GetPOI(x, y)
	for i,POI in ipairs(VanasKoSEventMap.POIList) do
		if (POI.x - x < 8 and POI.x - x > -8 and POI.y - y < 8 and POI.y - y > -8) then
			return POI;
		end
	end
	if (VanasKoSEventMap.POIGrid[floor(x) % 16] and
	    VanasKoSEventMap.POIGrid[floor(x) % 16][floor(y) % 16]) then
		return VanasKoSEventMap.POIGrid[floor(x) % 16][floor(y) % 16];
	end

	VanasKoSEventMap.POIUsed = VanasKoSEventMap.POIUsed + 1;
	if (VanasKoSEventMap.POIUsed <= VanasKoSEventMap.POICnt) then
		local POI = VanasKoSEventMap.POIList[VanasKoSEventMap.POIUsed];
		POI.x = x;
		POI.y = y;
		if (not VanasKoSEventMap.POIGrid[floor(x) % 16]) then
			VanasKoSEventMap.POIGrid[floor(x) % 16] = {[floor(y) % 16] = POI};
		else
			VanasKoSEventMap.POIGrid[floor(x) % 16][floor(y) % 16] = POI;
		end
		return POI;
	end

	return VanasKoSEventMap_CreatePOI(x, y);
end

local function ClearEventMap()
	for i,POI in ipairs(VanasKoSEventMap.POIList) do
		POI:Hide();
		POI.show = nil;
		POI.score = 0;
		wipe(POI.event);
		POI.event = {};
	end
	for i,grid in ipairs(VanasKoSEventMap.POIGrid) do
		wipe(grid);
	end
	VanasKoSEventMap.POIUsed = 0;
end

local lastzone = "";
local lastcontinent = "";
local function UpdatePOI()
	local continent = GetCurrentMapContinent();
	local zone = GetCurrentMapZone();
	local pvplog = VanasKoS:GetList("PVPLOG");

	-- Cartographer 3 causes the map to update much too often, slowing the
	-- UI almost to a halt. So only draw if we are in the same zone
	if (lastzone == zone and lastcontinent == continent) then
		return
	end
	lastzone = zone;
	lastcontinent = continent;


	ClearEventMap();

	for enemy, etable in pairs(pvplog) do
		for time, event in pairs(etable) do
			if (event.continent == continent and event.zoneid == zone) then
				local x = event.posX * WorldMapDetailFrame:GetWidth();
				local y = -event.posY * WorldMapDetailFrame:GetHeight();
				local POI = VanasKoSEventMap_GetPOI(x, y);
				if (event.type == "loss") then
					POI.score = POI.score - 1;
				elseif (event.type == "win") then
					POI.score = POI.score + 1;
				end
				POI.show = true;

				table.insert(POI.event, {time = time,
							enemy = enemy,
							myname = event.myname,
							type = event.type,
							mylevel = event.mylevel,
							});
			end
		end
	end

	for i,POI in ipairs(VanasKoSEventMap.POIList) do
		if (POI.show) then
			POI:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", POI.x, POI.y);
			POI:SetFrameLevel(WorldMapPlayer:GetFrameLevel() - 1);
			if (POI.score < 0) then
				POI:SetNormalTexture("Interface\\AddOns\\VanasKoS\\Artwork\\loss");
			elseif (POI.score > 0) then
				POI:SetNormalTexture("Interface\\AddOns\\VanasKoS\\Artwork\\win");
			else
				POI:SetNormalTexture("Interface\\AddOns\\VanasKoS\\Artwork\\tie");
			end
			POI:Enable();
			POI:Show();
		end
	end
end

function VanasKoSEventMap:OnInitialize()
	self.db = VanasKoS.db:RegisterNamespace("EventMap", 
		{
			profile = {
				Enabled = true,
			},
		}
	);

	VanasKoSGUI:AddConfigOption("EventMap", {
		type = 'group',
		name = L["PvP Event Map"],
		desc = L["PvP Event Map"],
		args = {
			enabled = {
				type = 'toggle',
				name = L["Enabled"],
				desc = L["Enabled"],
				order = 1,
				set = function(frame, v) VanasKoSEventMap.db.profile.Enabled = v; VanasKoS:ToggleModuleActive("EventMap"); end,
				get = function() return VanasKoSEventMap.db.profile.Enabled end,
			},
		}
	});
	self.POICnt = 0;
	self.POIUsed = 0;
	self.POIList = {};
	self.POIGrid = {};
	
	self:SetEnabledState(self.db.profile.Enabled);
end

function VanasKoSEventMap:ReadjustCamera()
	for i,POI in ipairs(VanasKoSEventMap.POIList) do
		POI:Resize()
	end
end

function VanasKoSEventMap:OnEnable()
	self:RegisterEvent("WORLD_MAP_UPDATE", UpdatePOI);
	if (Cartographer3) then
		Cartographer3_Data = Cartographer3.Data;
		self:SecureHook(Cartographer3.Utils, "ReadjustCamera");
	end
end

function VanasKoSEventMap:OnDisable()
	self:UnregisterEvent("WORLD_MAP_UPDATE");
	ClearEventMap();
end
