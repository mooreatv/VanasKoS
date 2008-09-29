--[[----------------------------------------------------------------------
      WarnFrame Module - Part of VanasKoS
Creates the WarnFrame to alert of nearby KoS, Hostile and Friendly
------------------------------------------------------------------------]]

local L = AceLibrary("AceLocale-2.2"):new("VanasKoSWarnFrame");
VanasKoSWarnFrame = VanasKoS:NewModule("WarnFrame");

local VanasKoSWarnFrame = VanasKoSWarnFrame;
local VanasKoS = VanasKoS;

L:RegisterTranslations("enUS", function() return {
	["Content"] = true,
	["What to show in it"] = true,
	["Design"] = true,
	["How the content is shown"] = true,

	["Show Target Level When Possible"] = true,
	["Show KoS Targets"] = true,
	["Show Hostile Targets"] = true,
	["Show Friendly Targets"] = true,

	["Default Background Color"] = true,
	["Sets the default Background Color and Opacity"] = true,

	["More Hostiles than Allied Background Color"] = true,
	["Sets the more Hostiles than Allied Background Color and Opacity"] = true,

	["More Allied than Hostiles Background Color"] = true,
	["Sets the more Allied than Hostiles Background Color and Opacity"] = true,

	["Reset Background Colors"] = true,
	["Resets all Background Colors to default Settings"] = true,
	["Show additional Information on Mouse Over"] = true,
	["Toggles the display of additional Information on Mouse Over"] = true,

	["Configuration"] = true,
	["KoS/Enemy/Friendly Warning Window"] = true,
	["Hide if inactive"] = true,
	["Enabled"] = true,
	["Locked"] = true,
	["Reset Position"] = true,

	["Level"] = true,
	["No Information Available"] = true,

	["Show class icons"] = true,
	["Toggles the display of Class icons in the Warnframe"] = true,
} end );

L:RegisterTranslations("deDE", function() return {
	["Content"] = "Inhalt",
	["What to show in it"] = "Was angezeigt wird",
	["Design"] = "Aussehen",
	["How the content is shown"] = "Aussehen der anzeigten Daten",

	["Show Target Level When Possible"] = "Level von Zielen anzeigen (wenn möglich)",
	["Show KoS Targets"] = "KoS-Ziele anzeigen",
	["Show Hostile Targets"] = "Feindliche Ziele anzeigen",
	["Show Friendly Targets"] = "Freundliche Ziele anzeigen",

	["Default Background Color"] = "Standard Hintergrundfarbe",
	["Sets the default Background Color and Opacity"] = "Setzt die standardmaessige Hintergrundfarbe und Transparenz",

	["More Hostiles than Allied Background Color"] = "Mehr Feinde als Verbuendete Hintergrundfarbe",
	["Sets the more Hostiles than Allied Background Color and Opacity"] = "Setzt die Hintergrundfarbe und Transparenz wenn mehr Feinde als Verbuendete da sind",

	["More Allied than Hostiles Background Color"] = "Mehr Verbuendete als Feinde Hintergrundfarbe",
	["Sets the more Allied than Hostiles Background Color and Opacity"] = "Setzt die Hintergrundfarbe und Transparenz wenn mehr Verbuendete als Feinde da sind",

	["Reset Background Colors"] = "Hintergrundfarben zuruecksetzen",
	["Resets all Background Colors to default Settings"] = "Alle Hintergrundfarben auf ihre Standardwerte zuruecksetzen",

	["Show additional Information on Mouse Over"] = "Zusätzliche Informationen bei Maus überfahrt",
	["Toggles the display of additional Information on Mouse Over"] = "Zusätzliche Informationen beim herüberfahren mit der Maus anzeigen",

	["Configuration"] = "Konfiguration",
	["KoS/Enemy/Friendly Warning Window"] = "KoS/Feind/Freund Warn-Fenster",
	["Hide if inactive"] = "Verstecken wenn inaktiv",
	["Enabled"] = "Aktiviert",
	["Locked"] = "Sperren",
	["Reset Position"] = "Position zurücksetzen",

	["Level"] = "Level",
	["No Information Available"] = "No Information Available",
	["Show class icons"] = "Zeige Klassen Symbole",
	["Toggles the display of Class icons in the Warnframe"] = "Schaltet die Anzeige ob Klassensymbole in dem Warnframe angezeigt werden an/aus",
} end );

