--[[----------------------------------------------------------------------
      Importer Module - Part of VanasKoS
Handles import of other AddOns KoS Data
------------------------------------------------------------------------]]
local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "enUS", true, VANASKOS.DEBUG)
if L then
-- auto generated from wowace translation app
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "frFR")
if L then
-- auto generated from wowace translation app
--@localization(locale="frFR", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "deDE")
if L then
-- auto generated from wowace translation app
--@localization(locale="deDE", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "koKR")
if L then
-- auto generated from wowace translation app
--@localization(locale="koKR", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "esMX")
if L then
-- auto generated from wowace translation app
--@localization(locale="esMX", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "ruRU")
if L then
-- auto generated from wowace translation app
--@localization(locale="ruRU", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "zhCN")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhCN", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "esES")
if L then
-- auto generated from wowace translation app
--@localization(locale="esES", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Importer", "zhTW")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhTW", format="lua_additive_table", namespace="VanasKoS/Importer")@
end

L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS/Importer", false);

local BC = LibStub("LibBabble-Class-3.0"):GetLookupTable()
local BR = LibStub("LibBabble-Race-3.0"):GetLookupTable()

VanasKoSImporter = VanasKoS:NewModule("Importer", "AceEvent-3.0");
local zoneContinentZoneID = {};

function VanasKoSImporter:OnInitialize()
	VanasKoSGUI:AddConfigOption("Importer", {
		type = "group",
		name = L["Import Data"],
		desc = L["Imports KoS Data from other KoS tools"],
		args = {
			vanaskos_header = {
				order = 1,
				type = "header",
				name = L["Old VanasKoS"],
			},
			oldvanaskos = {
				order = 2,
				type = "execute",
				name = L["Old VanasKoS"],
				desc = L["Imports Data from old VanasKoS"],
				func = function() VanasKoSImporter:FromOldVanasKoS(); end
			},
			ubotd_header = {
				order = 3,
				type = "header",
				name = L["Ultimate Book of the Dead"],
			},
			ubotd = {
				order = 4,
				type = "execute",
				name = L["UBotD KoS"],
				desc = L["Imports KoS Data from Ultimate Book of the Dead"],
				func = function() VanasKoSImporter:FromUBotD(); end
			},
			opium_header = {
				order = 5,
				type = "header",
				name = L["Opium KoS"],
			},
			opium = {
				order = 6,
				type = "execute",
				name = L["Opium KoS"],
				desc = L["Imports KoS Data from Opium"],
				func = function() VanasKoSImporter:FromOpium(); end
			},
			opiumpvpstats = {
				order = 7,
				type = "execute",
				name = L["Opium PvP Stats"],
				desc = L["Imports PvP Stats Data from Opium"],
				func = function() VanasKoSImporter:FromOpiumPvPStats(); end
			},
			skmap_header = {
				order = 8,
				type = "header",
				name = L["Shim's Kill Map"],
			},
			skmap = {
				order = 9,
				type = "execute",
				name = L["SKMap KoS"],
				desc = L["Imports KoS Data from Shim's Kill Map"],
				func = function() VanasKoSImporter:FromSKMap(); end
			},
			skmappvpstats = {
				order = 10,
				type = "execute",
				name = L["SKMap PvP Stats"],
				desc = L["Imports PvP Stats Data from Shim's Kill Map"],
				func = function() VanasKoSImporter:FromSKMapPvPStats(); end
			},
		},
	});
end

function VanasKoSImporter:OnEnable()
	continents = {GetMapContinents()};
	for i, name in ipairs(continents) do
		zoneContinentZoneID[i] = {GetMapZones(i)};
		zoneContinentZoneID[i][0] = name;
	end

	self:ConvertFromOldVanasKoSList();
end

function VanasKoSImporter:OnDisable()
end

local function importListSafe(src, dest) 
	if(not src or not dest) then
		return;
	end
	
	for k,v in pairs(src) do
		if(not dest[k]) then
			dest[k] = src[k];
			VanasKoS:Print("import " .. k);
		end
	end
end

