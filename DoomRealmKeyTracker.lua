-- Doom Realm Key Tracker
local addonName, addon = ...

-- Default Settings
local defaultDB = {
    hideFrame = false,
    hideMinimapButton = false,
    minimapPos = 45,
    width = 220,
    height = 220,
    fontSize = 12,
    fontPath = "Fonts\\FRIZQT__.TTF",
    colors = {
        title = { r = 1, g = 0.82, b = 0 },
        itemNameDefault = { r = 1, g = 1, b = 1 },
        countHas = { r = 0, g = 1, b = 0 },
        countZero = { r = 0.5, g = 0.5, b = 0.5 },
        items = {
            [1] = { r = 1, g = 1, b = 1 },
            [2] = { r = 1, g = 1, b = 1 },
            [3] = { r = 1, g = 1, b = 1 },
            [4] = { r = 1, g = 1, b = 1 },
            [5] = { r = 1, g = 1, b = 1 },
            [6] = { r = 1, g = 1, b = 1 },
            [7] = { r = 1, g = 1, b = 1 },
            [8] = { r = 1, g = 1, b = 1 },
        }
    },
    items = {
        801015, -- Item 1
        801014, -- Item 2
        801018, -- Item 3
        801017, -- Item 4
        801016, -- Item 5
        801019, -- Item 6
        801020, -- Item 7
        801012, -- Item 8
    }
}

DoomRealmKeyTrackerDB = DoomRealmKeyTrackerDB or {}

-- Forward declaration for Options Panel
local optionsPanel

-- Function to Open Settings
local function OpenSettingsMenu()
    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- Called twice due to default WoW UI category focus bug
    end
end

----------------------------------------------------
-- Main Display Frame Setup
----------------------------------------------------
local mainFrame = CreateFrame("Button", "DoomRealmKeyTrackerFrame", UIParent)
mainFrame:SetSize(defaultDB.width, defaultDB.height)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:SetClampedToScreen(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:RegisterForClicks("RightButtonUp")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)

-- Right-Click Main Frame to Open Options
mainFrame:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        OpenSettingsMenu()
    end
end)

local titleText = mainFrame:CreateFontString(nil, "OVERLAY")
titleText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
titleText:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 10, -5)
titleText:SetText("Doom Realm Keys")

mainFrame:SetResizable(true)
if mainFrame.SetMinResize then
    mainFrame:SetMinResize(160, 160)
    mainFrame:SetMaxResize(500, 600)
end

local resizeButton = CreateFrame("Button", nil, mainFrame)
resizeButton:SetSize(16, 16)
resizeButton:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2, 2)
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

resizeButton:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        mainFrame:StartSizing("BOTTOMRIGHT")
    end
end)
resizeButton:SetScript("OnMouseUp", function(self)
    mainFrame:StopMovingOrSizing()
    DoomRealmKeyTrackerDB.width = mainFrame:GetWidth()
    DoomRealmKeyTrackerDB.height = mainFrame:GetHeight()
end)

----------------------------------------------------
-- Item Rows
----------------------------------------------------
local itemRows = {}

local function CreateItemRow(index)
    local row = CreateFrame("Frame", nil, mainFrame)
    row:SetHeight(24)
    row:SetPoint("LEFT", mainFrame, "LEFT", 10, 0)
    row:SetPoint("RIGHT", mainFrame, "RIGHT", -10, 0)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", row, "LEFT", 0, 0)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    local nameText = row:CreateFontString(nil, "OVERLAY")
    nameText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    nameText:SetPoint("RIGHT", row, "RIGHT", -40, 0)
    nameText:SetJustifyH("LEFT")

    local countText = row:CreateFontString(nil, "OVERLAY")
    countText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    countText:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    countText:SetJustifyH("RIGHT")

    row.icon = icon
    row.nameText = nameText
    row.countText = countText

    return row
end

for i = 1, 8 do
    itemRows[i] = CreateItemRow(i)
end