L:RegisterTranslations("frFR", function() return {
	["Content"] = "Contenu",
	["What to show in it"] = "Ce que vous voulez afficher",
	["Design"] = "Apparence",
	["How the content is shown"] = "Comment l'apparence est affich\195\169",

	["Show Target Level When Possible"] = "Afficher le level des cibles quand c'est possible",
	["Show KoS Targets"] = "Afficher cibles KoS",
	["Show Hostile Targets"] = "Afficher cibles hostiles",
	["Show Friendly Targets"] = "Afficher cibles amis",

	["Default Background Color"] = "Couleur de fond",
	["Sets the default Background Color and Opacity"] = "Choisir la couleur et l'opacit\195\169",

	["More Hostiles than Allied Background Color"] = "Couleur de fond pour cible hostile",
	["Sets the more Hostiles than Allied Background Color and Opacity"] = "Choisir la couleur de fond pour cible hostile",

	["More Allied than Hostiles Background Color"] = "Couleur de fond pour cible amical",
	["Sets the more Allied than Hostiles Background Color and Opacity"] = "Choisir la couleur de fond pour cible amical",

	["Reset Background Colors"] = "Remettre par d\195\169faut",
	["Resets all Background Colors to default Settings"] = "Remet par d\195\169faut la couleur de fond et l'opacit\195\169",

	["Show additional Information on Mouse Over"] = "Montrer les informations additionnelles",
	["Toggles the display of additional Information on Mouse Over"] = "Afficher/cacher les informations additionnelles quand vous passez la souris sur un nom",

	["Configuration"] = "Configuration",
	["KoS/Enemy/Friendly Warning Window"] = "Fen\195\170tre d'avertissement KoS/Ennemi/Amis",
	["Hide if inactive"] = "Cacher si inactif",
	["Enabled"] = "Actif",
	["Locked"] = "Verrouill\195\169",
	["Reset Position"] = "Remettre à zéro la position",

	["Level"] = "Level",
	["No Information Available"] = "No Information Available",
--	["Show class icons"] = true,
--	["Toggles the display of Class icons in the Warnframe"] = true,

} end );

L:RegisterTranslations("koKR", function() return {
	["Content"] = "내용",
	["What to show in it"] = "표시 내용",
	["Design"] = "디자인",
	["How the content is shown"] = "표시 방법",

	["Show Target Level When Possible"] = "대상의 레벨 표시",
	["Show KoS Targets"] = "KoS 대상 표시",
	["Show Hostile Targets"] = "적대적 대상 표시",
	["Show Friendly Targets"] = "우호적 대상 표시",

	["Default Background Color"] = "기본 배경 색상",
	["Sets the default Background Color and Opacity"] = "기본 배경의 색상과 투명도를 설정합니다.",

	["More Hostiles than Allied Background Color"] = "적대적 배경 색상",
	["Sets the more Hostiles than Allied Background Color and Opacity"] = "적대적 배경 색상과 투명도를 설정합니다.",

	["More Allied than Hostiles Background Color"] = "우호적 배경 색상",
	["Sets the more Allied than Hostiles Background Color and Opacity"] = "우호적 배경 색상과 투명도를 설정합니다.",

	["Reset Background Colors"] = "배경 색상 초기화",
	["Resets all Background Colors to default Settings"] = "모든 배경 색상을 기본 설정으로 초기화합니다.",

	["Show additional Information on Mouse Over"] = "마우스 오버 시 추가 정보 표시",
	["Toggles the display of additional Information on Mouse Over"] = "마우스 오버 시 추가 정보 표시를 전환합니다.",

	["Configuration"] = "환경설정",
	["KoS/Enemy/Friendly Warning Window"] = "KoS/적대적/우호적 알림창",
	["Hide if inactive"] = "사용하지 않으면 숨김",
	["Enabled"] = "사용",
	["Locked"] = "고정",
	["Reset Position"] = "위치 초기화",

	["Level"] = "레벨",
	["No Information Available"] = "이용가능한 정보가 없습니다.",

	["Show class icons"] = "직업 아이콘 표시",
	["Toggles the display of Class icons in the Warnframe"] = "경고창에 직업 아이콘을 표시합니다.",

} end );

