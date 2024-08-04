-- Critter Emote

-- Revision 2.11.02.01 (naming convention X=orig.X=WOW Xpac.XX=WoW xpac sub.XX=update revision)
-- WOW version 11.02

local CritterEmote_Cats = {
    General = true,
    Silly = true,
    Locations = true,
    Songs = true,
    Special = true,
    PVP = true,
    Target = true,
}

-- Globals Section
local CritterEmote_BaseInterval = 300.0 -- How often the OnUpdate code will run before random (in seconds)
local CritterEmote_TimeSinceLastUpdate = 0
local CritterEmote_EmoteToSend = nil
local CritterEmote_EmoteTimer = 0
local CritterEmote_debug = false
local CritterEmote_Tooltip = nil
local CritterEmote_enable = true
local CritterEmote_randomEnable = true
local CritterEmote_forceEmote = false
local CritterEmote_version = "2.11.02.01"
local is5_0 = select(4, GetBuildInfo()) < 50100
local _G = _G
local C_PetJournal = _G.C_PetJournal
local lastEmote = nil

-- Load localization and emote files based on locale
local locale = GetLocale()
if locale == "deDE" then
    CritterEmote_Strings = CritterEmote_Localization_de
    CritterEmote_General = CritterEmote_General_de
    CritterEmote_Silly = CritterEmote_Silly_de
    CritterEmote_Locations = CritterEmote_Locations_de
    CritterEmote_Songs = CritterEmote_Songs_de
    CritterEmote_Special = CritterEmote_Special_de
    CritterEmote_PVP = CritterEmote_PVP_de
    CritterEmote_Target = CritterEmote_Target_de
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_de
elseif locale == "esES" then
    CritterEmote_Strings = CritterEmote_Localization_es
    CritterEmote_General = CritterEmote_General_es
    CritterEmote_Silly = CritterEmote_Silly_es
    CritterEmote_Locations = CritterEmote_Locations_es
    CritterEmote_Songs = CritterEmote_Songs_es
    CritterEmote_Special = CritterEmote_Special_es
    CritterEmote_PVP = CritterEmote_PVP_es
    CritterEmote_Target = CritterEmote_Target_es
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_es
elseif locale == "frFR" then
    CritterEmote_Strings = CritterEmote_Localization_fr
    CritterEmote_General = CritterEmote_General_fr
    CritterEmote_Silly = CritterEmote_Silly_fr
    CritterEmote_Locations = CritterEmote_Locations_fr
    CritterEmote_Songs = CritterEmote_Songs_fr
    CritterEmote_Special = CritterEmote_Special_fr
    CritterEmote_PVP = CritterEmote_PVP_fr
    CritterEmote_Target = CritterEmote_Target_fr
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_fr
elseif locale == "itIT" then
    CritterEmote_Strings = CritterEmote_Localization_it
    CritterEmote_General = CritterEmote_General_it
    CritterEmote_Silly = CritterEmote_Silly_it
    CritterEmote_Locations = CritterEmote_Locations_it
    CritterEmote_Songs = CritterEmote_Songs_it
    CritterEmote_Special = CritterEmote_Special_it
    CritterEmote_PVP = CritterEmote_PVP_it
    CritterEmote_Target = CritterEmote_Target_it
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_it
elseif locale == "ruRU" then
    CritterEmote_Strings = CritterEmote_Localization_ru
    CritterEmote_General = CritterEmote_General_ru
    CritterEmote_Silly = CritterEmote_Silly_ru
    CritterEmote_Locations = CritterEmote_Locations_ru
    CritterEmote_Songs = CritterEmote_Songs_ru
    CritterEmote_Special = CritterEmote_Special_ru
    CritterEmote_PVP = CritterEmote_PVP_ru
    CritterEmote_Target = CritterEmote_Target_ru
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_ru
else -- default to English
    CritterEmote_Strings = CritterEmote_Localization_en
    CritterEmote_General = CritterEmote_General_en
    CritterEmote_Silly = CritterEmote_Silly_en
    CritterEmote_Locations = CritterEmote_Locations_en
    CritterEmote_Songs = CritterEmote_Songs_en
    CritterEmote_Special = CritterEmote_Special_en
    CritterEmote_PVP = CritterEmote_PVP_en
    CritterEmote_Target = CritterEmote_Target_en
    CritterEmote_ResponseDb = CritterEmote_ResponseDb_en
