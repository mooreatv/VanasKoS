﻿--[[----------------------------------------------------------------------
	VanasKoS - Kill on Sight Management
Main Object with database and basic list functionality, handles also Configuration
------------------------------------------------------------------------]]

local DEFAULT_OPTIONS = {
	};


local initialized = nil;

VanasKoS = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0", "AceComm-2.0", "AceModuleCore-2.0", "AceHook-2.1");
VanasKoS:SetModuleMixins("AceComm-2.0", "AceEvent-2.0", "AceComm-2.0", "AceConsole-2.0", "AceHook-2.1");
local L = AceLibrary("AceLocale-2.2"):new("VanasKoS");
local VanasKoS = VanasKoS;

VanasKoS:RegisterDB("VanasKoSDB", "VanasKoSDBPC");
VanasKoS:RegisterDefaults("profile", DEFAULT_OPTIONS);
VanasKoS:RegisterDefaults("realm", { });

--[[----------------------------------------------------------------------
  ACE Functions
------------------------------------------------------------------------]]
function VanasKoS:OnInitialize()
	VANASKOS.VERSION = "" .. self.version;
end

function VanasKoS:OnEnable()
	self:RegisterEvent("VanasKoS_List_Entry_Added", "List_Entry_Added");
	self:RegisterEvent("VanasKoS_List_Entry_Removed", "List_Entry_Removed");
end

function VanasKoS:OnDisable()
	VanasKoS_WarnFrame:Hide();
end

function VanasKoS:GetOpt(var)
	if(self.db.profile[var] == nil) then
		self:Print("[DEBUG] access", var);
	end
	return self.db.profile[var]; 
end

function VanasKoS:SetOpt(var, val)
	self.db.profile[var] = val; 
end

function VanasKoS:TogOpt(var)
	local x = self:GetOpt(var);
	if(x == nil or x == false) then
		self:SetOpt(var, true);
		return true;
	else
		self:SetOpt(var, false);
		return false;
	end
end

function VanasKoS:TogMsg(text, val)
	local x = val;
	if(val == true) then
		x = L[true];
	elseif(val == false) then
		x = L[false];
	elseif(x == nil) then
		x = "nil";
	end
	self:Print(format(L["%s set to %s"], text, x));
end

--[[----------------------------------------------------------------------
  Main Functions
------------------------------------------------------------------------]]

local listHandler = { };
VANASKOS.Lists = { };

function VanasKoS:RegisterList(position, listNameInternal, listNameHuman, listHandlerObject)
	-- only add the list if the handlerobject supports all required functions
	if(not listHandlerObject) then
		self:Print("Error: No listHandlerObject for ", listNameInternal);
		return false;
	end
	
	if(not listHandlerObject.AddEntry) then
		self:Print("Error: No AddEntry function for ", listNameInternal);
		return false;
	end

	if(not listHandlerObject.RemoveEntry) then
		self:Print("Error: No RemoveEntry function for ", listNameInternal);
		return false;
	end

	if(not listHandlerObject.GetList) then
		self:Print("Error: No GetList function for ", listNameInternal);
		return false;
	end
	
	if(not listHandlerObject.IsOnList) then
		self:Print("Error: No IsOnList function for ", listNameInternal);
		return false;
	end
	
	-- only put it in the VANASKOS.Lists if the listname is human readable => not internal(VANASKOS.Lists is only used for vanaskosgui to choose a list to display)
	if(listNameHuman ~= nil) then
		tinsert(VANASKOS.Lists, position, { listNameInternal, listNameHuman });
		self:TriggerEvent("VanasKoS_List_Added");
	end
	
	-- fix until all list registrations are moved outside of this object (otherwise this object gets called recursive => deadlock)
	if(listHandlerObject == self) then
		return true;
	end
	listHandler[listNameInternal] = listHandlerObject;
	return true;
end

function VanasKoS:UnregisterList(listNameInternal)
	listHandler[listNameInternal] = nil;
	
	for k,v in pairs(VANASKOS.Lists) do
		if(v[1] and v[1] == listNameInternal) then
			tremove(VANASKOS.Lists, k);
		end
	end
end

function VanasKoS:GetListNameByShortName(shortname)
	for k,v in pairs(VANASKOS.Lists) do
		if(v and v[1] and v[1] == shortname) then
			return v[2];
		end
	end
end

function VanasKoS:GetList(list)
	if(listHandler[list] ~= nil) then
		return listHandler[list]:GetList(list);
	end

	return nil;
end

function VanasKoS:GetPlayerData(name)
	local list = self:GetList("PLAYERDATA");
	if(name == nil or not list or list[string.lower(name)] == nil) then
		return nil;
	end
		--      displayname, guild, level, race, class, gender, lastzone, lastseen
	return list[string.lower(name)];
end

function VanasKoS:GetGuildData(name)
	local list = self:GetList("GUILDDATA");
	if(name == nil or list == nil or list[name:lower()] == nil) then
		return nil;
	end
		--      displayname, guild, level, race, class, gender, lastzone, lastseen
	return list[name:lower()].displayname;
end