L:RegisterTranslations("esES", function() return {
	["Content"] = "Contenido",
	["What to show in it"] = "Qué mostrar en él",
	["Design"] = "Diseño",
	["How the content is shown"] = "Cómo se muestra el contenido",

	["Show Target Level When Possible"] = "Mostrar el nivel del objetivo cuando sea posible",
	["Show KoS Targets"] = "Mostrar objetivos KoS",
	["Show Hostile Targets"] = "Mostrar objetivos hostiles",
	["Show Friendly Targets"] = "Mostrar objetivos amistosos",

	["Default Background Color"] = "Color de fondo por defecto",
	["Sets the default Background Color and Opacity"] = "Establece el color de fondo y la opacidad por defecto",

	["More Hostiles than Allied Background Color"] = "Color de fondo de más hostiles que aliados",
	["Sets the more Hostiles than Allied Background Color and Opacity"] = "Establece el color de fondo y la opacidad de más hostiles que aliados",

	["More Allied than Hostiles Background Color"] = "Color de fondo de más aliados que hostiles",
	["Sets the more Allied than Hostiles Background Color and Opacity"] = "Establece el color de fondo y la opacidad de más aliados que hostiles",

	["Reset Background Colors"] = "Reestablecer Colores de Fondo",
	["Resets all Background Colors to default Settings"] = "Reestablece todos los colores de fondo a los ajustes por defecto",

	["Configuration"] = "Configuración",
	["KoS/Enemy/Friendly Warning Window"] = "Ventana de Aviso de KoS/Enemigo/Amistoso",
	["Hide if inactive"] = "Ocultar si inactivo",
	["Enabled"] = "Activado",
	["Locked"] = "Bloqueado",
	["Reset Position"] = "Reestablecer Posición",

	["Level"] = "Nivel",
--	["Show class icons"] = true,
--	["Toggles the display of Class icons in the Warnframe"] = true,

} end );

L:RegisterTranslations("ruRU", function() return {
	["Content"] = "Содержимое",
	["What to show in it"] = "Что в нем показывать",
	["Design"] = "Дизайн",
	["How the content is shown"] = "Как отображается содержимое",

	["Show Target Level When Possible"] = "Показывать уровень цели когда это возможно",
	["Show KoS Targets"] = "Показывать цели KoS",
	["Show Hostile Targets"] = "Показывать, враждебные цели",
	["Show Friendly Targets"] = "Показывать дружественные цели",

	["Default Background Color"] = "Цвет фона по умолчанию",
	["Sets the default Background Color and Opacity"] = "Задаетцвет фона и прозрачность",

	["More Hostiles than Allied Background Color"] = "Цвет фона для \"Больше враждебных, чем дружественных\"",
	["Sets the more Hostiles than Allied Background Color and Opacity"] = "Задает цвет и прозрачность фона для \"Больше враждебных, чем дружественных\"",

	["More Allied than Hostiles Background Color"] = "Цвет фона для \"Больше дружественных, чем враждебных\"",
	["Sets the more Allied than Hostiles Background Color and Opacity"] = "Задает цвет и прозрачность фона для \"Больше дружественных, чем враждебных\"",

	["Reset Background Colors"] = "Сбросить Цвета Фона",
	["Resets all Background Colors to default Settings"] = "Сбросить все цвета к значениям по умолчанию",
	["Show additional Information on Mouse Over"] = "Показывать дополнительную информацию при наводе мышки",
	["Toggles the display of additional Information on Mouse Over"] = "Вкл-выкл отображение дополнительной информации при наведении мышки",

	["Configuration"] = "Настройка",
	["KoS/Enemy/Friendly Warning Window"] = "Окно предупреждений о KoS/Враге/Друге",
	["Hide if inactive"] = "Скрывать, если не активно",
	["Enabled"] = "Включено",
	["Locked"] = "Зафиксировано",
	["Reset Position"] = "Сбросить расположение",

	["Level"] = "Уровень",
	["No Information Available"] = "Нет доступной информации",

	["Show class icons"] = "Показывать иконки класса",
	["Toggles the display of Class icons in the Warnframe"] = "Показывать или нет классовые иконки в окне предупреждений",
} end );

local dewdrop = AceLibrary("Dewdrop-2.0");

local warnFrame = nil;
local warnButtonsOOC = nil;
local warnButtonsCombat = nil;
local classIcons = nil;
local tooltipFrame = nil;

local nearbyKoS = nil;
local nearbyEnemy = nil;
local nearbyFriendly = nil;
local nearbyKoSCount = 0;
local nearbyEnemyCount = 0;
local nearbyFriendlyCount = 0;

local dataCache = nil;
local buttonData = nil;

local function clear(...)
	for i=1,select('#', ...) do
		local t = select(i, ...)
		if type(t) == 'table' then
			for k in pairs(t) do
				t[k] = nil
			end
		end
	end
end

local function GetColor(which)
	return VanasKoSWarnFrame.db.profile[which .. "R"], VanasKoSWarnFrame.db.profile[which .. "G"], VanasKoSWarnFrame.db.profile[which .. "B"], VanasKoSWarnFrame.db.profile[which .. "A"];
end

