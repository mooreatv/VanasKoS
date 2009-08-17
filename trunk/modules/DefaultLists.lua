VanasKoSDefaultLists = VanasKoS:NewModule("DefaultLists", "AceEvent-3.0");

local VanasKoSDefaultLists = VanasKoSDefaultLists;
local VanasKoS = VanasKoS;
local VanasKoSGUI = VanasKoSGUI;

local tooltip = nil;

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "enUS", true)
if L then
	L["Name"] = true
	L["Guild"] = true
	L["Lvl"] = true
	L["Class"] = true
	L["Reason"] = true
	L["Last Seen"] = true
	L["Zone"] = true
	L["never seen"] = true
	L["0 Secs"] = true
	L["by create date"] = true
	L["by class"] = true
	L["by creator"] = true
	L["by last seen"] = true
	L["by level"] = true
	L["by name"] = true
	L["by guild"] = true
	L["by owner"] = true
	L["by reason"] = true
	L["Created: |cffffffff%s|r"] = true
	L["Creator: |cffffffff%s|r"] = true
	L["Entry %s is already on Hatelist"] = true
	L["Entry %s is already on Nicelist"] = true
	L["Guild KoS"] = true
	L["Hatelist"] = true
	L["Last seen at |cff00ff00%s|r in |cff00ff00%s|r"] = true
	L["Last updated: |cffffffff%s|r"] = true
	L["Level %s %s %s"] = true
	L["Move to Hatelist"] = true
	L["Move to Nicelist"] = true
	L["Move to Player KoS"] = true
	L["Nicelist"] = true
	L["Owner: |cffffffff%s|r"] = true
	L["Player KoS"] = true
	L["PvP Encounter:"] = true
	L["_Reason Unknown_"] = "unknown"
	L["Received from: |cffffffff%s|r"] = true
	L["Remove Entry"] = true
	L["%s: |cff00ff00Win|r |cffffffffin %s (|r|cffff00ff%s|r|cffffffff)|r"] = true
	L["%s: |cffff0000Loss|r |cffffffffin %s(|r|cffff00ff%s|r|cffffffff)|r"] = true
	L["%s  |cffff00ff%s|r"] = true
	L["%s  |cffffffffLevel %s %s %s|r |cffff00ff%s|r"] = true
	L["Show only my entries"] = true
	L["Only my entries"] = true
	L["%s (last seen: %s ago)"] = true
	L["%s (never seen)"] = true
	L["sort by class"] = true
	L["sort by creator"] = true
	L["sort by date created"] = true
	L["sort by last seen"] = true
	L["sort by level"] = true
	L["sort by name"] = true
	L["sort by guild"] = true
	L["sort by owner"] = true
	L["sort by reason"] = true
	L["%s (%s) - Reason: %s"] = true
	L["[%s] %s (%s) - Reason: %s"] = true
	L["Wanted"] = true
	L["Player Info"] = true
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "frFR")
if L then
-- auto generated from wowace translation app
--@localization(locale="frFR", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "deDE")
if L then
-- auto generated from wowace translation app
--@localization(locale="deDE", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "koKR")
if L then
-- auto generated from wowace translation app
--@localization(locale="koKR", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "esMX")
if L then
-- auto generated from wowace translation app
--@localization(locale="esMX", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "ruRU")
if L then
-- auto generated from wowace translation app
--@localization(locale="ruRU", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "zhCN")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhCN", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "esES")
if L then
-- auto generated from wowace translation app
--@localization(locale="esES", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/DefaultLists", "zhTW")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhTW", format="lua_additive_table", namespace="VanasKoS/DefaultLists")@
end

L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS/DefaultLists", false);

-- sort functions

-- sorts by index
local function SortByIndex(val1, val2)
	return val1 < val2;
end
local function SortByIndexReverse(val1, val2)
	return val1 > val2
end

-- sorts from a-z
local function SortByReason(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].reason or L["_Reason Unknown_"];
	local str2 = list[val2].reason or L["_Reason Unknown_"];
	return (str1:lower() < str2:lower());
end
local function SortByReasonReverse(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].reason or L["_Reason Unknown_"];
	local str2 = list[val2].reason or L["_Reason Unknown_"];
	return (str1:lower() > str2:lower());
end