----------------------------------------------------
-- Visual Styling & Update Logic
----------------------------------------------------
local function ApplyFontAndColors()
    local fontPath = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.fontPath) or defaultDB.fontPath
    local fontSize = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.fontSize) or defaultDB.fontSize
    local colors = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.colors) or defaultDB.colors

    -- Title Font & Color
    titleText:SetFont(fontPath, fontSize + 2, "OUTLINE")
    local tC = colors.title or defaultDB.colors.title
    titleText:SetTextColor(tC.r, tC.g, tC.b)

    -- Item Rows
    local rowHeight = math.max(20, fontSize + 8)
    for i = 1, 8 do
        local row = itemRows[i]
        row:SetHeight(rowHeight)
        row:SetPoint("TOP", mainFrame, "TOP", 0, -(fontSize + 12) - ((i - 1) * (rowHeight + 2)))
        row.icon:SetSize(fontSize + 6, fontSize + 6)

        row.nameText:SetFont(fontPath, fontSize, "OUTLINE")
        row.countText:SetFont(fontPath, fontSize, "OUTLINE")

        local itemColor = (colors.items and colors.items[i]) or colors.itemNameDefault or defaultDB.colors.itemNameDefault
        row.nameText:SetTextColor(itemColor.r, itemColor.g, itemColor.b)
    end
end

local function UpdateItemCounts()
    ApplyFontAndColors()

    local colors = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.colors) or defaultDB.colors
    local cHas = colors.countHas or defaultDB.colors.countHas
    local cZero = colors.countZero or defaultDB.colors.countZero
    local itemsList = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.items) or defaultDB.items

    for i = 1, 8 do
        local itemID = itemsList[i]
        local row = itemRows[i]

        if itemID then
            local count = GetItemCount(itemID, true)
            row.countText:SetText(count)
            if count > 0 then
                row.countText:SetTextColor(cHas.r, cHas.g, cHas.b)
            else
                row.countText:SetTextColor(cZero.r, cZero.g, cZero.b)
            end

            local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
            if itemName then
                row.nameText:SetText(itemName)
                row.icon:SetTexture(itemTexture)
            else
                row.nameText:SetText("Item #" .. itemID)
                local item = Item:CreateFromItemID(itemID)
                item:ContinueOnItemLoad(function()
                    row.nameText:SetText(item:GetItemName())
                    row.icon:SetTexture(item:GetItemIcon())
                end)
            end
            row:Show()
        else
            row:Hide()
        end
    end
end

----------------------------------------------------
-- Minimap Button
----------------------------------------------------
local minimapButton = CreateFrame("Button", "DoomRealmKeyTrackerMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 10)

local mmIcon = minimapButton:CreateTexture(nil, "BACKGROUND")
mmIcon:SetSize(20, 20)
mmIcon:SetTexture("Interface\\Icons\\INV_Misc_Key_03")
mmIcon:SetPoint("CENTER")

local mmBorder = minimapButton:CreateTexture(nil, "OVERLAY")
mmBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
mmBorder:SetSize(52, 52)
mmBorder:SetPoint("TOPLEFT")

local function UpdateMinimapButtonPosition()
    local pos = (DoomRealmKeyTrackerDB and DoomRealmKeyTrackerDB.minimapPos) or 45
    local angle = math.rad(pos)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local xpos, ypos = GetCursorPosition()
        local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
        local scale = Minimap:GetEffectiveScale()
        local x = (xpos / scale) - xmin - 70
        local y = (ypos / scale) - ymin - 70
        DoomRealmKeyTrackerDB.minimapPos = math.deg(math.atan2(y, x))
        UpdateMinimapButtonPosition()
    end)
end)

minimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

