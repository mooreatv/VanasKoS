-- Definitions based on Locales

VANASKOS = { };
VANASKOS.DEBUG = false;
--@debug@
VANASKOS.DEBUG = true;
--@end-debug@

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "enUS", true)
if L then
	L["About"] = true
	L["Accept"] = true
	L["Add Entry"] = true
	L["Add KoS Player"] = true
	L["Cancel"] = true
	L["Change Entry"] = true
	L["Configuration"] = true
	L["Donate"] = true
	L["Enable/Disable modules"] = true
	L["Enabled modules"] = true
	L["Enable in Sanctuaries"] = true
	L["Entry %s (Reason: %s) added."] = true
	L["Entry \"%s\" removed from list"] = true
	L["GUI"] = true
	L["KoS List for Realm \"%s\" now purged."] = true
	L["Lists"] = true
	L["Locked"] = true
	L["Locks the Main Window"] = true
	L["Name"] = true
	L["Performance"] = true
	L["Permanent Player-Data-Storage"] = true
	L["Reason"] = true
	L["_Reason Unknown_"] = "unknown"
	L["Remove Entry"] = true
	L["Reset Position"] = true
	L["Resets the Position of the Main Window"] = true
	L["Save data gathered in cities"] = true
	L["show"] = true
	L["sort"] = true
	L["sync"] = true
	L["Toggle Menu"] = true
	L["Toggles detection of players in sanctuaries"] = true
	L["Toggles if data from players gathered in cities should be (temporarily) saved."] = true
	L["Toggles if the combatlog should be used to detect nearby player (Needs UI-Reload)"] = true
	L["Toggles if the data about players (level, class, etc) should be saved permanently."] = true
	L["Use Combat Log"] = true
	L["Vanas KoS"] = true
	L["Version: "] = true
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "frFR")
if L then
-- auto generated from wowace translation app
--@localization(locale="frFR", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "deDE")
if L then
-- auto generated from wowace translation app
--@localization(locale="deDE", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "koKR")
if L then
-- auto generated from wowace translation app
--@localization(locale="koKR", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "esMX")
if L then
-- auto generated from wowace translation app
--@localization(locale="esMX", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "ruRU")
if L then
-- auto generated from wowace translation app
--@localization(locale="ruRU", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "zhCN")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhCN", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "esES")
if L then
-- auto generated from wowace translation app
--@localization(locale="esES", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS", "zhTW")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhTW", format="lua_additive_table", namespace="VanasKoS")@
end

L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS", false);

VANASKOS.NAME = "VanasKoS";
VANASKOS.COMMANDS = {"/kos"; "/vkos"; "/vanaskos"};
VANASKOS.VERSION = "0"; -- filled later
VANASKOS.LastNameEntered = "";
VANASKOS.AUTHOR = "Vane of EU-Aegwynn";

BINDING_HEADER_VANASKOS_HEADER = L["Vanas KoS"];
BINDING_NAME_VANASKOS_TEXT_TOGGLE_MENU = L["Toggle Menu"];
BINDING_NAME_VANASKOS_TEXT_ADD_PLAYER = L["Add KoS Player"];

VANASKOS.NewVersionNotice = nil;