local function SetColor(which, r, g, b, a)
	warnFrame:SetBackdropColor(r, g, b, a);

	VanasKoSWarnFrame.db.profile[which .. "R"] = r;
	VanasKoSWarnFrame.db.profile[which .. "G"] = g;
	VanasKoSWarnFrame.db.profile[which .. "B"] = b;
	VanasKoSWarnFrame.db.profile[which .. "A"] = a;
end

local function GetTooltipText(name, data)
	local result = "";
	if (data and data.level ~= nil) then
		result = result .. L["Level"] .. " " .. data.level .. " ";
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

local function ShowTooltip(buttonNr)
	if(not VanasKoSWarnFrame.db.profile.ShowMouseOverInfos) then
		if(tooltipFrame:IsVisible()) then
			tooltipFrame:Hide();
		end
		return;
	end

	local name = buttonData[buttonNr];
	tooltipFrame:SetText(GetTooltipText(name, dataCache[name]));

	tooltipFrame:ClearAllPoints();

	local x, y = GetCursorPosition(); -- gets coordinates based on WorldFrame position
	local scale = UIParent:GetEffectiveScale();

	if(WorldFrame:GetRight() < (x + (tooltipFrame:GetTextWidth()+10)*scale)) then
		tooltipFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", x/scale, y/scale);
	else
		tooltipFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x/scale, y/scale);
	end

	tooltipFrame:SetWidth(tooltipFrame:GetTextWidth()+10);
	tooltipFrame:SetHeight(VanasKoSWarnFrame.db.profile.WARN_TOOLTIP_HEIGHT);

	tooltipFrame:Show();
end

local function CreateWarnFrame()
	if(warnFrame) then
		return;
	end
	-- Create the Main Window
	warnFrame = CreateFrame("Button", "VanasKoS_WarnFrame", UIParent);
	warnFrame:SetWidth(VanasKoSWarnFrame.db.profile.WARN_FRAME_WIDTH);
	warnFrame:SetHeight(VanasKoSWarnFrame.db.profile.WARN_FRAME_HEIGHT);
	warnFrame:SetPoint("CENTER");
	warnFrame:SetToplevel(true);
	warnFrame:SetMovable(true);
	warnFrame:SetFrameStrata("LOW");
	warnFrame:EnableMouse(true);
	warnFrame:SetBackdrop( {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right = 4, top = 5, bottom = 5 }
		});

	-- set the default backdrop color
	local r, g, b, a = GetColor("DefaultBGColor");
	warnFrame:SetBackdropColor(r, g, b, a);

	-- allow dragging or the window
	warnFrame:RegisterForDrag("LeftButton");
	warnFrame:SetScript("OnDragStart",
							function()
								if(VanasKoSWarnFrame.db.profile.Locked) then
									return;
								end
								warnFrame:StartMoving();
							end);
	warnFrame:SetScript("OnDragStop",
							function()
								warnFrame:StopMovingOrSizing();
							end);
	warnFrame:Hide();
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
	tooltipFrame:SetTextFontObject(GameFontNormal);
	tooltipFrame:SetTextColor(1.0, 1.0, 1.0);

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
}

local function CreateClassIcons()
	if(classIcons) then
		return;
	end

	classIcons = { };
	local i = 1;
	for i=1,VanasKoSWarnFrame.db.profile.WARN_BUTTONS do
		local classIcon = CreateFrame("Button", nil, warnFrame);
		classIcon:SetPoint("LEFT", warnButtonsCombat[i], "LEFT", 5, 0);
		classIcon:SetWidth(15);
		classIcon:SetHeight(15);

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
--		classIcons[iconNr][2]:Hide();
		return;
	end

	local coords = classIconNameToCoords[class];
	if(not coords) then
		VanasKoS:Print("Unknown class " .. class);
		return;
	end
--	classIcons[iconNr][2]:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
	classIcons[iconNr][2]:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
	classIcons[iconNr][1]:Show();
--	classIcons[iconNr][2]:Show();
end

local function CreateOOCButtons()
	if(warnButtonsOOC) then
		return;
	end
	warnButtonsOOC = { };
	local i=1;
	for i=1,VanasKoSWarnFrame.db.profile.WARN_BUTTONS do
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
		warnButton:RegisterForClicks("LeftButtonUp");
		warnButton:SetAttribute("type1", "macro");
		warnButton:SetAttribute("macrotext", "/wave");
		warnButton:SetTextFontObject(GameFontNormal);

		warnButton:SetScript("OnEnter", function()
											ShowTooltip(i);
										end);
		warnButton:SetScript("OnLeave", function()
											tooltipFrame:Hide();
										end);
		warnButton:Show();

		warnButtonsOOC[i] = warnButton;
	end