minimapButton:SetScript("OnClick", function(self, button)
    if IsShiftKeyDown() then
        OpenSettingsMenu()
    else
        DoomRealmKeyTrackerDB.hideFrame = not DoomRealmKeyTrackerDB.hideFrame
        mainFrame:SetShown(not DoomRealmKeyTrackerDB.hideFrame)
    end
end)

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Doom Realm Key Tracker")
    GameTooltip:AddLine("Left-Click: Toggle Frame", 1, 1, 1)
    GameTooltip:AddLine("Shift + Left-Click: Open Options", 1, 1, 1)
    GameTooltip:AddLine("Drag: Move Minimap Button", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

----------------------------------------------------
-- Color Picker Helper
----------------------------------------------------
local function OpenColorPicker(colorTable, callback)
    ColorPickerFrame:SetColorRGB(colorTable.r, colorTable.g, colorTable.b)
    ColorPickerFrame.hasOpacity = false
    ColorPickerFrame.previousValues = { colorTable.r, colorTable.g, colorTable.b }
    ColorPickerFrame.func = function()
        colorTable.r, colorTable.g, colorTable.b = ColorPickerFrame:GetColorRGB()
        if callback then callback() end
    end
    ColorPickerFrame.cancelFunc = function(prev)
        colorTable.r, colorTable.g, colorTable.b = prev[1], prev[2], prev[3]
        if callback then callback() end
    end
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
end

----------------------------------------------------
-- Interface Options Menu Setup
----------------------------------------------------
optionsPanel = CreateFrame("Frame", "DoomRealmKeyTrackerOptions", UIParent)
optionsPanel.name = "Doom Realm Key Tracker"

local scrollFrame = CreateFrame("ScrollFrame", nil, optionsPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(580, 850)
scrollFrame:SetScrollChild(content)

local optTitle = content:CreateFontString(nil, "ARTWORK")
optTitle:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
optTitle:SetPoint("TOPLEFT", 10, -10)
optTitle:SetText("Doom Realm Key Tracker Options")

local cbHideFrame = CreateFrame("CheckButton", nil, content, "InterfaceOptionsCheckButtonTemplate")
cbHideFrame:SetPoint("TOPLEFT", optTitle, "BOTTOMLEFT", 0, -15)
cbHideFrame.Text:SetText("Hide Main Tracker Frame")
cbHideFrame:SetScript("OnClick", function(self)
    DoomRealmKeyTrackerDB.hideFrame = self:GetChecked()
    mainFrame:SetShown(not DoomRealmKeyTrackerDB.hideFrame)
end)

local cbHideMinimap = CreateFrame("CheckButton", nil, content, "InterfaceOptionsCheckButtonTemplate")
cbHideMinimap:SetPoint("TOPLEFT", cbHideFrame, "BOTTOMLEFT", 0, -5)
cbHideMinimap.Text:SetText("Hide Minimap Button")
cbHideMinimap:SetScript("OnClick", function(self)
    DoomRealmKeyTrackerDB.hideMinimapButton = self:GetChecked()
    minimapButton:SetShown(not DoomRealmKeyTrackerDB.hideMinimapButton)
end)

local fontSlider = CreateFrame("Slider", "DRKTFontSizeSlider", content, "OptionsSliderTemplate")
fontSlider:SetPoint("TOPLEFT", cbHideMinimap, "BOTTOMLEFT", 10, -30)
fontSlider:SetMinMaxValues(8, 24)
fontSlider:SetValueStep(1)
fontSlider:SetObeyStepOnDrag(true)
_G[fontSlider:GetName() .. 'Low']:SetText('8')
_G[fontSlider:GetName() .. 'High']:SetText('24')
_G[fontSlider:GetName() .. 'Text']:SetText("Text Size")

fontSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value)
    DoomRealmKeyTrackerDB.fontSize = value
    _G[self:GetName() .. 'Text']:SetText("Text Size: " .. value)
    UpdateItemCounts()
end)

----------------------------------------------------
-- Color Options Section
----------------------------------------------------
local colorsHeader = content:CreateFontString(nil, "ARTWORK")
colorsHeader:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
colorsHeader:SetPoint("TOPLEFT", fontSlider, "BOTTOMLEFT", -10, -25)
colorsHeader:SetText("Global Text Colors")

local function CreateColorButton(parent, labelText, getColorFunc, pointFrame, offsetX, offsetY)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(140, 22)
    btn:SetPoint("TOPLEFT", pointFrame, "BOTTOMLEFT", offsetX, offsetY)
    btn:SetText(labelText)
    btn:SetScript("OnClick", function()
        OpenColorPicker(getColorFunc(), function()
            UpdateItemCounts()
        end)
    end)
    return btn
end