end

-- Load personalities
CritterEmote_Personalities = CritterEmote_Personalities or {}

-- Load custom chats
CritterEmote_Custom = CritterEmote_Custom or {}

-- Check faction
local function GetPlayerFaction()
    local factionGroup = UnitFactionGroup("player")
    return factionGroup -- This will return "Horde" or "Alliance"
end



-- Check for holiday
local function isHoliday()
    -- Implement the logic to check for in-game holidays
    return IsHolidayActive()
end

-- Generate random emote with no repetition
local function generateRandomEmote()
    local petName = UnitName("pet")
    if not petName then return end

    local randomEmote
    repeat
        randomEmote = CritterEmote_General[math.random(#CritterEmote_General)]
    until randomEmote ~= lastEmote

    lastEmote = randomEmote
    return string.format("%s: %s", petName, randomEmote)
end

-- Schedule the next emote
local function scheduleNextEmote()
    CritterEmote_EmoteTimer = GetTime() + math.random(300, 600)
end

-- OnUpdate handler
local function onUpdate(self, elapsed)
    CritterEmote_TimeSinceLastUpdate = CritterEmote_TimeSinceLastUpdate + elapsed
    if CritterEmote_TimeSinceLastUpdate >= 1 then
        CritterEmote_TimeSinceLastUpdate = 0

        if GetTime() >= CritterEmote_EmoteTimer then
            local emote = generateRandomEmote()
            if emote then
                print(emote)
            end
            scheduleNextEmote()
        end
    end
end

-- Get the response from the response database
local function getResponse(command, petType, petName)
    local responses = CritterEmote_ResponseDb[command]
    if not responses then return nil end

    if petName and responses[petName] then
        return responses[petName][math.random(#responses[petName])]
    elseif petType and responses[petType] then
        return responses[petType][math.random(#responses[petType])]
    else
        return responses["default"][math.random(#responses["default"])]
    end
end

-- Handle slash command
local function handleSlashCommand(command)
    local petName = UnitName("pet")
    local petType = CritterEmote_Personalities[petName] or "default"

    if UnitExists("target") then
        if UnitIsWildBattlePet("target") or UnitIsBattlePetCompanion("target") then
            local response = getResponse(command, petType, petName)
            if response then
                print(string.format("%s %s", petName, response))
            else
                print("No response found.")
            end
        else
            print("Target is not a valid battle pet or companion.")
        end
    else
        print("No target selected.")
    end
end

-- Handle custom chat message
local function handleCustomChat(msg)
    local petName = UnitName("pet")
    if petName then
        local formattedMsg = string.format("%s: %s", petName, msg)
        print(formattedMsg)
        
        -- Ask the player if they want to save the message
        StaticPopupDialogs["SAVE_CUSTOM_CHAT"] = {
            text = CritterEmote_Strings["SAVE_CUSTOM_CHAT"],
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                SaveCustomChat(petName, msg)
                print(CritterEmote_Strings["MESSAGE_SAVED"])
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("SAVE_CUSTOM_CHAT")
    else
        print(CritterEmote_Strings["NO_PET_SUMMONED"])
    end
end

-- Handle slash commands
local function CritterEmote_SlashHandler(msg, editbox)
    if (msg == 'critter' or msg == "battle pet") then
        print('I love to talk!')
    elseif msg == 'test' then
        print("GUID = " .. C_PetJournal.GetSummonedPetGUID())
        CritterEmoteScanTooltip:ClearLines()

        CritterEmoteScanTooltip:SetUnit("target")
        print("TL1 = " .. CritterEmoteScanTooltipTextLeft1:GetText())
        print("TL2 = " .. CritterEmoteScanTooltipTextLeft2:GetText())
        print("TL4 = " .. CritterEmoteScanTooltipTextLeft4:GetText())
        print("# of lines = " .. CritterEmoteScanTooltip:NumLines())
    elseif (msg == 'off') then
        CritterEmote_enable = false
        CritterEmote_UpdateSaveTable()
        CritterEmote_Message(CritterEmote_Strings["HELP_7"])
    elseif (msg == 'on') then
        CritterEmote_enable = true
        CritterEmote_UpdateSaveTable()
        CritterEmote_Message(CritterEmote_Strings["HELP_8"])
    elseif (msg == "info") then
        CritterEmote_Info()
    elseif (msg == "help") then
        CritterEmote_Help()
    elseif (msg == "debug") then
        CritterEmote_debug = true
        CritterEmote_UpdateSaveTable()
        CritterEmote_Message(CritterEmote_Strings["HELP_18"])
    elseif (msg == "debug off") then
        CritterEmote_debug = nil
        CritterEmote_UpdateSaveTable()
        CritterEmote_Message(CritterEmote_Strings["HELP_19"])
    elseif (msg == "random_on") then
        CritterEmote_randomEnable = true
        CritterEmote_Message(CritterEmote_Strings["HELP_10"])
    elseif (msg == "random_off") then
        CritterEmote_randomEnable = false
        CritterEmote_Message(CritterEmote_Strings["HELP_9"])
    elseif (msg == "options") then
        CritterEmote_DisplayOptions()
    elseif (msg == "Silly" or msg == "silly") then
        if (CritterEmote_Cats["Silly"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_12"] .. " " .. "disabled.")
            CritterEmote_Cats["Silly"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_12"] .. " " .. "enabled.")
            CritterEmote_Cats["Silly"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "Locations" or msg == "locations") then
        if (CritterEmote_Cats["Locations"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_14"] .. " " .. "disabled.")
            CritterEmote_Cats["Locations"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_14"] .. " " .. "enabled.")
            CritterEmote_Cats["Locations"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "Songs" or msg == "songs") then
        if (CritterEmote_Cats["Songs"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_15"] .. " " .. "disabled.")
            CritterEmote_Cats["Songs"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_15"] .. " " .. "enabled.")
            CritterEmote_Cats["Songs"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "Special" or msg == "special") then
        if (CritterEmote_Cats["Special"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_13"] .. " " .. "disabled.")
            CritterEmote_Cats["Special"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_13"] .. " " .. "enabled.")
            CritterEmote_Cats["Special"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "PVP" or msg == "pvp") then
        if (CritterEmote_Cats["PVP"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_16"] .. " " .. "disabled.")
            CritterEmote_Cats["PVP"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_16"] .. " " .. "enabled.")
            CritterEmote_Cats["PVP"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "General" or msg == "general") then
        if (CritterEmote_Cats["General"]) then
            CritterEmote_Message(CritterEmote_Strings["HELP_17"] .. " " .. "disabled.")
            CritterEmote_Cats["General"] = false
        else
            CritterEmote_Message(CritterEmote_Strings["HELP_17"] .. " " .. "enabled.")
            CritterEmote_Cats["General"] = true
        end
        CritterEmote_UpdateSaveTable()
    elseif (msg == "") then
        -- CritterEmote_doEmote("General", true)
        -- Instead of calling doEmote lets just set the random interval to now.
        CritterEmote_TimeSinceLastUpdate = 99999999
        CritterEmote_forceEmote = true
    else
        CritterEmote_doEmote(msg)
    end
end

-- Check if the target is the player's pet by using GameTooltip
function CritterEmote_TargetIsPlayersPet()
    local ownerName = CritterEmote_GetTargetPetsOwner()
    return (ownerName and ownerName == GetUnitName("player", false))
end

-- Extract the owner's name from the tooltip string
local function StrExtractCompanionOwner(str)
    CritterEmote_printDebug("Call to StrExtractCompanionOwner")
    CritterEmote_printDebug("str =" .. str)
    if str and string.find(str, "Companion", -9, true) then
        local companionOwner = string.match(str, "[^']+")
        if companionOwner then
            return companionOwner
        end
    end
end

-- Get the owner of the target pet
local function CritterEmote_GetTargetPetsOwner()
    local cegtpo_tst = GetUnitName("player", false)
    if UnitExists("target") and not UnitIsPlayer("target") then
        local cegtpo_type = UnitCreatureType("target")
        if cegtpo_type and ((cegtpo_type == "Wild Pet") or (cegtpo_type == "Non-combat Pet")) then
            CritterEmoteScanTooltip:ClearLines()
            CritterEmoteScanTooltip:SetUnit("target")
            local cegtpo_obj = CritterEmoteScanTooltip
            for cegtpo_x = 1, cegtpo_obj:GetNumRegions() do
                local cegtpo_region = select(cegtpo_x, cegtpo_obj:GetRegions())
                if cegtpo_region and cegtpo_region:GetObjectType() == "FontString" then
                    if cegtpo_region:GetText() then
                        if string.find(cegtpo_region:GetText(), "Companion", -9, true) then
                            if cegtpo_tst == string.match(cegtpo_region:GetText(), "[^']+") then
                                return cegtpo_tst
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- For secure func hook on DoEmote()
local function CritterEmote_OnEmote(emote, target)
    CritterEmote_printDebug("Emote detected: " .. emote)
    if target and #target < 1 then
        local petowner = CritterEmote_GetTargetPetsOwner()
        if petowner then
            CritterEmote_printDebug("\tFound petowner : " .. petowner)
            if (petowner == UnitName("player")) then
                CritterEmote_doEmote(emote, true)
            end
        end
    end
end

-- Saved variable functions
function CritterEmote_AddonLoaded()
    -- Make sure there is one value in before we load
    if (CE_Save_Table == nil) then
        CE_Save_Table = {}
    end
    if CE_Save_Table["Enabled"] == nil then
        CE_Save_Table["Enabled"] = true
    end
    if CE_Save_Table["Debug"] == nil then
        CE_Save_Table["Debug"] = false
    end
    if CE_Save_Table["General"] == nil then
        CE_Save_Table["General"] = false
    end
    if CE_Save_Table["Silly"] == nil then
        CE_Save_Table["Silly"] = true
    end
    if CE_Save_Table["Locations"] == nil then
        CE_Save_Table["Locations"] = true
    end
    if CE_Save_Table["Songs"] == nil then
        CE_Save_Table["Songs"] = true
    end
    if CE_Save_Table["Special"] == nil then
        CE_Save_Table["Special"] = true
    end
    if CE_Save_Table["PVP"] == nil then
        CE_Save_Table["PVP"] = true
    end
    if CE_Save_Table["Target"] == nil then
        CE_Save_Table["Target"] = true
    end

    CritterEmote_Cats["Silly"] = CE_Save_Table["Silly"]
    CritterEmote_Cats["Locations"] = CE_Save_Table["Locations"]
    CritterEmote_Cats["Songs"] = CE_Save_Table["Songs"]
    CritterEmote_Cats["Special"] = CE_Save_Table["Special"]
    CritterEmote_Cats["PVP"] = CE_Save_Table["PVP"]
    CritterEmote_Cats["General"] = CE_Save_Table["General"]
    CritterEmote_Cats["Target"] = CE_Save_Table["Target"]

    CritterEmote_debug = CE_Save_Table["Debug"]
    CritterEmote_enable = CE_Save_Table["Enabled"]

    CritterEmote_DisplayOptions() -- Display options when addon is loaded
end

function CritterEmote_UpdateSaveTable()
    CE_Save_Table = {
        Enabled = CritterEmote_enable,
        Silly = CritterEmote_Cats["Silly"],
        Locations = CritterEmote_Cats["Locations"],
        Songs = CritterEmote_Cats["Songs"],
        Special = CritterEmote_Cats["Special"],
        PVP = CritterEmote_Cats["PVP"],
        General = CritterEmote_Cats["General"],
        Target = CritterEmote_Cats["Target"],
        Debug = CritterEmote_debug,
    }
end

function CritterEmote_DisplayOptions()
    CritterEmote_Message(CritterEmote_Strings["OPTIONS"] .. ":")
    for k, v in pairs(CE_Save_Table) do
        if (v == true) then
            CritterEmote_Message(k .. " <=> true")
        elseif (v == false) then
            CritterEmote_Message(k .. " <=> false")
        else
            CritterEmote_Message(k .. " <=> " .. v)
        end
    end
    -- CritterEmote_Message( "BaseInterval = " .. CritterEmote_BaseInterval)
    -- CritterEmote_Message( "TimeSinceLastUpdate = " .. CritterEmote_TimeSinceLastUpdate)
    -- CritterEmote_Message( "EmoteTimer = " CritterEmote_EmoteTimer)
    -- CritterEmote_Message( "enable = " CritterEmote_enable)
    -- CritterEmote_Message( "randomEnable = " CritterEmote_randomEnable)
end

-- Main load
function CritterEmote_OnLoad()
    -- Stop the random number generator from doing the same thing every time
    local tval = math.random()
    tval = random()

    -- Secure hook functions
    hooksecurefunc("DoEmote", CritterEmote_OnEmote)

    CritterEmoteFrame:RegisterEvent("ADDON_LOADED")
    CritterEmoteFrame:RegisterEvent("PLAYER_LOGOUT")
    CritterEmoteFrame:RegisterEvent("CHAT_MSG_EMOTE")
    CritterEmoteFrame:RegisterEvent("UNIT_PET")
    CritterEmoteFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

    CritterEmote_Tooltip = CreateFrame("GameTooltip", "CritterEmoteScanTooltip", nil, "GameTooltipTemplate") -- Tooltip name cannot be nil
    CritterEmoteScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    -- Allow tooltip SetX() methods to dynamically add new lines based on these
    CritterEmoteScanTooltip:AddFontStrings(
        CritterEmoteScanTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
        CritterEmoteScanTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
    )

    -- Define Slash Commands
    SLASH_CRITTEREMOTE1 = "/ce"
    SlashCmdList["CRITTEREMOTE"] = CritterEmote_SlashHandler

    -- Update timer
    CritterEmote_SetUpdateInterval(30, 400)
    CritterEmote_Welcome()
end

-- Do every Frame
function CritterEmote_OnUpdate(self, elapsed)
    if (CritterEmote_enable) then
        CritterEmote_TimeSinceLastUpdate = CritterEmote_TimeSinceLastUpdate + elapsed

        -- To ensure emote is sent after player's
        if CritterEmote_EmoteToSend then
            CritterEmote_EmoteTimer = CritterEmote_EmoteTimer + elapsed
            if CritterEmote_EmoteTimer > 0.5 then
                SendChatMessage(CritterEmote_EmoteToSend, "EMOTE")
                CritterEmote_EmoteToSend = nil
                CritterEmote_EmoteTimer = 0
            end
        end

        -- Make sure we are also not in combat
        if (CritterEmote_randomEnable or CritterEmote_forceEmote) then
            if (CritterEmote_TimeSinceLastUpdate > CritterEmote_UpdateInterval and not UnitAffectingCombat("player")) then
                if (CritterEmote_forceEmote) then
                    CritterEmote_forceEmote = false
                end
                CritterEmote_printDebug("Random interval time elapsed.")
                local petName = CritterEmote_GetActivePet()
                if (petName ~= nil) then
                    -- If you have something targeted 1/3 of the time do a Target emote
                    local randomChance = random(1, 3)
                    CritterEmote_printDebug("Random Chance : " .. randomChance)
                    if (UnitName("target") and randomChance == 1) then
                        CritterEmote_doEmote("Target", true)
                    else
                        CritterEmote_doEmote("General", true)
                    end
                end
                CritterEmote_SetUpdateInterval(30, 400)
            end
        end -- randomEnable
    end -- enable
end

function CritterEmote_doEmote(msg, doemote)
CritterEmote_printDebug("Call to CritterEmote_doEmote.")
local emo = nil
local petName = CritterEmote_GetActivePet(nil)
local customName = CritterEmote_GetActivePet(1)
local faction = GetPlayerFaction()

if petName ~= nil then
    if doemote then
        local holiday = GetCurrentHoliday()
        if holiday and CritterEmote_Special[holiday] then
            emo = CritterEmote_GetRandomTableEntry(CritterEmote_Special[holiday])
        elseif msg == "PVP" and CritterEmote_PVP then
            if faction == "Horde" and CritterEmote_PVP["default_Horde"] then
                emo = CritterEmote_GetRandomTableEntry(CritterEmote_PVP["default_Horde"])
            elseif faction == "Alliance" and CritterEmote_PVP["default_Alliance"] then
                emo = CritterEmote_GetRandomTableEntry(CritterEmote_PVP["default_Alliance"])
            end
        else
            emo = CritterEmote_GetEmoteMessage(msg, petName, customName)
        end

        if emo then
            if customName then
                CritterEmote_DisplayEmote(customName .. " " .. emo)
            else
                CritterEmote_DisplayEmote(petName .. " " .. emo)
            end
        end
    else
        if type(msg) == "string" then
            if customName then
                CritterEmote_DisplayEmote(customName .. " " .. msg)
            else
                CritterEmote_DisplayEmote(petName .. " " .. msg)
            end
        else
            CritterEmote_DisplayEmote(petName .. " moons you.")
        end
    end
else
    CritterEmote_Message(CritterEmote_Strings["NO_ACTIVE_CRITTER"])
end
end


-- Search an incomplete lua table and return found node
function CritterEmote_TableSearch(mytable, search)
    CritterEmote_printDebug("TableSearch=> Call to Table Search with " .. search)
    for k, v in pairs(mytable) do
        if (k == search) then
            CritterEmote_printDebug("TableSearch=> Found " .. k)
            return v
        end
    end
    return nil
end

-- Just return random entry in table
function CritterEmote_GetRandomTableEntry(myTable)
    return (myTable[random(1, #myTable)])
end

-- Searches the emote table for an appropriate emote
function CritterEmote_GetEmoteMessage(msg, petName, customName)
    emo = nil
    emoT = nil
    tmp_table = nil
    search_name = nil
    emoPT = CritterEmote_TableSearch(CritterEmote_Personalities, petName)
    if (emoPT == nil) then
        emoPT = " " -- HACK to make sure table search is ok.
    end
    if (customName == nil) then
        customName = " "
    end
    CritterEmote_printDebug("Call to GetEmoteMessage")
    CritterEmote_printDebug(" Getting Emote Table for " .. msg)
    emoT = CritterEmote_TableSearch(CritterEmote_ResponseDb, msg)
    if (emoT) then
        CritterEmote_printDebug("  Found the table" .. msg)
        emo = CritterEmote_TableSearch(emoT, customName)
        if (emo) then
            CritterEmote_printDebug("  Found custom name " .. customName)
            search_name = customName
        else
            emo = CritterEmote_TableSearch(emoT, petName)
            if (emo) then
                CritterEmote_printDebug("  Found pet name " .. petName)
                search_name = petName
            else
                emo = CritterEmote_TableSearch(emoT, emoPT)
                if (emo) then
                    CritterEmote_printDebug("  Found pet type " .. emoPT)
                    search_name = emoPT
                else
                    emo = CritterEmote_TableSearch(emoT, "default")
                    if (emo) then
                        CritterEmote_printDebug("  Found default ")
                        search_name = "default"
                    end
                end
            end
        end
        if (emo) then
            for k, v in pairs(CritterEmote_Cats) do
                if (v == true) then
                    CritterEmote_printDebug("    Searching for " .. k)
                    tmp_table = CritterEmote_TableSearch(emoT, search_name .. "_" .. k)
                    if (type(tmp_table) == "table") then
                        CritterEmote_printDebug("    Found " .. k)
                        emo = CE_array_concat(emo, tmp_table)
                    end
                end
            end
            if (type(emo) == "table") then
                CritterEmote_printDebug("Returning random entry for " .. search_name)
                return CritterEmote_GetRandomTableEntry(emo)
            end
        end
        CritterEmote_printDebug("Could not find table entry for " .. msg)
        return nil
    end
    CritterEmote_printDebug("Could not find table for " .. msg)
    return nil
end

-- Returns the name of the active pet one has out
function CritterEmote_GetActivePet(custom)
    CritterEmote_printDebug("Call to CritterEmote_GetActivePet")
    local petid
    petid = C_PetJournal.GetSummonedPetGUID()
    if (petid == nil) then
        CritterEmote_printDebug("PetID is nil")
        return nil
    end
    CritterEmote_printDebug("PetID is " .. petid)
    local _, customName, petName
    _, customName, _, _, _, _, _, petName = C_PetJournal.GetPetInfoByPetID(petid)
    if (custom) then
        if (customName) then
            CritterEmote_printDebug("GetActivePet returning " .. customName)
            return customName
        else
            return nil
        end
    end
    CritterEmote_printDebug("GetActivePet returning " .. petName)
    return petName
end

-- Register slash commands
local function registerSlashCommands()
    for command, _ in pairs(CritterEmote_ResponseDb) do
        _G["SLASH_CRITTEREMOTE_" .. command:upper() .. "1"] = "/" .. command:lower()
        SlashCmdList["CRITTEREMOTE_" .. command:upper()] = function()
            handleSlashCommand(command:upper())
        end
    end

    SLASH_CRITTEREMOTECUSTOM1 = "/ce"
    SlashCmdList["CRITTEREMOTECUSTOM"] = handleCustomChat
end

local function GetCurrentHoliday()
    -- Example implementation: Return the current holiday based on date or game events
    -- This is a simplified example; you should replace it with actual logic or API calls.
    
    local date = C_DateAndTime.GetCurrentCalendarTime()
    local month = date.month
    local day = date.monthDay

    if (month == 12 and day >= 16) or (month == 1 and day <= 2) then
        return "WinterVeil"
    elseif (month == 6 and day >= 21) or (month == 7 and day <= 5) then
        return "MidsummerFireFestival"
    elseif (month == 10 and day >= 18) or (month == 11 and day <= 1) then
        return "HallowsEnd"
    elseif (month == 2 and day >= 7) or (month == 2 and day <= 21) then
        return "LoveIsInTheAir"
    elseif (month == 9 and day >= 20) or (month == 10 and day <= 6) then
        return "Brewfest"
    else
        return nil
    end
end

-- Event handler
local function eventHandler(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
        local emote = generateRandomEmote()
        if emote then
            print(emote)
        end
        scheduleNextEmote()
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "CritterEmote" then
            CritterEmote_AddonLoaded()
        end
    elseif event == "PLAYER_LOGOUT" then
        CritterEmote_UpdateSaveTable()
    elseif event == "UNIT_PET" then
        local unit = ...
        if unit == "player" then
            local petName = CritterEmote_GetActivePet()
            if petName then
                local holiday = GetCurrentHoliday()
                if holiday and CritterEmote_Special[holiday] then
                    local emote = CritterEmote_GetRandomTableEntry(CritterEmote_Special[holiday])
                    if emote then
                        CritterEmote_DisplayEmote(petName .. " " .. emote)
                    end
                end
            end
        end
    end
end

-- Register events
local frame = CreateFrame("Frame", "CritterEmoteFrame")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("UNIT_PET")
frame:SetScript("OnEvent", eventHandler)
frame:SetScript("OnUpdate", CritterEmote_OnUpdate)

-- Initialize slash commands
registerSlashCommands()

-- Initial emote scheduling
scheduleNextEmote()