end

local function CreateCombatButtons()
	if(warnButtonsCombat) then
		return;
	end
	warnButtonsCombat = { };

	local i = 0;
	for i=1,VanasKoSWarnFrame.db.profile.WARN_BUTTONS do
		local warnButton = CreateFrame("Button", nil, warnFrame);
		-- same size as OOC buttons
		warnButton:SetAllPoints(warnButtonsOOC[i]);
		warnButton:EnableMouse(true);
		warnButton:SetTextFontObject(GameFontNormalSmall);
		warnButton:RegisterForClicks("LeftButtonUp");
		warnButton:SetFrameStrata("HIGH");

		warnButton:SetScript("OnEnter", function()
											ShowTooltip(i);
										end);
		warnButton:SetScript("OnLeave", function()
											tooltipFrame:Hide();
										end);

		warnButton:Hide();

		warnButtonsCombat[i] = warnButton;
	end
end


local dewdrop = AceLibrary("Dewdrop-2.0");

local function RegisterConfiguration()
	local configOptions = {
		type = 'group',
		name = L["Configuration"],
		desc = L["Configuration"],
		args = {
			title = {
				type = 'header',
				name = L["Configuration"],
				order = 1,
			},
			content = {
				type = 'group',
				name = L["Content"],
				desc = L["What to show in it"],
				order = 2,
				args = {
					showLevel = {
						type = 'toggle',
						name = L["Show Target Level When Possible"],
						desc = L["Show Target Level When Possible"],
						order = 1,
						get = function() return VanasKoSWarnFrame.db.profile.ShowTargetLevel; end,
						set = function(v) VanasKoSWarnFrame.db.profile.ShowTargetLevel = v; VanasKoSWarnFrame:Update(); end
					},
					showKoS = {
						type = 'toggle',
						name = L["Show KoS Targets"],
						desc = L["Show KoS Targets"],
						order = 2,
						get = function() return VanasKoSWarnFrame.db.profile.ShowKoS; end,
						set = function(v) VanasKoSWarnFrame.db.profile.ShowKoS = v; VanasKoSWarnFrame:Update(); end
					},
					showHostile = {
						type = 'toggle',
						name = L["Show Hostile Targets"],
						desc = L["Show Hostile Targets"],
						order = 3,
						get = function() return VanasKoSWarnFrame.db.profile.ShowHostile; end,
						set = function(v) VanasKoSWarnFrame.db.profile.ShowHostile = v; VanasKoSWarnFrame:Update(); end
					},
					showFriendly = {
						type = 'toggle',
						name = L["Show Friendly Targets"],
						desc = L["Show Friendly Targets"],
						order = 4,
						get = function() return VanasKoSWarnFrame.db.profile.ShowFriendly; end,
						set = function(v) VanasKoSWarnFrame.db.profile.ShowFriendly = v; VanasKoSWarnFrame:Update(); end
					},
					showMouseOverInfos = {
						type = 'toggle',
						name = L["Show additional Information on Mouse Over"],
						desc = L["Toggles the display of additional Information on Mouse Over"],
						order = 5,
						get = function() return VanasKoSWarnFrame.db.profile.ShowMouseOverInfos; end,
						set = function(v) VanasKoSWarnFrame.db.profile.ShowMouseOverInfos = v; VanasKoSWarnFrame:Update(); end
					},
					showClassIcons = {
						type = 'toggle',
						name = L["Show class icons"],
						desc = L["Toggles the display of Class icons in the Warnframe"],
						order = 6,
						get = function() return VanasKoSWarnFrame.db.profile.ShowClassIcons; end,
						set = function(v)
								VanasKoSWarnFrame.db.profile.ShowClassIcons = v;
								VanasKoSWarnFrame:Update();
								for i=1,VanasKoSWarnFrame.db.profile.WARN_BUTTONS do
									setButtonClassIcon(i, nil);
								end
							end
					},
				}
			},
			design = {
				type = 'group',
				name = L["Design"],
				desc = L["How the content is shown"],
				order = 3,
				args = {
					defaultBackdropBackgroundColor = {
						type = 'color',
						name = L["Default Background Color"],
						desc = L["Sets the default Background Color and Opacity"],
						order = 1,
						get = function() return GetColor("DefaultBGColor") end,
						set = function(r, g, b, a) SetColor("DefaultBGColor", r, g, b, a); end,
						hasAlpha = true,
					},
					moreHostilesBackdropBackgroundColor = {
						type = 'color',
						name = L["More Hostiles than Allied Background Color"],
						desc = L["Sets the more Hostiles than Allied Background Color and Opacity"],
						order = 2,
						get = function() return GetColor("MoreHostileBGColor"); end,
						set = function(r, g, b, a) SetColor("MoreHostileBGColor", r, g, b, a); end,
						hasAlpha = true
					},
					moreAlliedBackdropBackgroundColor = {
						type = 'color',
						name = L["More Allied than Hostiles Background Color"],
						desc = L["Sets the more Allied than Hostiles Background Color and Opacity"],
						order = 3,
						get = function() return GetColor("MoreAlliedBGColor"); end,
						set = function(r, g, b, a) SetColor("MoreAlliedBGColor", r, g, b, a); end,
						hasAlpha = true
					},
					resetBackgroundColors = {
						type = 'execute',
						name = L["Reset Background Colors"],
						desc = L["Resets all Background Colors to default Settings"],
						order = 4,
						func = function()
									SetColor("MoreHostileBGColor", 1.0, 0.0, 0.0, 0.5);
									SetColor("MoreAlliedBGColor", 0.0, 1.0, 0.0, 0.5);
									SetColor("DefaultBGColor", 0.5, 0.5, 1.0, 0.5);
								end,
					},
				}
			},
			enabled = {
				type = 'toggle',
				name = L["Enabled"],
				desc = L["Enabled"],
				order = 4,
				set = function(v) VanasKoSWarnFrame.db.profile.Enabled = v; VanasKoS:ToggleModuleActive("WarnFrame", VanasKoSWarnFrame.db.profile.Enabled); VanasKoSWarnFrame:Update(); end,
				get = function() return VanasKoSWarnFrame.db.profile.Enabled; end,
			},
			locked = {
				type = 'toggle',
				name = L["Locked"],
				desc = L["Locked"],
				order = 5,
				set = function(v) VanasKoSWarnFrame.db.profile.Locked = v; end,
				get = function() return VanasKoSWarnFrame.db.profile.Locked; end,
			},
			hideifinactive = {
				type = 'toggle',
				name = L["Hide if inactive"],
				desc = L["Hide if inactive"],
				order = 6,
				set = function(v) VanasKoSWarnFrame.db.profile.HideIfInactive = v; VanasKoSWarnFrame:Update(); end,
				get = function() return VanasKoSWarnFrame.db.profile.HideIfInactive; end,
			},
			reset = {
				type = 'execute',
				name = L["Reset Position"],
				desc= L["Reset Position"],
				order = 7,
				func = function() VanasKoS_WarnFrame:ClearAllPoints(); VanasKoS_WarnFrame:SetPoint("CENTER"); end,
			}

		}
	}
	dewdrop:Register(warnFrame,
				'children', configOptions
				);

	VanasKoSGUI:AddConfigOption("WarnFrame", {
		type = 'group',
		name = L["KoS/Enemy/Friendly Warning Window"],
		desc = L["KoS/Enemy/Friendly Warning Window"],
		args = {
			enabled = {
				type = 'toggle',
				name = L["Enabled"],
				desc = L["Enabled"],
				order = 1,
				set = function(v) VanasKoSWarnFrame.db.profile.Enabled = v; VanasKoS:ToggleModuleActive("WarnFrame", VanasKoSWarnFrame.db.profile.Enabled); end,
				get = function() return VanasKoSWarnFrame.db.profile.Enabled; end,
			},
			locked = {
				type = 'toggle',
				name = L["Locked"],
				desc = L["Locked"],
				order = 2,
				set = function(v) VanasKoSWarnFrame.db.profile.Locked = v; end,
				get = function() return VanasKoSWarnFrame.db.profile.Locked; end,
			},
			hideifinactive = {
				type = 'toggle',
				name = L["Hide if inactive"],
				desc = L["Hide if inactive"],
				order = 3,
				set = function(v) VanasKoSWarnFrame.db.profile.HideIfInactive = v; VanasKoSWarnFrame:Update(); end,
				get = function() return VanasKoSWarnFrame.db.profile.HideIfInactive; end,
			},
			reset = {
				type = 'execute',
				name = L["Reset Position"],
				desc= L["Reset Position"],
				func = function() VanasKoS_WarnFrame:ClearAllPoints(); VanasKoS_WarnFrame:SetPoint("CENTER"); end,
			}
		}
	});