local btnTitleColor = CreateColorButton(content, "Header Color", function() return DoomRealmKeyTrackerDB.colors.title end, colorsHeader, 0, -10)
local btnCountHasColor = CreateColorButton(content, "Count (> 0) Color", function() return DoomRealmKeyTrackerDB.colors.countHas end, btnTitleColor, 0, -5)
local btnCountZeroColor = CreateColorButton(content, "Count (= 0) Color", function() return DoomRealmKeyTrackerDB.colors.countZero end, btnCountHasColor, 0, -5)

local itemColorsHeader = content:CreateFontString(nil, "ARTWORK")
itemColorsHeader:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
itemColorsHeader:SetPoint("TOPLEFT", btnCountZeroColor, "BOTTOMLEFT", 0, -20)
itemColorsHeader:SetText("Item Name Colors (Items 1-8)")

local lastButton = itemColorsHeader
for i = 1, 8 do
    local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    btn:SetSize(160, 22)
    btn:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, (i == 1 and -10 or -5))
    btn:SetText("Item " .. i .. " Color")
    btn:SetScript("OnClick", function()
        OpenColorPicker(DoomRealmKeyTrackerDB.colors.items[i], function()
            UpdateItemCounts()
        end)
    end)
    lastButton = btn
end

----------------------------------------------------
-- Custom Scrollable Font Dropdown (Placed Below Item Colors)
----------------------------------------------------
local fontDropdownLabel = content:CreateFontString(nil, "ARTWORK")
fontDropdownLabel:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
fontDropdownLabel:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -25)
fontDropdownLabel:SetText("Select Font:")

-- Main Dropdown Toggle Button
local fontButton = CreateFrame("Button", "DRKTFontSelectorButton", content, "UIPanelButtonTemplate")
fontButton:SetSize(220, 24)
fontButton:SetPoint("TOPLEFT", fontDropdownLabel, "BOTTOMLEFT", 0, -8)
fontButton:SetText("Select Font...")

-- Scrollable Dropdown Menu Container Frame
local fontMenuFrame = CreateFrame("Frame", "DRKTFontMenuContainer", content, "BackdropTemplate")
fontMenuFrame:SetSize(240, 180)
fontMenuFrame:SetPoint("TOPLEFT", fontButton, "BOTTOMLEFT", 0, -2)
fontMenuFrame:SetFrameStrata("DIALOG")
fontMenuFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
fontMenuFrame:Hide()

local fontScrollFrame = CreateFrame("ScrollFrame", nil, fontMenuFrame, "UIPanelScrollFrameTemplate")
fontScrollFrame:SetPoint("TOPLEFT", 8, -8)
fontScrollFrame:SetPoint("BOTTOMRIGHT", -26, 8)

local fontScrollContent = CreateFrame("Frame", nil, fontScrollFrame)
fontScrollContent:SetSize(200, 1)
fontScrollFrame:SetScrollChild(fontScrollContent)

local function GetAvailableFonts()
    local fonts = {}
    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)

    if LSM then
        for _, fontName in ipairs(LSM:List("font")) do
            table.insert(fonts, { text = fontName, value = LSM:Fetch("font", fontName) })
        end
    else
        fonts = {
            { text = "Friz Quadrata (Standard)", value = "Fonts\\FRIZQT__.TTF" },
            { text = "Arial Narrow", value = "Fonts\\ARIALN.TTF" },
            { text = "Skurri", value = "Fonts\\SKURRI.TTF" },
            { text = "Morpheus", value = "Fonts\\MORPHEUS.TTF" },
            { text = "2002", value = "Fonts\\2002.TTF" },
            { text = "2002B", value = "Fonts\\2002B.TTF" },
            { text = "FRIQT__CYR", value = "Fonts\\FRIQT__CYR.TTF" },
        }
    end
    return fonts
end

local fontButtonsList = {}