local function SortByCreateDate(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local cmp1 = list[val1].created or 2^30;
	local cmp2 = list[val2].created or 2^30;
	return (cmp1 > cmp2);
end
local function SortByCreateDateReverse(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local cmp1 = list[val1].created or 2^30;
	local cmp2 = list[val2].created or 2^30;
	return (cmp1 < cmp2);
end

-- sorts from a-z
local function SortByCreator(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].creator or "";
	local str2 = list[val2].creator or "";
	return (str1:lower() < str2:lower());
end
local function SortByCreatorReverse(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].creator or "";
	local str2 = list[val2].creator or "";
	return (str1:lower() > str2:lower());
end

-- sorts from a-z
local function SortByOwner(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].owner or "";
	local str2 = list[val2].owner or "";
	return (str1:lower() < str2:lower());
end
local function SortByOwner(val1, val2)
	local list = VanasKoSGUI:GetCurrentList();
	local str1 = list[val1].owner or "";
	local str2 = list[val2].owner or "";
	return (str1:lower() > str2:lower());
end

-- sorts from lowest to highest level
local function SortByLevel(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local lvl1 = list[val1] and (string.gsub(list[val1].level, "+", ".5"));
		local lvl2 = list[val2] and (string.gsub(list[val2].level, "+", ".5"));
		return ((tonumber(lvl1) or 0) < (tonumber(lvl2) or 0));
	end
	return false;
end
local function SortByLevelReverse(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local lvl1 = list[val1] and (string.gsub(list[val1].level, "+", ".5"));
		local lvl2 = list[val2] and (string.gsub(list[val2].level, "+", ".5"));
		return ((tonumber(lvl1) or 0) > (tonumber(lvl2) or 0));
	end
	return false;
end

-- sorts from early to later
local function SortByLastSeen(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local now = time();
		local cmp1 = list[val1] and list[val1].lastseen and (now - list[val1].lastseen) or 2^30;
		local cmp2 = list[val2] and list[val2].lastseen and (now - list[val2].lastseen) or 2^30;
		return (cmp1 < cmp2);
	end
	return false;
end
local function SortByLastSeenReverse(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local now = time();
		local cmp1 = list[val1] and list[val1].lastseen and (now - list[val1].lastseen) or 2^30;
		local cmp2 = list[val2] and list[val2].lastseen and (now - list[val2].lastseen) or 2^30;
		return (cmp1 > cmp2);
	end
	return false;
end

-- sorts from a-z
local function SortByClass(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].class or "";
		local str2 = list[val2] and list[val2].class or "";
		return (str1:lower() < str2:lower());
	end
	return false;
end
local function SortByClassReverse(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].class or "";
		local str2 = list[val2] and list[val2].class or "";
		return (str1:lower() > str2:lower());
	end
	return false;
end

-- sorts from a-z
local function SortByGuild(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].guild or "";
		local str2 = list[val2] and list[val2].guild or "";
		return (str1:lower() < str2:lower());
	end
	return false;
end
local function SortByGuildReverse(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].guild or "";
		local str2 = list[val2] and list[val2].guild or "";
		return (str1:lower() > str2:lower());
	end
	return false;
end

-- sorts from a-z
local function SortByZone(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].zone or "";
		local str2 = list[val2] and list[val2].zone or "";
		return (str1:lower() < str2:lower());
	end
	return false;
end
local function SortByZoneReverse(val1, val2)
	local list = VanasKoS:GetList("PLAYERDATA");
	if(list) then
		local str1 = list[val1] and list[val1].zone or "";
		local str2 = list[val2] and list[val2].zone or "";
		return (str1:lower() > str2:lower());
	end
	return false;
end


function VanasKoSDefaultLists:OnInitialize()
	self.db = VanasKoS.db:RegisterNamespace("DefaultLists", 
					{
						realm = {
							koslist = {
								players = {
								},
								guilds = {
								}
							},
							hatelist = {
								players = {
								},
							},
							nicelist = {
								players = {
								},
							},
						},
						profile = {
							ShowOnlyMyEntries = false
						}
					});

	-- import of old data, will be removed in some version in the future
--[[	if(VanasKoS.db.realm.koslist) then
		self.db.realm.koslist = VanasKoS.db.realm.koslist;
		VanasKoS.db.realm.koslist = nil;
	end
	if(VanasKoS.db.realm.hatelist) then
		self.db.realm.hatelist = VanasKoS.db.realm.hatelist;
		VanasKoS.db.realm.hatelist = nil;
	end
	if(VanasKoS.db.realm.nicelist) then
		self.db.realm.nicelist = VanasKoS.db.realm.nicelist;
		VanasKoS.db.realm.nicelist = nil;
	end ]]
--[[
	if(VanasKoSDB.namespaces.DefaultLists.realms) then
		for k,v in pairs(VanasKoSDB.namespaces.DefaultLists.realms) do
			if(string.find(k, GetRealmName()) ~= nil) then
				if(v.koslist) then
					self.db.realm.koslist = v.koslist;
					v.koslist = nil;
				end
				if(v.hatelist) then
					self.db.realm.hatelist = v.hatelist;
					v.hatelist = nil;
				end
				if(v.nicelist) then
					self.db.realm.nicelist = v.nicelist;
					v.nicelist = nil;
				end
			end
		end
	end]]
	
	-- register lists this modules provides at the core
	VanasKoS:RegisterList(1, "PLAYERKOS", L["Player KoS"], self);
	VanasKoS:RegisterList(2, "GUILDKOS", L["Guild KoS"], self);
	VanasKoS:RegisterList(3, "HATELIST", L["Hatelist"], self);
	VanasKoS:RegisterList(4, "NICELIST", L["Nicelist"], self);

	-- register lists this modules provides in the GUI
	VanasKoSGUI:RegisterList("PLAYERKOS", self);
	VanasKoSGUI:RegisterList("GUILDKOS", self);
	VanasKoSGUI:RegisterList("HATELIST", self);
	VanasKoSGUI:RegisterList("NICELIST", self);

	-- register sort options for the lists this module provides
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, "byname", L["by name"], L["sort by name"], SortByIndex, SortByIndexReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, "bycreatedate", L["by create date"], L["sort by date created"], SortByCreateDate, SortByCreateDateReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, "bycreator", L["by creator"], L["sort by creator"], SortByCreator, SortByCreatorReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, "byreason", L["by reason"], L["sort by reason"], SortByReason, SortByReasonReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, "byowner", L["by owner"], L["sort by owner"], SortByOwner, SortByOwnerReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "HATELIST", "NICELIST"}, "byguild", L["by guild"], L["sort by guild"], SortByGuild, SortByGuildReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "HATELIST", "NICELIST"}, "bylevel", L["by level"], L["sort by level"], SortByLevel, SortByLevelReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "HATELIST", "NICELIST"}, "byclass", L["by class"], L["sort by class"], SortByClass, SortByClassReverse)
	VanasKoSGUI:RegisterSortOption({"PLAYERKOS", "HATELIST", "NICELIST"}, "bylastseen", L["by last seen"], L["sort by last seen"], SortByLastSeen, SortByLastSeenReverse)

	VanasKoSGUI:SetDefaultSortFunction({"PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST"}, SortByIndex);

	-- first sort function is sorting by name
	VanasKoSGUI:SetSortFunction(SortByIndex);

	-- show the PLAYERKOS list after startup
	VanasKoSGUI:ShowList("PLAYERKOS");

	VanasKoSListFrameCheckBox:SetText(L["Only my entries"]);
	VanasKoSListFrameCheckBox:SetChecked(VanasKoSDefaultLists.db.profile.ShowOnlyMyEntries);
	VanasKoSListFrameCheckBox:SetScript("OnClick", function(frame)
			VanasKoSDefaultLists.db.profile.ShowOnlyMyEntries = not VanasKoSDefaultLists.db.profile.ShowOnlyMyEntries;
			VanasKoSGUI:UpdateShownList();
		end);

	self.tooltipFrame = CreateFrame("GameTooltip", "VanasKoSDefaultListsTooltip", UIParent, "GameTooltipTemplate");
	tooltip = self.tooltipFrame;
	
	tooltip:Hide();
end

function VanasKoSDefaultLists:OnEnable()
end

function VanasKoSDefaultLists:OnDisable()
end


-- FilterFunction as called by VanasKoSGUI - key is the index from the table entry that gets displayed, value the data associated with the index. searchBoxText the text entered in the searchBox
-- returns true if the entry should be shown, false otherwise
function VanasKoSDefaultLists:FilterFunction(key, value, searchBoxText)
	if(VanasKoSDefaultLists.db.profile.ShowOnlyMyEntries and value.owner ~= nil) then
		return false;
	end
	if(searchBoxText == "") then
		return true;
	end

	if(key:find(searchBoxText) ~= nil) then
		return true;
	end

	if(value.reason and (value.reason:lower():find(searchBoxText) ~= nil)) then
		return true;
	end

	if(value.owner and (value.owner:lower():find(searchBoxText) ~= nil)) then
		return true;
	end

	return false;
end


function VanasKoSDefaultLists:RenderButton(list, buttonIndex, button, key, value, buttonText1, buttonText2, buttonText3, buttonText4, buttonText5, buttonText6)
	if(list == "PLAYERKOS" or list == "HATELIST" or list == "NICELIST") then
		local data = VanasKoS:GetPlayerData(key);
		-- name, guildrank, guild, level, race, class, gender, zone, lastseen
		local owner = "";
		if(value.owner ~= nil and value.owner ~= "") then
			owner = string.Capitalize(value.owner);
		end
		local displayname = string.Capitalize(key);
		if(value.wanted == true) then
			displayname = "|cffff0000" .. displayname .. "|r";
		end
		buttonText1:SetText(displayname);
		if(not self.group or self.group == 1) then
			buttonText2:SetText(data and data.guild or "");
			buttonText3:SetText(data and data.level or "");
			buttonText4:SetText(data and data.class or "");
			if (data and data.classEnglish) then
				local classColor = RAID_CLASS_COLORS[data.classEnglish] or NORMAL_FONT_COLOR;
				buttonText4:SetTextColor(classColor.r, classColor.g, classColor.b);
			end
		elseif(self.group == 2) then
			buttonText2:SetText(value and value.reason or L["_Reason Unknown_"]);
		else
			if(data and data.lastseen) then
				local timespan = SecondsToTime(time() - data.lastseen);
				if(timespan == "") then
					timespan = L["0 Secs"];
				end
				buttonText2:SetText(timespan);
			else
				buttonText2:SetText(format(L["never seen"], timespan));
			end
			if (data and data.zone) then
				buttonText3:SetText(data.zone);
			else
				buttonText3:SetText("");
			end
		end
	elseif(list == "GUILDKOS") then
		local guildname = VanasKoS:GetGuildData(key);
		buttonText1:SetText(guildname or string.Capitalize(key));
		buttonText2:SetText(value and value.reason or L["_Reason Unknown_"]);
		buttonText3:SetText("");
		buttonText4:SetText(value.owner and string.Capitalize(value.owner) or "");
	end

	button:Show();
end

function VanasKoSDefaultLists:SetupColumns(list)
	if(list == "PLAYERKOS" or list == "HATELIST" or list == "NICELIST") then
		if(not self.group or self.group == 1) then
			VanasKoSGUI:SetNumColumns(4);
			VanasKoSGUI:SetColumnWidth(1, 83);
			VanasKoSGUI:SetColumnWidth(2, 100);
			VanasKoSGUI:SetColumnWidth(3, 32);
			VanasKoSGUI:SetColumnWidth(4, 92);
			VanasKoSGUI:SetColumnName(1, L["Name"]);
			VanasKoSGUI:SetColumnName(2, L["Guild"]);
			VanasKoSGUI:SetColumnName(3, L["Lvl"]);
			VanasKoSGUI:SetColumnName(4, L["Class"]);
			VanasKoSGUI:SetColumnSort(1, SortByIndex, SortByIndexReverse);
			VanasKoSGUI:SetColumnSort(2, SortByGuild, SortByGuildReverse);
			VanasKoSGUI:SetColumnSort(3, SortByLevel, SortByLevelReverse);
			VanasKoSGUI:SetColumnSort(4, SortByClass, SortByClassReverse);
			VanasKoSGUI:SetColumnType(1, "normal");
			VanasKoSGUI:SetColumnType(2, "highlight");
			VanasKoSGUI:SetColumnType(3, "number");
			VanasKoSGUI:SetColumnType(4, "highlight");
			VanasKoSGUI:SetToggleButtonText(L["Player Info"]);
		elseif(self.group == 2) then
			VanasKoSGUI:SetNumColumns(2);
			VanasKoSGUI:SetColumnWidth(1, 83);
			VanasKoSGUI:SetColumnWidth(2, 220);
			VanasKoSGUI:SetColumnName(1, L["Name"]);
			VanasKoSGUI:SetColumnName(2, L["Reason"]);
			VanasKoSGUI:SetColumnSort(1, SortByIndex, SortByIndexReverse);
			VanasKoSGUI:SetColumnSort(2, SortByReason, SortByReasonReverse);
			VanasKoSGUI:SetColumnType(1, "normal");
			VanasKoSGUI:SetColumnType(2, "highlight");
			VanasKoSGUI:SetToggleButtonText(L["Reason"]);
		else
			VanasKoSGUI:SetNumColumns(3);
			VanasKoSGUI:SetColumnWidth(1, 83);
			VanasKoSGUI:SetColumnWidth(2, 110);
			VanasKoSGUI:SetColumnWidth(3, 110);
			VanasKoSGUI:SetColumnName(1, L["Name"]);
			VanasKoSGUI:SetColumnName(2, L["Last Seen"]);
			VanasKoSGUI:SetColumnName(3, L["Zone"]);
			VanasKoSGUI:SetColumnSort(1, SortByIndex, SortByIndexReverse);
			VanasKoSGUI:SetColumnSort(2, SortByLastSeen, SortByLastSeenReverse);
			VanasKoSGUI:SetColumnSort(3, SortByZone, SortByZoneReverse);
			VanasKoSGUI:SetColumnType(1, "normal");
			VanasKoSGUI:SetColumnType(2, "highlight");
			VanasKoSGUI:SetColumnType(3, "highlight");
			VanasKoSGUI:SetToggleButtonText(L["Last Seen"]);
		end
		VanasKoSGUI:ShowToggleButton();
	elseif(list == "GUILDKOS") then
		VanasKoSGUI:SetNumColumns(2);
		VanasKoSGUI:SetColumnWidth(1, 105);
		VanasKoSGUI:SetColumnWidth(2, 208);
		VanasKoSGUI:SetColumnName(1, L["Guild"]);
		VanasKoSGUI:SetColumnName(2, L["Reason"]);
		VanasKoSGUI:SetColumnSort(1, SortByIndex, SortByIndexReverse);
		VanasKoSGUI:SetColumnSort(2, SortByReason, SortByReasonReverse);
		VanasKoSGUI:SetColumnType(1, "normal");
		VanasKoSGUI:SetColumnType(2, "highlight");
		VanasKoSGUI:HideToggleButton();
	end
end

function VanasKoSDefaultLists:ToggleButtonOnClick(button, frame)
	local list = VANASKOS.showList;
	if(list == "PLAYERKOS" or list == "HATELIST" or list == "NICELIST") then
		if (not self.group or self.group < 3) then
			self.group = (self.group or 1) + 1;
		else
			self.group = 1
		end
	elseif(list == "GUILDKOS") then
		self.group = 1;
	end
	self:SetupColumns(list);
	VanasKoSGUI:ScrollFrameUpdate()
end

function VanasKoSDefaultLists:IsOnList(list, name)
	local listVar = VanasKoS:GetList(list);
	if(listVar and listVar[name]) then
		return listVar[name];
	else
		return nil;
	end
end

-- don't call this directly, call it via VanasKoS:AddEntry - it expects name to be lower case!
function VanasKoSDefaultLists:AddEntry(list, name, data)
	if(list == "PLAYERKOS") then
		self.db.realm.koslist.players[name] = { ["reason"] = data['reason'], ["created"] = time(), ['creator'] = UnitName("player") };
	elseif(list == "GUILDKOS") then
		self.db.realm.koslist.guilds[name] = { ["reason"] = data['reason'], ["created"] = time(), ['creator'] = UnitName("player") };
	elseif(list == "HATELIST") then
		if(VanasKoS:IsOnList("NICELIST", name)) then
			self:Print(format(L["Entry %s is already on Nicelist"], name));
			return;
		end
		self.db.realm.hatelist.players[name] = { ["reason"] = data['reason'], ["created"] = time(), ['creator'] = UnitName("player")  };
	elseif(list == "NICELIST") then
		if(VanasKoS:IsOnList("HATELIST", name)) then
			self:Print(format(L["Entry %s is already on Hatelist"], name));
			return;
		end
		self.db.realm.nicelist.players[name] = { ["reason"] = data['reason'], ["created"] = time(), ['creator'] = UnitName("player")  };
	end

	self:SendMessage("VanasKoS_List_Entry_Added", list, name, data);
end

function VanasKoSDefaultLists:RemoveEntry(listname, name)
	local list = VanasKoS:GetList(listname);
	if(list and list[name]) then
		list[name] = nil;
		self:SendMessage("VanasKoS_List_Entry_Removed", listname, name);
	end
end

function VanasKoSDefaultLists:GetList(list)
	if(list == "PLAYERKOS") then
		return self.db.realm.koslist.players;
	elseif(list == "GUILDKOS") then
		return self.db.realm.koslist.guilds;
	elseif(list == "HATELIST") then
		return self.db.realm.hatelist.players;
	elseif(list == "NICELIST") then
		return self.db.realm.nicelist.players;
	else
		return nil;
	end
end

local entry, value;

local function ListButtonOnRightClickMenu()
	local x, y = GetCursorPosition();
	local uiScale = UIParent:GetEffectiveScale();
	local menuItems = {
		{
			text = string.Capitalize(entry),
			isTitle = true,
		},
		{
			text = L["Move to Player KoS"],
			func = function()
						VanasKoS:RemoveEntry(VANASKOS.showList, entry);
						VanasKoS:AddEntry("PLAYERKOS", entry, value);
					end,
		},
		{
			text = L["Move to Hatelist"],
			func = function()
						VanasKoS:RemoveEntry(VANASKOS.showList, entry);
						VanasKoS:AddEntry("HATELIST", entry, value);
					end
		},
		{
			text = L["Move to Nicelist"],
			func = function()
						VanasKoS:RemoveEntry(VANASKOS.showList, entry);
						VanasKoS:AddEntry("NICELIST", entry, value);
					end
		},
		{
			text = L["Remove Entry"],
			func = function()
				VanasKoS:RemoveEntry(VANASKOS.showList, entry);
			end
		}
	};

	if(VANASKOS.showList == "PLAYERKOS"and VanasKoS:ModuleEnabled("DistributedTracker")) then
		tinsert(menuItems, {
			text = L["Wanted"],
			func = function()
					local list = VanasKoS:GetList("PLAYERKOS");
					if (not list[entry].wanted) then
						list[entry].wanted = true;
					else
						list[entry].wanted = nil;
					end
					VanasKoSGUI:Update();
				end,
			checked = function() return value.wanted; end,
		});
	end

	EasyMenu(menuItems, VanasKoSGUI.dropDownFrame, UIParent, x/uiScale, y/uiScale, "MENU");
end

function VanasKoSDefaultLists:ListButtonOnClick(button, frame)
	local id = frame:GetID();
	entry, value = VanasKoSGUI:GetListEntryForID(id);
	if(id == nil or entry == nil) then
		return;
	end
	if(button == "LeftButton") then
		if(IsShiftKeyDown()) then
			local name;

			if(not value) then
				return;
			end

			name = string.Capitalize(entry);

			local str = nil;
			if(value.owner) then
				str = format(L["[%s] %s (%s) - Reason: %s"], value.owner, name, VanasKoSGUI:GetListName(VANASKOS.showList), value.reason);
			else
				str = format(L["%s (%s) - Reason: %s"], name, VanasKoSGUI:GetListName(VANASKOS.showList), value.reason);
			end
			if(DEFAULT_CHAT_FRAME.editBox and str) then
				if(DEFAULT_CHAT_FRAME.editBox:IsVisible()) then
					DEFAULT_CHAT_FRAME.editBox:SetText(DEFAULT_CHAT_FRAME.editBox:GetText() .. str .. " ");
				end
			end
		end
		return;
	end

	ListButtonOnRightClickMenu();
end

local selectedPlayer, selectedPlayerData = nil;

function VanasKoSDefaultLists:UpdateMouseOverFrame()
	if(not selectedPlayer) then
		tooltip:AddLine("----");
		return;
	end
	
	-- name
	local pdatalist = VanasKoS:GetList("PLAYERDATA")[selectedPlayer];
	tooltip:AddLine(string.Capitalize(selectedPlayer));
	
	-- guild, level, race, class, zone, lastseen
	if(pdatalist) then
		if(pdatalist['guild']) then
			local text = "<|cffffffff" .. pdatalist['guild'] .. "|r>";
			if(pdatalist['guildrank']) then
				text = text .. " (" .. pdatalist['guildrank'] .. ")";
			end
			tooltip:AddLine(text);
		end
		if(pdatalist['level'] and pdatalist['race'] and pdatalist['class']) then
			tooltip:AddLine(format(L['Level %s %s %s'], pdatalist['level'], pdatalist['race'], pdatalist['class']));
		end
		if(pdatalist['zone'] and pdatalist['lastseen']) then
			tooltip:AddLine(format(L['Last seen at |cff00ff00%s|r in |cff00ff00%s|r'], date("%x", pdatalist['lastseen']), pdatalist['zone']));
		end
	end

	-- infos about creator, sender, owner, last updated
	if(selectedPlayerData) then
		if(selectedPlayerData['owner']) then
			tooltip:AddLine(format(L['Owner: |cffffffff%s|r'], selectedPlayerData['owner']));
		end

		if(selectedPlayerData['creator']) then
			tooltip:AddLine(format(L['Creator: |cffffffff%s|r'], selectedPlayerData['creator']));
		end

		if(selectedPlayerData['created']) then
			tooltip:AddLine(format(L['Created: |cffffffff%s|r'], date("%x", selectedPlayerData['created'])));
		end

		if(selectedPlayerData['sender']) then
			tooltip:AddLine(format(L['Received from: |cffffffff%s|r'], selectedPlayerData['sender']));
		end

		if(selectedPlayerData['lastupdated']) then
			tooltip:AddLine(format(L['Last updated: |cffffffff%s|r'], date("%x", selectedPlayerData['lastupdated'])));
		end
	end

	local pvplog = VanasKoS:GetList("PVPLOG");
	if(pvplog) then
		local playerlog = pvplog.player[selectedPlayer];
		if(playerlog) then
			tooltip:AddLine("|cffffffff" .. L["PvP Encounter:"] .. "|r");
			local i = 0;
			for k,eventIdx in ipairs(playerlog) do
				local event = pvplog.event[eventIdx];
				if(event.type and event.zone and event.myname) then
					if(event.type == 'win') then
						tooltip:AddLine(format(L["%s: |cff00ff00Win|r |cffffffffin %s (|r|cffff00ff%s|r|cffffffff)|r"], date("%c", k), event.zone, event.myname));
					else
						tooltip:AddLine(format(L["%s: |cffff0000Loss|r |cffffffffin %s(|r|cffff00ff%s|r|cffffffff)|r"], date("%c", k), event.zone, event.myname));
					end
				end
				i = i + 1;
				if(i > 10) then
					return;
				end
			end
		end
	end
end

function VanasKoSDefaultLists:ShowTooltip()
	tooltip:ClearLines();
	tooltip:SetOwner(VanasKoSListFrame, "ANCHOR_CURSOR");
	tooltip:SetPoint("TOPLEFT", VanasKoSListFrame, "TOPRIGHT", -33, -30);
	tooltip:SetPoint("BOTTOMLEFT", VanasKoSListFrame, "TOPRIGHT", -33, -390);
	
	self:UpdateMouseOverFrame();
	tooltip:Show();
end

function VanasKoSDefaultLists:HideTooltip()
	tooltip:Hide();
end

function VanasKoSDefaultLists:ListButtonOnEnter(button, frame)
	self:SetSelectedPlayerData(VanasKoSGUI:GetListEntryForID(frame:GetID()));
	
	self:ShowTooltip();
end

function VanasKoSDefaultLists:ListButtonOnLeave(button, frame)
	self:HideTooltip();
end

function VanasKoSDefaultLists:SetSelectedPlayerData(selPlayer, selPlayerData)
	selectedPlayer = selPlayer;
	selectedPlayerData = selPlayerData;
end