end

function VanasKoSWarnFrame:OnInitialize()
	VanasKoS:RegisterDefaults("WarnFrame", "profile", {
		Enabled = true,
		HideIfInactive = false,
		Locked = false,

		ShowTargetLevel = true,
		ShowKoS = true,
		ShowHostile = true,
		ShowFriendly = true,
		ShowMouseOverInfos = true,
		ShowClassIcons = true,

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

		WARN_FRAME_WIDTH = 130;
		WARN_FRAME_HEIGHT = 91;

		WARN_TOOLTIP_HEIGHT = 24;

		WARN_BUTTON_HEIGHT = 16;
		WARN_BUTTONS = 5;
	});

	self.db = VanasKoS:AcquireDBNamespace("WarnFrame");

	CreateWarnFrame();
end

function VanasKoSWarnFrame:OnEnable()
	--CreateWarnFrame();
	CreateOOCButtons();
	CreateCombatButtons();
	CreateTooltipFrame();
	CreateClassIcons();

	RegisterConfiguration();

	self:RegisterEvent("VanasKoS_Player_Detected", "Player_Detected");

	nearbyKoS = { };
	nearbyEnemy = { };
	nearbyFriendly = { };
	dataCache = { };
	buttonData = { };

	warnFrame:SetAlpha(1);
	self:Update();