local function PopulateFontScrollMenu()
    local availableFonts = GetAvailableFonts()
    local itemHeight = 20
    fontScrollContent:SetHeight(#availableFonts * itemHeight)

    for i, fontData in ipairs(availableFonts) do
        local btn = fontButtonsList[i]
        if not btn then
            btn = CreateFrame("Button", nil, fontScrollContent)
            btn:SetHeight(itemHeight)
            btn:SetPoint("LEFT", 0, 0)
            btn:SetPoint("RIGHT", 0, 0)

            local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
            highlight:SetAllPoints()
            highlight:SetColorTexture(1, 1, 1, 0.2)

            local text = btn:CreateFontString(nil, "OVERLAY")
            text:SetPoint("LEFT", 5, 0)
            text:SetPoint("RIGHT", -5, 0)
            text:SetJustifyH("LEFT")
            btn.text = text

            fontButtonsList[i] = btn
        end

        btn:SetPoint("TOPLEFT", fontScrollContent, "TOPLEFT", 0, -((i - 1) * itemHeight))
        btn.text:SetFont(fontData.value, 11, "NONE")
        btn.text:SetText(fontData.text)

        btn:SetScript("OnClick", function()
            DoomRealmKeyTrackerDB.fontPath = fontData.value
            fontButton:SetText(fontData.text)
            fontMenuFrame:Hide()
            UpdateItemCounts()
        end)

        btn:Show()
    end
end

fontButton:SetScript("OnClick", function()
    if fontMenuFrame:IsShown() then
        fontMenuFrame:Hide()
    else
        PopulateFontScrollMenu()
        fontMenuFrame:Show()
    end
end)

InterfaceOptions_AddCategory(optionsPanel)

----------------------------------------------------
-- Initialization & Event Handler
----------------------------------------------------
local function InitDB()
    for k, v in pairs(defaultDB) do
        if DoomRealmKeyTrackerDB[k] == nil then
            DoomRealmKeyTrackerDB[k] = v
        end
    end
    if not DoomRealmKeyTrackerDB.colors then
        DoomRealmKeyTrackerDB.colors = defaultDB.colors
    end
    for i = 1, 8 do
        if not DoomRealmKeyTrackerDB.colors.items[i] then
            DoomRealmKeyTrackerDB.colors.items[i] = { r = 1, g = 1, b = 1 }
        end
    end
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("BAG_UPDATE")
eventHandler:RegisterEvent("PLAYER_LOGIN")

eventHandler:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitDB()

        mainFrame:SetSize(DoomRealmKeyTrackerDB.width, DoomRealmKeyTrackerDB.height)
        mainFrame:SetShown(not DoomRealmKeyTrackerDB.hideFrame)
        minimapButton:SetShown(not DoomRealmKeyTrackerDB.hideMinimapButton)

        cbHideFrame:SetChecked(DoomRealmKeyTrackerDB.hideFrame)
        cbHideMinimap:SetChecked(DoomRealmKeyTrackerDB.hideMinimapButton)

        fontSlider:SetValue(DoomRealmKeyTrackerDB.fontSize or 12)
        _G[fontSlider:GetName() .. 'Text']:SetText("Text Size: " .. (DoomRealmKeyTrackerDB.fontSize or 12))

        -- Find active font name for button display
        local currentFontPath = DoomRealmKeyTrackerDB.fontPath or defaultDB.fontPath
        local currentFontName = "Select Font..."
        for _, fontData in ipairs(GetAvailableFonts()) do
            if fontData.value == currentFontPath then
                currentFontName = fontData.text
                break
            end
        end
        fontButton:SetText(currentFontName)

        UpdateMinimapButtonPosition()
        UpdateItemCounts()
    elseif event == "PLAYER_LOGIN" or event == "BAG_UPDATE" then
        if DoomRealmKeyTrackerDB.items then
            UpdateItemCounts()
        end
    end
end)

-- Slash Command (/drkt or /doomkeys)
SLASH_DOOMREALMKEYTRACKER1 = "/drkt"
SLASH_DOOMREALMKEYTRACKER2 = "/doomkeys"
SlashCmdList["DOOMREALMKEYTRACKER"] = function()
    DoomRealmKeyTrackerDB.hideFrame = not DoomRealmKeyTrackerDB.hideFrame
    mainFrame:SetShown(not DoomRealmKeyTrackerDB.hideFrame)
end