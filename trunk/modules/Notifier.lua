--[[----------------------------------------------------------------------
      Notifier Module - Part of VanasKoS
Notifies the user via Tooltip, Chat and Upper Area of a KoS/other List Target
------------------------------------------------------------------------]]

local L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "enUS", true, VANASKOS.DEBUG)
if L then
-- auto generated from wowace translation app
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "frFR")
if L then
-- auto generated from wowace translation app
--@localization(locale="frFR", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "deDE")
if L then
-- auto generated from wowace translation app
--@localization(locale="deDE", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "koKR")
if L then
-- auto generated from wowace translation app
--@localization(locale="koKR", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "esMX")
if L then
-- auto generated from wowace translation app
--@localization(locale="esMX", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "ruRU")
if L then
-- auto generated from wowace translation app
--@localization(locale="ruRU", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "zhCN")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhCN", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "esES")
if L then
-- auto generated from wowace translation app
--@localization(locale="esES", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):NewLocale("VanasKoS/Notifier", "zhTW")
if L then
-- auto generated from wowace translation app
--@localization(locale="zhTW", format="lua_additive_table", namespace="VanasKoS/Notifier")@
end

L = LibStub("AceLocale-3.0"):GetLocale("VanasKoS/Notifier", false);
VanasKoSNotifier = VanasKoS:NewModule("Notifier", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0");
local VanasKoSNotifier = VanasKoSNotifier;
local VanasKoS = VanasKoS;

local FADE_IN_TIME = 0.2;
local FADE_OUT_TIME = 0.2;
local FLASH_TIMES = 1;

local SML = LibStub("LibSharedMedia-3.0");
SML:Register("sound", "VanasKoS: String fading", "Interface\\AddOns\\VanasKoS\\Artwork\\StringFading.mp3");
SML:Register("sound", "VanasKoS: Zoidbergs whooping", "Interface\\AddOns\\VanasKoS\\Artwork\\Zoidberg-Whoopwhoopwhoop.mp3");

local notifyAllowed = true;
local flashNotifyFrame = nil;
local reasonFrame = nil

function VanasKoSNotifier:CreateReasonFrame()
	reasonFrame = CreateFrame("Frame", "VanasKoS_Notifier_ReasonFrame");
	reasonFrame:SetWidth(300);
	reasonFrame:SetHeight(13);
	reasonFrame:SetPoint("CENTER");
	reasonFrame:SetMovable(true);
	reasonFrame:SetToplevel(true);

	reasonFrame.background = reasonFrame:CreateTexture("VanasKoS_Notifier_ReasonFrame_Background", "BACKGROUND");
	reasonFrame.background:SetAllPoints();
	reasonFrame.background:SetTexture(1.0, 1.0, 1.0, 0.5);

	reasonFrame.text = reasonFrame:CreateFontString("VanasKoS_Notifier_ReasonFrame_Text", "OVERLAY");
	-- only set the left point, so texts longer than reasonFrame:GetWidth() will show
	reasonFrame.text:SetPoint("LEFT", reasonFrame, "LEFT", 0, 0);
	reasonFrame.text:SetJustifyH("LEFT");
	reasonFrame.text:SetFontObject("GameFontNormalSmall");
	reasonFrame.text:SetTextColor(1.0, 0.0, 1.0);

	reasonFrame:RegisterForDrag("leftbutton");
	reasonFrame:SetScript("OnDragStart", function() reasonFrame:StartMoving(); end);
	reasonFrame:SetScript("OnDragStart", function() reasonFrame:StartMoving(); end);
	reasonFrame:SetScript("OnDragStop", function() reasonFrame:StopMovingOrSizing(); end);
	reasonFrame.background:SetAlpha(0.0);

	if (self.db.profile.notifyExtraReasonFrameLocked) then
		reasonFrame:EnableMouse(false);
	else
		reasonFrame:EnableMouse(true);
	end

	if (self.db.profile.notifyExtraReasonFrameEnabled) then
		reasonFrame:Show();
	else
		reasonFrame:Hide();
	end
end

function VanasKoSNotifier:EnableReasonFrame(enable)
	self.db.profile.notifyExtraReasonFrameEnabled = enable;
	if (enable) then
		reasonFrame:Show();
	else
		reasonFrame:Hide();
	end
end

function VanasKoSNotifier:LockReasonFrame(lock)
	self.db.profile.notifyExtraReasonFrameLocked = lock;
	if (lock) then
		reasonFrame:EnableMouse(false);
	else
		reasonFrame:EnableMouse(true);
	end
end

function VanasKoSNotifier:ShowAnchorReasonFrame(show)
	reasonFrame.showanchor = show;
	if (show) then
		reasonFrame.background:SetAlpha(1.0);
		reasonFrame.text:SetText(self:GetKoSString(nil, "Guild", "MyReason", UnitName("player"), nil, "GuildKoS Reason", UnitName("player"), nil));
	else
		reasonFrame.background:SetAlpha(0.0);
		reasonFrame.text:SetText("");
	end
end

local function SetSound(faction, value)
	if (faction == "enemy") then
		VanasKoSNotifier.db.profile.enemyPlayName = value;
	else
		VanasKoSNotifier.db.profile.playName = value;
	end
	
	VanasKoSNotifier:PlaySound(value);
end

local function GetSound(faction)
	if (faction == "enemy") then
		return VanasKoSNotifier.db.profile.enemyPlayName;
	else
		return VanasKoSNotifier.db.profile.playName;
	end
end

local mediaList = { };
local function GetMediaList()
	for k,v in pairs(SML:List("sound")) do
		mediaList[v] = v;
	end
	
	return mediaList;
end

function VanasKoSNotifier:OnInitialize()
	
	self.db = VanasKoS.db:RegisterNamespace("Notifier", {
		profile = {
			Enabled = true,
			notifyVisual = true,
			notifyChatframe = true,
			notifyTargetFrame = true,
			notifyOnlyMyTargets = true,
			notifyEnemyTargets = false,
			notifyFlashingBorder = true,
			notifyInShattrathEnabled = false,
			notifyExtraReasonFrameEnabled = false,
			notifyExtraReasonFrameLocked = false,
			notifyShowPvPStats = true,

			NotifyTimerInterval = 60,

			playName = "VanasKoS: String fading",
			enemyPlayName = "None",
		}
	});

	flashNotifyFrame = CreateFrame("Frame", "VanasKoS_Notifier_Frame", WorldFrame);
	flashNotifyFrame:SetAllPoints();
	flashNotifyFrame:SetToplevel(1);
	flashNotifyFrame:SetAlpha(0);

	local texture = flashNotifyFrame:CreateTexture(nil, "BACKGROUND");
	texture:SetTexture("Interface\\AddOns\\VanasKoS\\Artwork\\KoSFrame");

	texture:SetBlendMode("ADD");
	texture:SetAllPoints(); -- important! gets set in the blizzard xml stuff implicit, while we have to do it explicit with .lua
	flashNotifyFrame:Hide();

	self:CreateReasonFrame();

	local configOptions = {
		type = 'group',
		name = L["Notifications"],
		desc = L["Notifications"],
		args = {
			upperarea = {
				type = 'toggle',
				name = L["Notification in the Upper Area"],
				desc = L["Notification in the Upper Area"],
				order = 1,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyVisual = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyVisual; end,
			},
			chatframe = {
				type = 'toggle',
				name = L["Notification in the Chatframe"],
				desc = L["Notification in the Chatframe"],
				order = 2,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyChatframe = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyChatframe; end,
			},
			targetframe = {
				type = 'toggle',
				name = L["Notification through Target Portrait"],
				desc = L["Notification through Target Portrait"],
				order = 3,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyTargetFrame = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyTargetFrame; end,
			},
			flashingborder = {
				type = 'toggle',
				name = L["Notification through flashing Border"],
				desc = L["Notification through flashing Border"],
				order = 4,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyFlashingBorder = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyFlashingBorder; end,
			},
			onlymytargets = {
				type = 'toggle',
				name = L["Notify only on my KoS-Targets"],
				desc = L["Notify only on my KoS-Targets"],
				order = 5,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyOnlyMyTargets = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyOnlyMyTargets; end,
			},
			notifyenemy = {
				type = 'toggle',
				name = L["Notify of any enemy target"],
				desc = L["Notify of any enemy target"],
				order = 6,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyEnemyTargets = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyEnemyTargets; end,
			},
			insanctuary = {
				type = 'toggle',
				name = L["Notify in Sanctuary"],
				desc = L["Notify in Sanctuary"],
				order = 7,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyInShattrathEnabled = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyInShattrathEnabled; end,
			},
			showpvpstats = {
				type = 'toggle',
				name = L["Show PvP-Stats in Tooltip"],
				desc = L["Show PvP-Stats in Tooltip"],
				order = 8,
				set = function(frame, v) VanasKoSNotifier.db.profile.notifyShowPvPStats = v; end,
				get = function() return VanasKoSNotifier.db.profile.notifyShowPvPStats; end,
			},
			notificationInterval = {
				type = 'range',
				name = L["Notification Interval (seconds)"],
				desc = L["Notification Interval (seconds)"],
				min = 0,
				max = 600,
				step = 5,
				order = 9,
				set = function(frame, value) VanasKoSNotifier.db.profile.NotifyTimerInterval = value; end,
				get = function() return VanasKoSNotifier.db.profile.NotifyTimerInterval; end,
			},
			kosSound = {
				type = 'select',
				name = L["Sound on KoS detection"],
				desc = L["Sound on KoS detection"],
				order = 10,
				get = function() return GetSound("kos"); end,
				set = function(frame, value) SetSound("kos", value); end,
				values = function() return GetMediaList(); end,
			},
			enemySound = {
				type = 'select',
				name = L["Sound on enemy detection"],
				desc = L["Sound on enemy detection"],
				order = 11,
				get = function() return GetSound("enemy"); end,
				set = function(frame, value) SetSound("enemy", value); end,
				values = function() return GetMediaList(); end,
			},
			extrareasonframetitle = {
				type = 'header',
				name = L["Additional Reason Window"],
				desc = L["Additional Reason Window"],
				order = 12,
			},
			extrareasonframeenabled = {
				type = 'toggle',
				name = L["Enabled"],
				desc = L["Enabled"],
				order = 13,
				set = function(frame, v) VanasKoSNotifier:EnableReasonFrame(v); end,
				get = function() return VanasKoSNotifier.db.profile.notifyExtraReasonFrameEnabled; end,
			},
			extrareasonframelocked = {
				type = 'toggle',
				name = L["Locked"],
				desc = L["Locked"],
				order = 14,
				set = function(frame, v) VanasKoSNotifier:LockReasonFrame(v); end,
				get = function() return VanasKoSNotifier.db.profile.notifyExtraReasonFrameLocked; end,
			},
			extrareasonframeshowanchor = {
				type = 'toggle',
				name = L["Show Anchor"],
				desc = L["Show Anchor"],
				order = 15,
				set = function(frame, v) VanasKoSNotifier:ShowAnchorReasonFrame(v); end,
				get = function() return reasonFrame.showanchor; end,

			}
		},
	};

	VanasKoSGUI:AddModuleToggle("Notifier", L["Notifications"]);
	VanasKoSGUI:AddConfigOption("Notifier", configOptions);
	self:SetEnabledState(self.db.profile.Enabled);
end

function VanasKoSNotifier:OnEnable()
	self:RegisterMessage("VanasKoS_Player_Detected", "Player_Detected");
	self:RegisterMessage("VanasKoS_Player_Target_Changed", "Player_Target_Changed");
	self:RegisterMessage("VanasKoS_Mob_Target_Changed", "Player_Target_Changed");
	self:HookScript(GameTooltip, "OnTooltipSetUnit");
end

function VanasKoSNotifier:OnDisable()
	self:UnregisterAllMessages();
end

local listsToCheck = {
		['PLAYERKOS'] = { L["KoS: %s"], L["%sKoS: %s"] },
		['GUILDKOS'] = { L["KoS (Guild): %s"], L["%sKoS (Guild): %s"] },
		['NICELIST'] = { L["Nicelist: %s"], L["%sNicelist: %s"] },
		['HATELIST'] = { L["Hatelist: %s"], L["%sHatelist: %s"] },
		['WANTED'] = {  L["Wanted: %s"], L["%sWanted: %s"] },
	};

function VanasKoSNotifier:OnTooltipSetUnit(tooltip, ...)
	if(not UnitIsPlayer("mouseover")) then
		--return self.hooks[tooltip].OnTooltipSetUnit(tooltip, ...);
		return;
	end

	local name, realm = UnitName("mouseover");
	if(realm ~= nil) then
		return; -- self.hooks[tooltip].OnTooltipSetUnit(tooltip, ...);
	end
	local guild = GetGuildInfo("mouseover");

	-- add the KoS: <text> and KoS (Guild): <text> messages
	for k,v in pairs(listsToCheck) do
		local data = nil;
		if(k ~= "GUILDKOS") then
			data = VanasKoS:IsOnList(k, name);
		else
			data = VanasKoS:IsOnList(k, guild);
		end
		if(data) then
			local reason = data.reason or "";
			if(data.owner == nil) then
				tooltip:AddLine(format(v[1], reason));
			else
				tooltip:AddLine(format(v[2], data.creator or data.owner, reason));
			end
		end
	end

	-- add pvp stats line if turned on and data is available
	if(UnitIsEnemy("mouseover", "player") and self.db.profile.notifyShowPvPStats) then
		local data = VanasKoS:IsOnList("PVPSTATS", name);
		local playerdata = VanasKoS:IsOnList("PLAYERDATA", name);

		if(data or playerdata) then
			tooltip:AddLine(format(L["seen: |cffffffff%d|r - wins: |cff00ff00%d|r - losses: |cffff0000%d|r"], (playerdata and playerdata.seen) or 0, (data and data.wins) or 0, (data and data.losses) or 0));
		end
	end

	--return self.hooks[tooltip].OnTooltipSetUnit(tooltip, ...);
end

function VanasKoSNotifier:UpdateReasonFrame(name, guild)
	if(self.db.profile.notifyExtraReasonFrameEnabled) then
		if(UnitIsPlayer("target")) then
			if(not VanasKoS_Notifier_ReasonFrame_Text) then
				return;
			end
			local data = VanasKoS:IsOnList("PLAYERKOS", name);
			local gdata = VanasKoS:IsOnList("GUILDKOS", guild);

			if(data) then
				VanasKoS_Notifier_ReasonFrame_Text:SetTextColor(1.0, 0.81, 0.0, 1.0);
				VanasKoS_Notifier_ReasonFrame_Text:SetText(self:GetKoSString(name, guild, data.reason, data.creator, data.owner, gdata and gdata.reason, gdata and gdata.creator, gdata and gdata.owner));
				return;
			end

			local hdata = VanasKoS:IsOnList("HATELIST", name);
			if(hdata and hdata.reason ~= nil) then
				VanasKoS_Notifier_ReasonFrame_Text:SetTextColor(1.0, 0.0, 0.0, 1.0);
				if(hdata.creator ~= nil and hdata.owner ~= nil)  then
					VanasKoS_Notifier_ReasonFrame_Text:SetText(format(L["|cffff00ff%s's|r Hatelist: %s"], hdata.creator, hdata.reason));
				else
					VanasKoS_Notifier_ReasonFrame_Text:SetText(format(L["Hatelist: %s"], hdata.reason));
				end
				return;
			end

			local ndata = VanasKoS:IsOnList("NICELIST", name);
			if(ndata and ndata.reason ~= nil) then
				VanasKoS_Notifier_ReasonFrame_Text:SetTextColor(0.0, 1.0, 0.0, 1.0);
				if(ndata.creator ~= nil and ndata.owner ~= nil)  then
					VanasKoS_Notifier_ReasonFrame_Text:SetText(format(L["|cffff00ff%s's|r Nicelist: %s"], ndata.creator, ndata.reason));
				else
					VanasKoS_Notifier_ReasonFrame_Text:SetText(format(L["Nicelist: %s"], ndata.reason));
				end
				return;
			end

			VanasKoS_Notifier_ReasonFrame_Text:SetText("");
		else
			VanasKoS_Notifier_ReasonFrame_Text:SetText("");
		end

	end
end

function VanasKoSNotifier:Player_Target_Changed(message, data)
	-- data is nil if target was changed to a mob, and the name and guild
	-- are null if the target was changed to self.
	local name = data and data.name or UnitName("target");
	local guild = data and data.guild or GetGuildInfo("target");
	if(self.db.profile.notifyTargetFrame) then
		if(UnitIsPlayer("target")) then
			if(VanasKoS:BooleanIsOnList("PLAYERKOS", name)) then
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
				TargetFrameTexture:SetVertexColor(1.0, 1.0, 1.0, TargetFrameTexture:GetAlpha());
			elseif(VanasKoS:BooleanIsOnList("GUILDKOS", guild)) then
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
				TargetFrameTexture:SetVertexColor(1.0, 1.0, 1.0, TargetFrameTexture:GetAlpha());
			elseif(VanasKoS:BooleanIsOnList("HATELIST", name)) then
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
				TargetFrameTexture:SetVertexColor(1.0, 0.0, 0.0, TargetFrameTexture:GetAlpha());
			elseif(VanasKoS:BooleanIsOnList("NICELIST", name)) then
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
				TargetFrameTexture:SetVertexColor(0.0, 1.0, 0.0, TargetFrameTexture:GetAlpha());
			else
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
				TargetFrameTexture:SetVertexColor(1.0, 1.0, 1.0, TargetFrameTexture:GetAlpha());
			end
		else
			TargetFrameTexture:SetVertexColor(1.0, 1.0, 1.0, TargetFrameTexture:GetAlpha());
		end
	end
	self:UpdateReasonFrame(name, guild);
end

--/script VanasKoS:SendMessage("VanasKoS_Player_Detected", "Apfelherz", nil, "kos");
function VanasKoSNotifier:GetKoSString(name, guild, reason, creator, owner, greason, gcreator, gowner)
	local msg = "";

	if(reason ~= nil) then
		if(creator ~= nil and owner ~= nil) then
			if(name == nil) then
				msg = format(L["|cffff00ff%s's|r KoS: %s"], creator, reason);
			else
				msg = format(L["|cffff00ff%s's|r KoS: %s"], creator, name .. " (" .. reason .. ")");
			end
		else
			if(name == nil) then
				msg = format(L["KoS: %s"], reason);
			else
				msg = format(L["KoS: %s"], name .. " (" .. reason .. ")");
			end
		end
		if(guild) then
			msg = msg .. " <" .. guild .. ">";
			if(greason ~= nil) then
				msg = msg .. " (" .. greason .. ")";
			end
		end
	elseif(greason ~= nil) then
		msg = format(L["KoS (Guild): %s"], name .. " <" .. guild .. "> (" ..  greason .. ")");
	else
		if(creator ~= nil and owner ~= nil) then
			if(name == nil) then
				msg = format(L["|cffff00ff%s's|r KoS: %s"], creator, "");
			else
				msg = format(L["|cffff00ff%s's|r KoS: %s"], creator, name);
			end
		else
			if(name == nil) then
				msg = format(L["KoS: %s"], "");
			else
				msg = format(L["KoS: %s"], name);
			end
		end
		if(guild) then
			msg = msg .. " <" .. guild .. ">";
		end
	end

	return msg;
end

local function ReenableNotifications()
	notifyAllowed = true;
end

function VanasKoSNotifier:Player_Detected(message, data)
	assert(data.name ~= nil);
	
	if (data.faction == nil) then
		return
	end

	if (notifyAllowed ~= true) then
		return;
	end

	-- don't notify if we're in shattrah
	if(VanasKoSDataGatherer:IsInSanctuary() and not self.db.profile.notifyInShattrathEnabled) then
		return;
	end

	if (data.faction == "kos") then
		VanasKoSNotifier:KosPlayer_Detected(data);
	elseif (data.faction == "enemy") then
		VanasKoSNotifier:EnemyPlayer_Detected(data);
	end
end

function VanasKoSNotifier:EnemyPlayer_Detected(data)
	assert(data.name ~= nil);

	if(self.db.profile.notifyEnemyTargets == false) then
		return;
	end
	notifyAllowed = false;
	-- Reallow Notifies in NotifyTimeInterval Time
	self:ScheduleTimer(ReenableNotifications, self.db.profile.NotifyTimerInterval);

	local msg = format(L["Enemy Detected:|cffff0000"]);
	if (data.level ~= nil) then
		--level can now be a string (eg. 44+)
		if ((tonumber(data.level) or 1) < 1) then
			msg = msg .. " [??]";
		else
			msg = msg .. " [" .. data.level .. "]";
		end
	end

	msg = msg .. " " .. data.name;

	if (data.guild ~= nil) then
		msg = msg .. " <" .. data.guild .. ">";
	end

	msg = msg .. "|r";

	if(self.db.profile.notifyVisual) then
		UIErrorsFrame:AddMessage(msg, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end
	if(self.db.profile.notifyChatframe) then
		VanasKoS:Print(msg);
	end
	if(self.db.profile.notifyFlashingBorder) then
		self:FlashNotify();
	end
	self:PlaySound(self.db.profile.enemyPlayName);
end

function VanasKoSNotifier:KosPlayer_Detected(data)
	assert(data.name ~= nil);

	-- get reasons for kos (if any)
	local pdata = VanasKoS:IsOnList("PLAYERKOS", data.name);
	local gdata = VanasKoS:IsOnList("GUILDKOS", data.guild);

	local msg = self:GetKoSString(data.name, data and data.guild, pdata and pdata.reason, pdata and pdata.creator, pdata and pdata.owner, gdata and gdata.reason, gdata and gdata.creator, gdata and gdata.owner);

	if(self.db.profile.notifyOnlyMyTargets and ((pdata and pdata.owner ~= nil) or (gdata and gdata.owner ~= nil))) then
		return;
	end

	notifyAllowed = false;
	-- Reallow Notifies in NotifyTimeInterval Time
	self:ScheduleTimer(ReenableNotifications, self.db.profile.NotifyTimerInterval);

	if(self.db.profile.notifyVisual) then
		UIErrorsFrame:AddMessage(msg, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end
	if(self.db.profile.notifyChatframe) then
		VanasKoS:Print(msg);
	end
	if(self.db.profile.notifyFlashingBorder) then
		self:FlashNotify();
	end
	
	self:PlaySound(self.db.profile.playName);
end

-- /script VanasKoSNotifier:FlashNotify()
function VanasKoSNotifier:FlashNotify()
	flashNotifyFrame:Show();
	UIFrameFlash(VanasKoS_Notifier_Frame, FADE_IN_TIME, FADE_OUT_TIME, FLASH_TIMES*(FADE_IN_TIME + FADE_OUT_TIME));
end

function VanasKoSNotifier:PlaySound(value)
	local soundFileName = SML:Fetch("sound", value);
	PlaySoundFile(soundFileName);
end