end

function VanasKoSWarnFrame:OnDisable()
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
	nearbyKoS = { };
	nearbyEnemy = { };
	nearbyFriendly = { };
	dataCache = { };
	buttonData = { };

	self:Update();
	warnFrame:Hide();
end

local function RemovePlayer(faction, name)
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
		local x = dataCache[name];
		clear(x);
		dataCache[name] = nil;
	end

	VanasKoSWarnFrame:Update();
end

-- /Script VanasKoSWarnFrame:Player_Detected("xxx", nil, "enemy"); VanasKoSWarnFrame:Player_Detected("xxx2", nil, "enemy");
-- /script local x = {  ['name'] = 'x', ['faction'] = 'enemy', ['class'] = 'Poser',  ['race'] = 'GM', ['level'] = "31336"} ; for i=1,10000 do x.name = "xxx" .. math.random(1, 1000); VanasKoSWarnFrame:Player_Detected(x); end
local UNKNOWNLOWERCASE = UNKNOWN:lower();

function VanasKoSWarnFrame:Player_Detected(data)
	assert(data.name ~= nil);

	local name = data.name:trim():lower();
	local faction = data.faction;

	-- exclude unknown entitity entries
	if(name == UNKNOWNLOWERCASE) then
		return;
	end

	if(faction == "kos" and self.db.profile.ShowKoS) then
		if(not nearbyKoS[name]) then
			nearbyKoS[name] = true;
			nearbyKoSCount = nearbyKoSCount + 1;
		end
	elseif(faction == "enemy" and self.db.profile.ShowHostile) then
		if(not nearbyEnemy[name]) then
			nearbyEnemy[name] = true;
			nearbyEnemyCount = nearbyEnemyCount + 1;
		end
	elseif(faction == "friendly" and self.db.profile.ShowFriendly) then
		if(not nearbyFriendly[name]) then
			nearbyFriendly[name] = true;
			nearbyFriendlyCount = nearbyFriendlyCount + 1;
		end
	else
		return;
	end

	if(data.level and not dataCache[name]) then
		dataCache[name] = { };
		dataCache[name]['level'] = data.level;
		dataCache[name]['class'] = data.class;
		dataCache[name]['classEnglish'] = data.classEnglish;
		dataCache[name]['race'] = data.race;
		dataCache[name]['faction'] = faction;
	end

--	self:CancelScheduledEvent("VanasKoSWarnFrameRemovePlayer_" .. name, RemovePlayer, faction, name);
	if(faction == "kos") then
		self:ScheduleEvent("VanasKoSWarnFrameRemovePlayer_" .. name, RemovePlayer, 60, faction, name);
	else
		self:ScheduleEvent("VanasKoSWarnFrameRemovePlayer_" .. name, RemovePlayer, 10, faction, name);
	end

	self:Update();
end

local function GetButtonText(name, data)
	local result = name;
	-- Create a cache entry.
	if(VanasKoSWarnFrame.db.profile.ShowTargetLevel) then
		local level = nil;

		-- If there is a player level coming in, record it.
		if (data ~= nil and data.level ~= nil and data.level ~= "") then
			level = data.level;
			if (tonumber(level) == -1) then
				level = "??";
			end
		end

		-- If we have a level, append it.
		if (level ~= nil) then
			result = result .. " [" .. tostring(level) .. "]";
		end

		-- TODO: lookup in last seen list
	end

	return result;
end

local function GetFactionColor(faction)
	if(faction == "kos") then
		return 1, 0, 1, 1;
	elseif(faction == "enemy") then
		return 1, 0, 0, 1;
	elseif(faction == "friendly") then
		return 0, 1, 0, 1;
	end

	return 1, 1, 1, 1;