function VanasKoSImporter:FromOldVanasKoS()
	if(VanasKoSDB.namespaces.DefaultLists.realms) then
		for k,v in pairs(VanasKoSDB.namespaces.DefaultLists.realms) do
			if(string.find(k, GetRealmName()) ~= nil) then
				if(v.koslist and v.koslist.players) then
					importListSafe(v.koslist.players, VanasKoSDefaultLists.db.realm.koslist.players);
					v.koslist.players = nil;
				end
				if(v.koslist and v.koslist.guilds) then
					importListSafe(v.koslist.guilds, VanasKoSDefaultLists.db.realm.koslist.guilds);
					v.koslist.guilds = nil;
				end
				v.koslist = nil;
				if(v.hatelist and v.hatelist.players) then
					importListSafe(v.hatelist.players, VanasKoSDefaultLists.db.realm.hatelist.players);
					v.hatelist = nil;
				end
				if(v.nicelist and v.nicelist.players) then
					importListSafe(v.nicelist.players, VanasKoSDefaultLists.db.realm.nicelist.players);
					v.nicelist = nil;
				end
			end
		end
	end
end

function VanasKoSImporter:ConvertFromOldVanasKoSList()
	local koslist = VanasKoS:GetList("PLAYERKOS");
	local datalist = VanasKoS:GetList("PLAYERDATA");
	-- split old koslist data to koslist and playerdata
	for k,v in pairs(koslist) do
		if(koslist[k].lastseen ~= nil and koslist[k].lastseen ~= -1) then
			local name = koslist[k].displayname;
			if(name == nil or name == "") then
				name = k;
			end
			local level = koslist[k].level;
			local class = koslist[k].class;
			local race = koslist[k].race;
			local lastseen = koslist[k].lastseen;
			if(lastseen == -1) then
				lastseen = nil;
			end

			local data = {
				['name'] = name,
				['guild'] = nil,
				['level'] = level,
				['race'] = race,
				['class'] = class,
				['gender'] = 0,
				['zone'] = nil
			};

			self:SendMessage("VanasKoS_Player_Data_Gathered", "PLAYERKOS", data);
			-- fix lastseen:
			datalist[k].lastseen = lastseen;

		end
		-- delete old entries
		koslist[k].displayname = nil;
		koslist[k].level = nil;
		koslist[k].class = nil;
		koslist[k].race = nil;
		koslist[k].lastseen = nil;
	end

	-- convert old foreign entries to the new format
	local lists = { "PLAYERKOS", "GUILDKOS", "HATELIST", "NICELIST" };
	for index, listname in pairs(lists) do
		local list = VanasKoS:GetList(listname);

		for k,v in pairs(list) do
			if(list[k].owner == nil and list[k].creator ~= nil and list[k].sender ~= nil) then
				list[k].owner = list[k].creator:lower();
			end
		end
	end

	--convert continent/id zone information to zone only and
	-- upgrade to new format
	local pvplog = VanasKoS:GetList("PVPLOG");
	if (not (pvplog.player and pvplog.zone and pvplog.event)) then
		local playerlog = {};
		local zonelog = {};
		local eventlog = {};
		for player, event in pairs(pvplog) do
			for timestamp, data in pairs(event) do
				local zone = data.zone or "UNKNOWN";
				if (data.zoneid and data.continent) then
					if (not zoneContinentZoneID[data.continent] or not zoneContinentZoneID[data.continent][data.zoneid]) then
						VanasKoS:Print("pvplog: Invalid continent:" .. data.continent .. " zoneid:" .. data.zoneid);
					else
						zone = zoneContinentZoneID[data.continent][data.zoneid];
					end
				end
				tinsert(eventlog, {['enemyname'] = player,
							['time'] = timestamp,
							['myname'] = data['myname'],
							['mylevel'] = data['mylevel'],
							['enemylevel'] = data['enemylevel'],
							['type'] = data['type'],
							['zone']  = zone,
							['posX'] = data['posX'],
							['posY'] = data['posY'],
						});

				if (not zonelog[zone]) then
					zonelog[zone] = {};
				end
				tinsert(zonelog[zone], #eventlog);

				if (not playerlog[player]) then
					playerlog[player] = {};
				end
				tinsert(playerlog[player], #eventlog);
			end
		end
		wipe(pvplog);

		pvplog.event = eventlog;
		pvplog.player = playerlog;
		pvplog.zone = zonelog;
	end

	--convert continent/id zone information to zone only
	for player, data in pairs(datalist) do
		if (data.zoneid and data.continent) then
			if (not zoneContinentZoneID[data.continent] or not zoneContinentZoneID[data.continent][data.zoneid]) then
				VanasKoS:Print("playerdata: Invalid continent:" .. data.continent .. " zoneid:" .. data.zoneid);
				pvplog[player][timestamp].zone = "UNKNOWN";
			else
				pvplog[player][timestamp].zone = zoneContinentZoneID[data.continent][data.zoneid];
			end
			datalist[player].zoneid = nil;
			datalist[player].continent = nil;
		end
	end
end
--[[----------------------------------------------------------------------
	Import Functions
------------------------------------------------------------------------]]

local SKMZoneTranslate = {
	["KA_01"] = "Ashenvale",
	["KA_02"] = "Azshara",
	["KA_03"] = "Azuremyst Isle",
	["KA_04"] = "Bloodmyst Isle",
	["KA_05"] = "Darkshore",
	["KA_06"] = "Darnassus",
	["KA_07"] = "Desolace",
	["KA_08"] = "Durotar",
	["KA_09"] = "Dustwallow Marsh",
	["KA_10"] = "Felwood",
	["KA_11"] = "Feralas",
	["KA_12"] = "Moonglade",
	["KA_13"] = "Mulgore",
	["KA_14"] = "Orgrimmar",
	["KA_15"] = "Silithus",
	["KA_16"] = "Stonetalon Mountains",
	["KA_17"] = "Tanaris",
	["KA_18"] = "Teldrassil",
	["KA_19"] = "The Barrens",
	["KA_20"] = "The Exodar",
	["KA_21"] = "Thousand Needles",
	["KA_22"] = "Thunder Bluff",
	["KA_23"] = "Un'Goro Crater",
	["KA_24"] = "Winterspring",
	["EK_01"] = "Alterac Mountains",
	["EK_02"] = "Arathi Highlands",
	["EK_03"] = "Badlands",
	["EK_04"] = "Blasted Lands",
	["EK_05"] = "Burning Steppes",
	["EK_06"] = "Deadwind Pass",
	["EK_07"] = "Dun Morogh",
	["EK_08"] = "Duskwood",
	["EK_09"] = "Eastern Plaguelands",
	["EK_10"] = "Elwynn Forest",
	["EK_11"] = "Eversong Woods",
	["EK_12"] = "Ghostlands",
	["EK_13"] = "Hillsbrad Foothills",
	["EK_14"] = "Ironforge",
	["EK_15"] = "Loch Modan",
	["EK_16"] = "Redridge Mountains",
	["EK_17"] = "Searing Gorge",
	["EK_18"] = "Silvermoon City",
	["EK_19"] = "Silverpine Forest",
	["EK_20"] = "Stormwind City",
	["EK_21"] = "Stranglethorn Vale",
	["EK_22"] = "Swamp of Sorrows",
	["EK_23"] = "The Hinterlands",
	["EK_24"] = "Tirisfal Glades",
	["EK_25"] = "Undercity",
	["EK_26"] = "Western Plaguelands",
	["EK_27"] = "Westfall",
	["EK_28"] = "Wetlands",
	["OL_01"] = "Blade's Edge Mountains",
	["OL_02"] = "Hellfire Peninsula",
	["OL_03"] = "Nagrand",
	["OL_04"] = "Netherstorm",
	["OL_05"] = "Shadowmoon Valley",
	["OL_06"] = "Shattrath City",
	["OL_07"] = "Terokkar Forest",
	["OL_08"] = "Zangarmarsh",

	-- These are not defined in current skmap
	--["EK_29"] = "Isle of Quel'Danas",
	--["NR_01"] = "Borean Tundra",
	--["NR_02"] = "Crystalsong Forest",
	--["NR_03"] = "Dalaran",
	--["NR_04"] = "Dragonblight",
	--["NR_05"] = "Grizzly Hills",
	--["NR_06"] = "Howling Fjord",
	--["NR_07"] = "Icecrown",
	--["NR_08"] = "Sholazar Basin",
	--["NR_09"] = "The Storm Peaks",
	--["NR_10"] = "Wintergrasp",
	--["NR_11"] = "Zul'Drak",
};

local SKMRaceTranslate = {BR["Dwarf"], BR["Gnome"], BR["Human"], BR["Night Elf"], BR["Orc"], BR["Tauren"], BR["Troll"], BR["Undead"], BR["Draenei"], BR["Blood Elf"]};
local SKMClassTranslate = {BC["Druid"], BC["Hunter"], BC["Mage"], BC["Paladin"], BC["Priest"], BC["Rogue"], BC["Shaman"], BC["Warrior"], BC["Warlock"]};

local function SKMGetZoneName(ZoI)
	if (ZoI ~= nil) then
		return SKMZoneTranslate[ZoI];
	end
	return nil;
end

local function SKMTypeResult(enemyType, killType)
	if (enemyType == "EPl" or enemyType == "enemyPlayer") then
		if (killType == "PK" or killType == "PaK" or killType == "PfK" or
			killType == "LwK" or killType == "playerKill" or
			killType == "playerAssistKill" or 
			killType == "playerFullKill" or
			killType == "loneWolfKill") then
			return "win";
		elseif (killType == "PDp" or killType == "playerDeathPvP") then
			return "loss";
		else
			return nil;
		end
	end
	return nil;
end

local function SKMTimeTranslate(strDate)
	if (strDate == nil) then
		return nil;
	end

	local skDate = {string.match(strDate, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")};
	return time({year = skDate[3], month = skDate[2], day = skDate[1],
			hour=skDate[4], min = skDate[5], sec = skDate[6]});
end

-- returns imported
local function importSKMapPoint(player, idx)
	local point = assert(SKM_Data[GetRealmName()][player].GlobalMapData[idx]);
	local myname = SKM_Data[GetRealmName()][player]["PlayerName"] or player;
	local posX = point["x"] or point["xpos"];
	local posY = point["y"] or point["ypos"];
	local zone = point["zoneName"] or SKMGetZoneName(point["ZoI"]);
	local info = point["Inf"] or point["storedInfo"];
	local name, sktype, sktime;
	if (info ~= nil) then
		local enemyType = info["ETy"] or info["enemyType"];
		local killType = info["Ty"] or info["type"];
		sktype = SKMTypeResult(enemyType, killType);
		name = info["Na"] or info["name"];
		sktime = SKMTimeTranslate(info["Da"] or info["date"]) or date();
	end
	if (not (posX and posY and zone and name and sktype and sktime)) then
		return 0;
	end

	VanasKoS:AddEntry("PVPLOG", name:lower(), { ['time'] = sktime,
					['myname'] = myname,
					['type'] = sktype,
					['zone']  = zone,
					['posX'] = posX,
					['posY'] = posY });
	return 1;
end

-- returns imported
local function importSKMapEnemyStats(player, enemy)
	local etable = assert(SKM_Data[GetRealmName()][player].EnemyHistory[enemy]);
	local pvpstats = VanasKoS:GetList("PVPSTATS");
	local wins = tonumber(etable["PK"] or etable["playerKill"]) or 0;
	local losses = tonumber(etable["EKP"] or etable["enemyKillPlayer"]) or 0;
	local name = etable["Na"] or etable["name"] or enemy;
	local lname = name:lower();

	if (wins + losses > 0) then
		if (not pvpstats[lname]) then
			pvpstats[lname] = {['wins'] = wins, ['losses'] = losses};
		else
			pvpstats[lname].wins = wins + (pvpstats[lname].wins or 0);
			pvpstats[lname].losses = losses + (pvpstats[lname].losses or 0);
		end

		return 1;
	end

	return 0;
end

-- returns imported, already_exists
local function importSKMapEnemy(player, enemy)
	local etable = assert(SKM_Data[GetRealmName()][player].EnemyHistory[enemy]);
	local myname = SKM_Data[GetRealmName()][player]["PlayerName"] or player;
	local playerkos = VanasKoS:GetList("PLAYERKOS");
	local datalist = VanasKoS:GetList("PLAYERDATA");
	local name = etable["Na"] or etable["name"] or enemy;
	local lname = name:lower();

	if (etable["Wr"] == true or etable["atWar"] == true) then
		local reason = etable["PlN"] or etable["playerNote"];
		local created = SKMTimeTranslate(etable["WD"] or etable["warDate"]) or date();
		local guild = etable["Gu"] or etable["guild"];
		local level = etable["Lv"] or etable["level"];
		level = (level ~= -1 and level) or nil;
		local class = SKMClassTranslate[etable["Cl"] or etable["class"]];
		local race = SKMRaceTranslate[etable["Ra"] or etable["race"]];
		local lastseen = SKMTimeTranslate(etable["lV"] or etable["lastView"]);
		local zone = etable["zoneName"] or SKMGetZoneName(etable["ZoI"]);
		if (not datalist[lname]) then
			datalist[lname] = { 	['guild'] = guild,
						['level'] = level,
						['class'] = class,
						['race'] = race,
						['lastseen'] = lastseen,
						['zone'] = zone
					};
		elseif (lastseen > datalist[lname].lastseen) then
			datalist[lname].guild = guild;
			datalist[lname].level = level;
			datalist[lname].class = class;
			datalist[lname].race = race;
			datalist[lname].lastseen = lastseen;
			datalist[lname].zone = zone;
		end
		if (not playerkos[lname]) then
			playerkos[lname] = {['reason'] = reason, ['created'] = created, ['creator'] = myname};
			return 1, 0;
		end

		return 0, 1;
	end

	return 0, 0;
end

-- returns imported, already_exists
local function importSKMapGuild(player, guild)
	local gtable = assert(SKM_Data[GetRealmName()][player].GuildHistory[guild]);
	local myname = SKM_Data[GetRealmName()][player]["PlayerName"] or player;
	local guildkos = VanasKoS:GetList("GUILDKOS");

	if (gtable["Wr"] == true or gtable["atWar"] == true) then
		local name = gtable["Na"] or gtable["name"] or guild;
		local lname = name:lower();
		local reason = nil;
		local created = SKMTimeTranslate(gtable["WD"] or gtable["warDate"]) or date();
		if (gtable["playerNote"] ~= nil) then
			reason = gtable["playerNote"];
		elseif (gtable["plN"] ~= nil) then
			reason = gtable["plN"];
		end
		if (not guildkos[lname]) then
			guildkos[lname] = {	['reason'] = reason,
						['created'] = created,
						['creator'] = myname,
					};
			return 1, 0;
		end

		return 0, 1;
	end

	return 0, 0;
end

function VanasKoSImporter:FromSKMap()
	if (SKM_Data == nil or SKM_Data[GetRealmName()] == nil) then
		VanasKoS:Print(L["SKMap data couldn't be loaded"]);
		return;
	end

	local kos_add = 0;
	local kos_dup = 0;

	for player, p in pairs(SKM_Data[GetRealmName()]) do
		if (p["EnemyHistory"] ~= nil) then 
			for enemy, e in pairs(p["EnemyHistory"]) do
				local tmp_add, tmp_dup = importSKMapEnemy(player, enemy);
				kos_add = kos_add + tmp_add;
				kos_dup = kos_dup + tmp_dup;
			end
		end
		if (p["GuildHistory"] ~= nil) then
			for guild, g in pairs(p["GuildHistory"]) do
				local tmp_add, tmp_dup = importSKMapGuild(player, guild);
				kos_add = kos_add + tmp_add;
				kos_dup = kos_dup + tmp_dup;
			end
		end
	end

	VanasKoS:Print(format(L["Imported %d KoS entries (%d duplicates)"], kos_add, kos_dup));
	VanasKoS:Print(L["SKMap data was imported"]);
	VanasKoSGUI:Update();
end

function VanasKoSImporter:FromSKMapPvPStats()
	if (SKM_Data == nil or SKM_Data[GetRealmName()] == nil) then
		VanasKoS:Print(L["SKMap data couldn't be loaded"]);
		return;
	end

	local stats = 0;
	local events = 0;

	for player, p in pairs(SKM_Data[GetRealmName()]) do
		if (p["EnemyHistory"] ~= nil) then 
			for enemy, e in pairs(p["EnemyHistory"]) do
				local tmp_stats = importSKMapEnemyStats(player, enemy);
				stats = stats + tmp_stats;
			end
		end
		if (p["GlobalMapData"] ~= nil) then
			for i, p in ipairs(p["GlobalMapData"]) do
				tmp_events = importSKMapPoint(player, i);
				events = events + tmp_events;
			end
		end
	end

	VanasKoS:Print(format(L["Updated %d PVP statistics"], stats));
	VanasKoS:Print(format(L["Imported %d PVP events"], events));
	VanasKoS:Print(L["SKMap data was imported"]);
	VanasKoSGUI:Update();
end

function VanasKoSImporter:FromUBotD()
	if(ubdKos == nil) then
		VanasKoS:Print(L["UBotD data couldn't be loaded"]);
		return nil;
	end
	if(ubdKos.kos == nil) then
		VanasKoS:Print(L["UBotD data couldn't be loaded"]);
		return nil;
	end
	for index, value in pairs(ubdKos.kos) do
		if(value.notes == "Unk") then
			VanasKoS:AddKoSPlayer(index, nil);
			VanasKoS:Print(index .. " " .. L["imported"] .. ".");
		else
			VanasKoS:AddKoSPlayer(index, value.notes);
			VanasKoS:Print(index .. " (" .. value.notes .. ") " .. L["imported"] .. ".");
		end
	end
	VanasKoS:Print(L["UBotD data was imported"]);
	VanasKoSGUI:Update();
end

function VanasKoSImporter:FromOpiumPvPStats()
	if(not OpiumData or not OpiumData.playerLinks or not OpiumData.playerLinks[GetRealmName()]) then
		VanasKoS:Print(L["Opium data couldn't be loaded"]);
		return;
	end
	local player = OpiumData.playerLinks[GetRealmName()];
	for k,v in pairs(player) do
		-- 0 = level
		-- 1 = race
		-- 2 = class
		-- 3 = faction
		-- 4 = guild
		-- 5 = guilt title
		-- 6 = lastseen
		-- 7 = losses
		-- 8 = wins
		-- 9 = pvprank
		if(v[7] or v[8]) then
			local lname = k:lower();
			local list = VanasKoS:GetList("PVPSTATS");

			if(not list[lname]) then
				list[lname] = { ['wins'] = 0, ['losses'] = 0};
			end

			if(v[7]) then  -- loss
				list[lname].losses = list[lname].losses + tonumber(v[7]);
			end
			if(v[8]) then -- win
				list[lname].wins = list[lname].wins + tonumber(v[8]);
			end

			VanasKoS:Print(k .. " " .. L["imported"] .. ".");
		end
	end
	VanasKoS:Print(L["Opium data was imported"]);
	VanasKoSGUI:Update();
end

function VanasKoSImporter:FromOpium()
	if(not OpiumData) then
		VanasKoS:Print(L["Opium data couldn't be loaded"]);
		return;
	end
	if(OpiumData.kosPlayer and OpiumData.kosPlayer[GetRealmName()]) then
		local list = OpiumData.kosPlayer[GetRealmName()];

		for k,v in pairs(list) do
			-- 1 = kos, 2 = friendly
			if(v[1] == 1 or v[1] == nil) then
				VanasKoS:AddEntry("PLAYERKOS", k, { ['reason'] = v[0] });
			elseif(v[1] == 2) then
				VanasKoS:AddEntry("NICELIST", k,  { ['reason'] = v[0] });
			end
		end

	end
	if(OpiumData.kosGuild and OpiumData.kosGuild[GetRealmName()]) then
		local list = OpiumData.kosGuild[GetRealmName()];

		for k,v in pairs(list) do
			-- 1 = kos, 2 = friendly (ignored because no friendly guild list)
			if(v[1] == 1 or v[1] == nil) then
				VanasKoS:AddEntry("GUILDKOS", k:gsub("_", " "),  { ['reason'] = v[0] });
			elseif(v[1] == 2) then
				-- ignore
			end
		end
	end
	VanasKoS:Print(L["Opium data was imported"]);
	VanasKoSGUI:Update();
end