function VanasKoS:BooleanIsOnList(list, name)
	if(not name) then
		return false;
	end
	
	name = string.trim(name:lower());
	
	local list = VanasKoS:GetList(list);
	
	if(list and list[name]) then
		return true;
	end
	
	return false;
end

local ListsToLookInto = { "PLAYERKOS", "NICELIST", "HATELIST", "GUILDKOS" }
function VanasKoS:IsOnList(list, name)
	if(not name) then
		return nil;
	end
	
	name = string.trim(name:lower());
	
	if(list ~= nil) then
		if(listHandler[list] ~= nil) then
			return listHandler[list]:IsOnList(list, name);
		end
	else
		for k,v in pairs(ListsToLookInto) do
			local listVar = VanasKoS:GetList(v);
			if(listVar and listVar[name]) then
				return listVar[name], v;
			end
		end
	end
		
	return nil;
end

function VanasKoS:AddEntry(list, name, data)
	name = string.trim(name:lower());
	
	if(listHandler[list] ~= nil and listHandler[list].AddEntry ~= nil) then
		listHandler[list]:AddEntry(list, name, data);
	else
		return;
	end
end

function VanasKoS:RemoveEntry(listname, name)
	if(name == nil) then
		return;
	end
	name = name:lower();

	if(listHandler[listname] ~= nil) then
		listHandler[listname]:RemoveEntry(listname, name);
	end
end

--[[----------------------------------------------------------------------
	functions to manipulate the database
------------------------------------------------------------------------]]
function VanasKoS:AddEntryFromTarget(list, args)
	local playername = "";
	local reason = "";
	if(args == nil) then
		args = "";
	end

	VANASKOS.showList = list;
	VanasKoSGUI:ScrollFrameUpdate();

	if(string.find(args, " ")) then
		playername = string.sub(args, 0, string.find(args, " "));
		reason = string.sub(args, string.find(args, " ")+1, string.len(args));
	else
		playername = args;
	end

	if(UnitIsPlayer("target")) then
		if(list == "GUILDKOS") then
			playername = GetGuildInfo("target");
			reason = "";
		else
			playername = UnitName("target");
		end
	end

	if(playername == "") then
		StaticPopup_Show("VANASKOS_ADD_ENTRY");
	else
		if(reason == "") then
			VANASKOS.LastNameEntered = playername;
			StaticPopup_Show("VANASKOS_ADD_REASON_ENTRY");
		else
			VanasKoS:AddEntry(list, playername,  { ['reason'] = reason });
		end
	end
end

function VanasKoS:AddEntryByName(list, playername)
	local reason = "";

	VanasKoSGUI:ShowList(list);

	if(playername == "") then
		StaticPopup_Show("VANASKOS_ADD_ENTRY");
	else
		if(reason == "") then
			VANASKOS.LastNameEntered = playername;
			StaticPopup_Show("VANASKOS_ADD_REASON_ENTRY");
		else
			VanasKoS:AddEntry(list, playername,  { ['reason'] = reason });
		end
	end
end

function VanasKoS:AddKoSPlayer(playername, reason)
	if(reason == nil or reason == "") then
		reason = L["_Reason Unknown_"];
	end
	
	self:AddEntry("PLAYERKOS", playername,  { ['reason'] = reason });
end

function VanasKoS:List_Entry_Added(list, name, data)
	-- TODO: make this nicer
	if(list ~= nil and list ~= "SYNCPLAYER" and list ~= "WANTED" and list~= "LASTSEEN") then
		self:Print(format(L["Entry %s (Reason: %s) added."], name, data and data['reason'] or ""));
	end
end

function VanasKoS:List_Entry_Removed(list, name)
	self:Print(format(L["Entry \"%s\" removed from list"], name));
end

function VanasKoS:AddKoSGuild(guildname, reason)
	if(reason == nil or reason == "") then
		reason = L["_Reason Unknown_"];
	end

	self:AddEntry("GUILDKOS", guildname,  { ['reason'] = reason });
end


-- removes the Player pname from the KoS-List
function VanasKoS:RemoveKoSPlayer(pname)
	if(pname == nil) then
		return nil;
	end;

	self:RemoveEntry("PLAYERKOS", pname);
end

-- removes the Guild gname from the KoS-List
function VanasKoS:RemoveKoSGuild(gname)
	if(gname == nil) then
		return nil;
	end;
	
	self:RemoveEntry("GUILDKOS", gname);
end

-- resets the database
function VanasKoS:ResetKoSList(silent)
	self:ResetDB("realm");
	if(not silent) then
		self:Print(format(L["KoS List for Realm \"%s\" now purged."], GetRealmName()));
	end
	self:TriggerEvent("VanasKoS_KoS_Database_Purged", GetRealmName());
end

--[[----------------------------------------------------------------------
	Configuration Commands
------------------------------------------------------------------------]]

function VanasKoS:ToggleMenu()
	VanasKoSGUI:Toggle();
end

function VanasKoS:ConfigSetNotificationInterval(args)
	if(tonumber(args) == self:GetOpt("NotifyTimerInterval")) then
		return nil;
	end
	self:SetOpt("NotifyTimerInterval", tonumber(args));
	self:TogMsg(L["Notification Interval (seconds)"], self:GetOpt("NotifyTimerInterval"));
end