end

local function SetButton(buttonNr, name, data, faction)
	if(InCombatLockdown()) then
		warnFrame:SetBackdropBorderColor(1.0, 0.0, 0.0);
		if(buttonData[buttonNr] ~= name) then
			-- new data for the button, we have to do something
			if(warnButtonsOOC[buttonNr]:GetAlpha() > 0) then
				-- ooc button visible
				warnButtonsOOC[buttonNr]:SetAlpha(0);
			end

			local r,g,b,a = GetFactionColor(faction);
			warnButtonsCombat[buttonNr]:SetTextColor(r, g, b, a);
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
			local r,g,b,a = GetFactionColor(faction);
			warnButtonsOOC[buttonNr]:SetTextColor(r, g, b, a);
			warnButtonsOOC[buttonNr]:SetText(GetButtonText(name, data));
			warnButtonsOOC[buttonNr]:EnableMouse(true);
			warnButtonsOOC[buttonNr]:SetAttribute("macrotext", "/target " .. name);
			warnButtonsOOC[buttonNr]:Show();
		else
			warnButtonsOOC[buttonNr]:SetText(GetButtonText(name, data));
		end
	end

	buttonData[buttonNr] = name;
end

local function HideButton(buttonNr)
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

	buttonData[buttonNr] = nil;
end

local function HideWarnFrame()
	warnFrame:Hide();
end

function VanasKoSWarnFrame:Update()
	-- +1, because it doesn't count you
	-- more hostile
	if( (nearbyKoSCount+nearbyEnemyCount) > (nearbyFriendlyCount+1)) then
		local r, g, b, a = GetColor("MoreHostileBGColor");
		warnFrame:SetBackdropColor(r, g, b, a);
	end
	-- more allied
	if( (nearbyKoSCount+nearbyEnemyCount) < (nearbyFriendlyCount+1)) then
		local r, g, b, a = GetColor("MoreAlliedBGColor");
		warnFrame:SetBackdropColor(r, g, b, a);
	end
	-- default
	if( ((nearbyKoSCount+nearbyEnemyCount) == 0) or ((nearbyKoSCount+nearbyEnemyCount) == (nearbyFriendlyCount+1)) ) then
		local r, g, b, a = GetColor("DefaultBGColor");
		warnFrame:SetBackdropColor(r, g, b, a);
	end

	local counter = 0;

	if(self.db.profile.ShowKoS) then
		for k,v in pairs(nearbyKoS) do
			if(counter < 5) then
				SetButton(counter+1, k, dataCache and dataCache[k] or nil, "kos");
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache and dataCache[k] and dataCache[k].classEnglish);
				end
			end

			counter = counter + 1;
		end
	end

	if(self.db.profile.ShowHostile) then
		for k,v in pairs(nearbyEnemy) do
			if(counter < 5) then
				SetButton(counter+1, k, dataCache and dataCache[k] or nil, "enemy");
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache and dataCache[k] and dataCache[k].classEnglish);
				end
			end

			counter = counter + 1;
		end
	end

	if(self.db.profile.ShowFriendly) then
		for k,v in pairs(nearbyFriendly) do
			if(counter < 5) then
				SetButton(counter+1, k, dataCache and dataCache[k] or nil, "friendly");
				if(self.db.profile.ShowClassIcons) then
					setButtonClassIcon(counter + 1, dataCache and dataCache[k] and dataCache[k].classEnglish);
				end
			end

			counter = counter + 1;
		end
	end

	local i=counter;
	for i=counter,self.db.profile.WARN_BUTTONS-1 do
		HideButton(i+1);
		if(self.db.profile.ShowClassIcons) then
			setButtonClassIcon(i + 1, nil);
		end
	end

	-- show or hide/fade frame according to settings
	if(self.db.profile.Enabled) then
		if(self.db.profile.HideIfInactive) then
			if(counter > 0) then
				if(not warnFrame:IsVisible()) then
					UIFrameFadeIn(warnFrame, 0.1, 0.0, 1.0);
					warnFrame:Show();
				end
			else
				if(warnFrame:IsVisible()) then
					UIFrameFadeOut(warnFrame, 0.1, 1.0, 0.0);
					warnFrame.fadeInfo.finishedFunc = HideWarnFrame;
				end
			end
		else
			if(not warnFrame:IsVisible()) then
				UIFrameFadeIn(warnFrame, 0.1, 0.0, 1.0);
				warnFrame:Show();
			end
		end
	else
		warnFrame:Hide();
	end
end
