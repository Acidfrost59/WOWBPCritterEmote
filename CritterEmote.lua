--Critter Emote aka BP CritterEmote

--Revision 1.11.1.7.01 (naming convention X.XX.X or XX.X if needed.XX where X=critter emote version.X=WOW Xpac.X or XX=WoW xpac sub.X = addt Xpac sub as needed. XX=update revision counting up as needed)
--WOW version 11.1.7


local CritterEmote_Cats = {
  Normal = true;
  Silly = true;
  Song = true;
  Locations = true;
  Special = true;
  PVP = true;
}
-- Globals Section
local CritterEmote_BaseInterval = 300.0; -- How often the OnUpdate code will run before random(in seconds)
local CritterEmote_TimeSinceLastUpdate = 0; 
local CritterEmote_EmoteToSend = nil;
local CritterEmote_EmoteTimer = 0;
local CritterEmote_debug = false;
local CritterEmote_Tooltip = nil ; 
local CritterEmote_enable = true;
local CritterEmote_randomEnable = true;
local CritterEmote_forceEmote = false;
local CritterEmote_version = "1.11.1.7.01";
local is5_0 = select(4, GetBuildInfo()) < 50100
local _G = _G
local C_PetJournal = _G.C_PetJournal

local CritterEmote_Strings = {
        --["UNHAPPY"] = "Interface\\Icons\\Spell_Misc_EmotionAngry",
        ["WELCOME_MESSAGE"] = "Welcome to CritterEmote",
        ["WELCOME_INFO"] = "Type <cmd>/ce help</cmd> for a list of commands.",
        ["WELCOME_CE"] = "Greetings critter lover!",
        ["WELCOME_ACTIVE"] = "Critter Emote is currently : ",
        ["WELCOME_VERSION"] = "Critter Emote version is : " .. CritterEmote_version,
        ["HELP_GENERAL"] = "<cmd>/ce</cmd> has critter emote whatever you like.",
        ["HELP_1"] = "<cmd>/ce</cmd> - have your critter perform a random emote.",
        ["HELP_2"] = "<cmd>/ce <message></cmd> - have your critter emote your <message>.",
        ["HELP_3"] = "<cmd>/ce [options]</cmd> - perform the requested option:",
        ["HELP_4"] = "[options] = ",
        ["HELP_5"] = "info   : displays Critter Emote information.",
        ["HELP_6"] = "help   : displays this help.",
        ["HELP_7"] = "off    : turns the emotes off.",
        ["HELP_8"] = "on     : turns the emotes on.",
        ["HELP_9"] = "random_off : turns all random emotes off.",
        ["HELP_10"] = "random_on : turns all random emotes on.",
        ["HELP_11"] = "options: Displays current options.",
        ["HELP_12"] = "silly  : Toggles silly emotes.",
        ["HELP_13"] = "special  : Toggles special emotes.",
        ["HELP_14"] = "locations  : Toggles location emotes.",
        ["HELP_15"] = "songs  : Toggles song emotes.",
        ["HELP_16"] = "PVP  : Toggles PVP emotes.",
        ["HELP_17"] = "general  : Toggles general emotes",
        ["HELP_18"] = "debug  : Turns debug on.",
        ["HELP_19"] = "debug off  :  Turns debug off.",
      
}

--What to do with the Slash Commands
--Needs to exist before OnLoad
local function CritterEmote_SlashHandler(msg, editbox)
        if (msg == 'critter' or msg == "battle pet") then
                print('I love to talk!');
        elseif msg == "test" then
  local guid = C_PetJournal.GetSummonedPetGUID()
  print("GUID = " .. (guid or "none"))

  local owner = CritterEmote_GetTargetPetsOwner()
  if owner then
    print("Target pet belongs to: " .. owner)
  else
    print("No valid pet target or companion owner text found.")
  end

  
  elseif (msg == 'off' ) then
    CritterEmote_enable = false;
    CritterEmote_UpdateSaveTable();
    CritterEmote_Message("Critter Emote is now disabled. The critters are sad.");
  elseif (msg == 'on' ) then
    CritterEmote_enable = true;
    CritterEmote_UpdateSaveTable();
    CritterEmote_Message("Critter Emote is now enabled. Party Time, critters!");
        elseif (msg == "info") then
                CritterEmote_Info();
        elseif (msg == "help") then  
                CritterEmote_Help();
  elseif (msg == "debug" ) then
    CritterEmote_debug=true;
    CritterEmote_UpdateSaveTable();
    CritterEmote_Message("Critter Emote debug is now on!");
        elseif (msg == "debug off" ) then
                CritterEmote_debug=nil;
                CritterEmote_UpdateSaveTable();
                CritterEmote_Message("Critter Emote debug is now off.");
  elseif(msg == "random_on" ) then
  	CritterEmote_randomEnable=true;
  	CritterEmote_Message("Critter Emote Random Emotes are enabled!  Time for nom.");
  elseif(msg == "random_off" ) then
  	CritterEmote_randomEnable=false;
  	CritterEmote_Message("Critter Emote Random Emotes are now disabled.  The little dudes are sad.");
  elseif(msg == "options" ) then
          CritterEmote_DisplayOptions();
  elseif(msg == "Silly" or msg=="silly") then
    if(CritterEmote_Cats["Silly"]) then
      CritterEmote_Message("Silly Emotes now disabled.");
      CritterEmote_Cats["Silly"] = false;
    else
      CritterEmote_Message("Silly Emotes now enabled.");
      CritterEmote_Cats["Silly"] = true;
    end
    CritterEmote_UpdateSaveTable();
  elseif(msg == "Locations" or msg=="locations") then
    if(CritterEmote_Cats["Locations"]) then
      CritterEmote_Message("Location Emotes now disabled.");
      CritterEmote_Cats["Locations"] = false;
    else
      CritterEmote_Message("Location Emotes now enabled.");
      CritterEmote_Cats["Locations"] = true;
    end
    CritterEmote_UpdateSaveTable();
  elseif(msg == "Songs" or msg=="songs") then
    if(CritterEmote_Cats["Songs"]) then
      CritterEmote_Message("Song Emotes now disabled.");
      CritterEmote_Cats["Songs"] = false;
    else
      CritterEmote_Message("Song Emotes now enabled.");
      CritterEmote_Cats["Songs"] = true;
    end
    CritterEmote_UpdateSaveTable();
  elseif(msg == "Special" or msg=="special") then
    if(CritterEmote_Cats["Special"]) then
      CritterEmote_Message("Special Emotes now disabled.");
      CritterEmote_Cats["Special"] = false;
    else
      CritterEmote_Message("Special Emotes now enabled.");
      CritterEmote_Cats["Special"] = true;
    end
    CritterEmote_UpdateSaveTable();
  elseif(msg == "PVP" or msg=="pvp") then
    if(CritterEmote_Cats["PVP"]) then
      CritterEmote_Message("PVP Emotes now disabled.");
      CritterEmote_Cats["PVP"] = false;
    else
      CritterEmote_Message("PVP Emotes now enabled.");
      CritterEmote_Cats["PVP"] = true;
    end
    CritterEmote_UpdateSaveTable();
  elseif(msg == "General" or msg=="general") then
    if(CritterEmote_Cats["General"]) then
      CritterEmote_Message("General Emotes now disabled.");
      CritterEmote_Cats["General"] = false;
    else
      CritterEmote_Message("General Emotes now enabled.");
      CritterEmote_Cats["General"] = true;
    end
    CritterEmote_UpdateSaveTable();
        elseif (msg == "") then
                --CritterEmote_doEmote("Random", true);
                --Instead of calling doEmote lets just set the random interval to now.
                CritterEmote_TimeSinceLastUpdate = 99999999;
                CritterEmote_forceEmote = true;
        else
                CritterEmote_doEmote(msg);
        end
end

--[Checks if target is player's pet by using GameTooltip]

function CritterEmote_TargetIsPlayersPet()
        local ownerName = CritterEmote_GetTargetPetsOwner()
        return ( ownerName and ownerName == GetUnitName("player", false) )
end

--[[
//      Parameter: str
//      Expected string from tooltip and extracts the owner name from it by looking for the apostrophe.
--]]
local function StrExtractCompanionOwner(str)
  CritterEmote_printDebug("Call to StrExtractCompanionOwner");
  CritterEmote_printDebug("str =" .. str)
        if str and string.find(str, "Companion", -9, true) then
                local companionOwner = string.match(str, "[^']+")
                if companionOwner then
                        return companionOwner
                end
        end
end

local function CritterEmote_GetTargetPetsOwner()
  if not UnitExists("target") or UnitIsPlayer("target") then return nil end
  local creatureType = UnitCreatureType("target")
  if creatureType ~= "Wild Pet" and creatureType ~= "Non-combat Pet" then return nil end

  local tooltipData = C_TooltipInfo.GetUnit("target")
  if not tooltipData or not tooltipData.lines then return nil end

  local playerName = GetUnitName("player", false)
  for _, line in ipairs(tooltipData.lines) do
    if line.leftText and line.leftText:find("Companion", -9, true) then
      local owner = string.match(line.leftText, "[^']+")
      if owner == playerName then
        return owner
      end
    end
  end
  return nil
end

--      For secure func hook on DoEmote()
local function CritterEmote_OnEmote(emote, target)
        CritterEmote_printDebug("Emote detected: ".. emote)
        if target and #target < 1 then
                local petowner = CritterEmote_GetTargetPetsOwner()
                if petowner then
      CritterEmote_printDebug("\tFound petowner : " .. petowner);
                        if(petowner == UnitName("player") ) then
                                CritterEmote_doEmote(emote,true);
                        end
                end
        end
end

--Saved variable functions
function CritterEmote_AddonLoaded()

  --Make sure there is one value in before we load
  if(CE_Save_Table == nil) then
  CE_Save_Table = {};
  end
  if CE_Save_Table["Enabled"] == nil then
    CE_Save_Table["Enabled"] = true;
  end
  if CE_Save_Table["Debug"] == nil then
    CE_Save_Table["Debug"] = false;
  end
  if CE_Save_Table["General"] == nil then
    CE_Save_Table["General"] = false;
  end
  if CE_Save_Table["Silly"] == nil then
    CE_Save_Table["Silly"] = true;
  end
  if CE_Save_Table["Locations"] == nil then
    CE_Save_Table["Locations"] = true;
  end
  if CE_Save_Table["Songs"] == nil then
    CE_Save_Table["Songs"] = true;
  end
  if CE_Save_Table["Special"] == nil then
    CE_Save_Table["Special"] = true;
  end
  if CE_Save_Table["PVP"] == nil then
    CE_Save_Table["PVP"] = true;
  end
  
  CritterEmote_Cats["Silly"] = CE_Save_Table["Silly"];
  CritterEmote_Cats["Locations"] = CE_Save_Table["Locations"];
  CritterEmote_Cats["Songs"] = CE_Save_Table["Songs"];
  CritterEmote_Cats["Special"] = CE_Save_Table["Special"];
  CritterEmote_Cats["PVP"] = CE_Save_Table["PVP"];
  CritterEmote_Cats["General"] = CE_Save_Table["General"];

  CritterEmote_debug = CE_Save_Table["Debug"];
  CritterEmote_enable = CE_Save_Table["Enabled"];
  
  --Display all the info now that the addon is loaded

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
    Debug = CritterEmote_debug,
  }
end
function CritterEmote_DisplayOptions()
  CritterEmote_Message("Options:");
  for k,v in pairs(CE_Save_Table) do
    if(v == true) then
      CritterEmote_Message( k .. " <=> true");
    elseif(v == false) then
      CritterEmote_Message( k .." <=> false");
    else
      CritterEmote_Message( k .." <=> " .. v);
    end
  end
  --CritterEmote_Message( "BaseInterval = " .. CritterEmote_BaseInterval);
  --CritterEmote_Message( "TimeSinceLastUpdate = " .. CritterEmote_TimeSinceLastUpdate);
  --CritterEmote_Message( "EmoteTimer = " CritterEmote_EmoteTimer);
  --CritterEmote_Message( "enable = " CritterEmote_enable);
  --CritterEmote_Message( "randomEnable = " CritterEmote_randomEnable);
end

--Main load
function CritterEmote_OnLoad ()  
  
  --Stop the random number generator from doing the same thing every time
  local tval = math.random();
  tval = random();
  
  --Secure hook functions
        hooksecurefunc("DoEmote", CritterEmote_OnEmote);        
        
        CritterEmoteFrame:RegisterEvent("ADDON_LOADED");
        CritterEmoteFrame:RegisterEvent("PLAYER_LOGOUT");  
        CritterEmoteFrame:RegisterEvent("CHAT_MSG_EMOTE");
        CritterEmoteFrame:RegisterEvent("UNIT_PET")
        CritterEmoteFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
  
    

        --Define Slash Commands
        SLASH_CRITTEREMOTE1 = "/ce";

    

        SlashCmdList["CRITTEREMOTE"] = CritterEmote_SlashHandler; 

        --Update timer
        CritterEmote_SetUpdateInterval(30, 400);
        CritterEmote_Welcome();
end

--Do every Frame
function CritterEmote_OnUpdate(self, elapsed)
  if(CritterEmote_enable) then
    CritterEmote_TimeSinceLastUpdate = CritterEmote_TimeSinceLastUpdate + elapsed;
  
        --To ensure emote is sent after player's
        if CritterEmote_EmoteToSend then
                CritterEmote_EmoteTimer = CritterEmote_EmoteTimer + elapsed
                if CritterEmote_EmoteTimer > 0.5 then
                        SendChatMessage(CritterEmote_EmoteToSend, "EMOTE")
                        CritterEmote_EmoteToSend = nil
                        CritterEmote_EmoteTimer = 0
                end
        end

        --Make sure we are also not in combat
  if(CritterEmote_randomEnable or CritterEmote_forceEmote) then
  if (CritterEmote_TimeSinceLastUpdate > CritterEmote_UpdateInterval and not UnitAffectingCombat("player") ) then
    if(CritterEmote_forceEmote) then 
    	CritterEmote_forceEmote = false;
    end
    --
    -- Insert your OnUpdate code here
    --
    CritterEmote_printDebug("Random interval time elapsed.");
    local petName = CritterEmote_GetActivePet();
    if(petName ~= nil) then
    --If you have something targeted 1/3 of the time do a Target emote
                local randomChance=random(1,3);
          CritterEmote_printDebug("Random Chance : " .. randomChance);
      if(UnitName("target") and randomChance == 1) then
        CritterEmote_doEmote("Target",true);
      else
        CritterEmote_doEmote("Random",true);
      end
          end
            CritterEmote_SetUpdateInterval(30, 400);
    end
    end --randomEnable
  end --enable
end

function CritterEmote_doEmote(msg, doemote)
  CritterEmote_printDebug("Call to CritterEmote_doEmote.");
        local emo=nil;
        local petName = CritterEmote_GetActivePet(nil);
        local customName = CritterEmote_GetActivePet(1);
        --local tableRef = CritterEmote.ResponseDb[petName][WOW BattlePet API]
        if(petName ~= nil) then
                if( doemote ) then
                        emo = CritterEmote_GetEmoteMessage(msg,petName,customName);
                        if(emo) then
                        		if(customName) then
                        			CritterEmote_DisplayEmote(customName .. " " .. emo);
                        		else
                                	CritterEmote_DisplayEmote(petName .. " " .. emo);
                                end
                        --else
                        --      CritterEmote_DisplayEmote(petName .. " responds to your " .. msg .. ".");
                        end
                else
                        if(type(msg) == "string") then
                        		if(customName) then
                                	CritterEmote_DisplayEmote(customName .. " " .. msg);
                                else
                                    CritterEmote_DisplayEmote(petName .. " " .. msg);
                                end
                        else
                                --Catch all should really never be here.
                                CritterEmote_DisplayEmote(petName .. " moons you.");
                        end
                end
        else
                CritterEmote_Message("You do not have an active critter out.");
        end
end 

--Search an incomplete lua table and return found node
function CritterEmote_TableSearch(mytable, search)
        CritterEmote_printDebug("TableSearch=> Call to Table Search with " .. search);
        for k,v in pairs(mytable) do 
                if(k == search) then
                        CritterEmote_printDebug("TableSearch=> Found " .. k);
                        return v;
                end
        end
        return nil;
end

--Just return random entry in table
function CritterEmote_GetRandomTableEntry(myTable)                      
        --print("Call to Random Table");
        return(myTable[random(1, #myTable)]);
end     

--Searches the emote table for an appropriate emote
--msg = predefined emote type
--petName = the pet you have out
function CritterEmote_GetEmoteMessage(msg,petName,customName)
  emo=nil;
  emoT=nil;
  tmp_table=nil;
  search_name=nil;
  emoPT = CritterEmote_TableSearch(CritterEmote_Personalities, petName);
  if(emoPT == nil) then
    emoPT = " " ; -- HACK to make sure table search is ok.
  end
  if(customName == nil ) then
  	customName = " " ;
  end
  --See if pet exists in table
  CritterEmote_printDebug("Call to GetEmoteMessage");
  CritterEmote_printDebug(" Getting Emote Table for " .. msg);
  emoT = CritterEmote_TableSearch(CritterEmote_ResponseDb, msg);
  --Found emote table
  if(emoT) then 
    CritterEmote_printDebug("  Found the table" .. msg); 
    emo=CritterEmote_TableSearch(emoT, customName)
    if( emo ) then
   		CritterEmote_printDebug("  Found custom name " .. customName);
    	search_name=customName;
    else
	emo=CritterEmote_TableSearch(emoT, petName)
	if( emo ) then
		CritterEmote_printDebug("  Found pet name " .. petName);
		search_name=petName;
	else
	emo=CritterEmote_TableSearch(emoT, emoPT)
	if( emo ) then
		CritterEmote_printDebug("  Found pet type " .. emoPT);
		search_name=emoPT;
	else
	emo=CritterEmote_TableSearch(emoT, "default")
	if( emo ) then
		CritterEmote_printDebug("  Found default ");
		search_name="default";
	end
	end
	end
    end
    if(emo) then --Found the exact pet
      --CritterEmote_printDebug("  Found pet: " .. petName);
      for k, v in pairs(CritterEmote_Cats) do 
        if(v==true) then
          CritterEmote_printDebug("    Searching for " .. k);
          tmp_table = CritterEmote_TableSearch(emoT, search_name .. "_" .. k)
          if(type(tmp_table) == "table" )  then
            CritterEmote_printDebug("    Found " .. k);
            emo = CE_array_concat(emo, tmp_table);
          end
        end
      end
      if( type(emo) == "table" ) then
        CritterEmote_printDebug("Returning random entry for " .. search_name);
        return CritterEmote_GetRandomTableEntry(emo);
      end
    end
    CritterEmote_printDebug("Could not find table entry for ".. msg);
	return nil;
  end --ifemoT
  CritterEmote_printDebug("Could not find table for ".. msg);
  return nil;
end

--Returns the name of the active pet one has out
function CritterEmote_GetActivePet(custom)
  CritterEmote_printDebug("Call to CritterEmote_GetActivePet");
  local petid
    petid = C_PetJournal.GetSummonedPetGUID();
    --CritterEmote_printDebug("Call to GetSummonedPetGUID");
    if(petid == nil) then
        CritterEmote_printDebug("PetID is nil");
		return nil
	end
	CritterEmote_printDebug("PetID is " .. petid);
    local _, customName, petName
    _, customName, _, _, _, _, _, petName = C_PetJournal.GetPetInfoByPetID(petid);
    --speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable = C_PetJournal.GetPetInfoByPetID("petID");
    --CritterEmote_printDebug("PetName " .. petName .. " Custom Name " .. customName);
	--CritterEmote_printDebug("Found petname " .. customName or petName);
	if(custom) then
		if( customName )then
			CritterEmote_printDebug("GetActivePet returning " .. customName);
		return customName;
		else
			return nil
		end
	end
				CritterEmote_printDebug("GetActivePet returning " .. petName);
	return petName;
    --return customName or petName

end

--This function returns real events 
--This can be a way for pets to interact with the world more.
--TODO
--revised arg2 through arg5 with tostring so only CritterEmote is referenced. Was pulling other mods into arg1.
function CritterEmote_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, ...)
  CritterEmote_printDebug("On Event Tripped with event : " .. event);
  if(arg1) then CritterEmote_printDebug("\targ1 : " .. arg1) end;
  if(arg2) then CritterEmote_printDebug("\targ2 : " .. tostring(arg2)) end;
  if(arg3) then CritterEmote_printDebug("\targ3 : " .. tostring(arg3)) end;
  if(arg4) then CritterEmote_printDebug("\targ4 : " .. tostring(arg4)) end;
  if(arg5) then CritterEmote_printDebug("\targ5 : " .. tostring(arg5)) end;
  if event == "ADDON_LOADED" then
    CritterEmote_AddonLoaded();
  end
  if event == "PLAYER_LOGOUT" then
    CritterEmote_UpdateSaveTable();
  end
 -- insert event handling code here
  --CHAT_MSG_EMOTE
  --if event == "CHAT_MSG_EMOTE" and arg2 == GetUnitName("player", false) then
        --      ChatFrame1:AddMessage("OnEvent Tripped :" .. arg1.." : "..arg2.." : "..arg5)
  --end
end



--Print to the chat frame
function CritterEmote_Message (message)
        
        if (DEFAULT_CHAT_FRAME and type(message) == "string") then
                message = string.gsub(message, "<cmd>", "|CFFBBFFBB");
                message = string.gsub(message, "</cmd>", "|r");
                DEFAULT_CHAT_FRAME:AddMessage("|CFFFFF888<CritterEmote>|r " .. message, 1, 1, 1);
        end
        
end

--Any formating functions for displaying the emote
function CritterEmote_DisplayEmote (message)
        if (string.sub(UnitName("player"), string.len(UnitName("player"))) == "s") then
                nameAdd = ' ';
        else
                nameAdd = ': ';
        end
        CritterEmote_EmoteToSend = nameAdd  .. message;
end

--Set the new update interval
function CritterEmote_SetUpdateInterval (minFrequency, maxFrequency)
        CritterEmote_TimeSinceLastUpdate = 0;
        CritterEmote_UpdateInterval =  CritterEmote_BaseInterval + random(minFrequency, maxFrequency);
end

--Display Messages
function CritterEmote_Help ()
  CritterEmote_Message(CritterEmote_Strings["HELP_GENERAL"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_1"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_2"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_3"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_4"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_5"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_6"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_7"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_8"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_9"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_10"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_11"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_12"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_13"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_14"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_15"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_16"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_17"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_18"]);
  CritterEmote_Message(CritterEmote_Strings["HELP_19"]);



end
function CritterEmote_Info ()
        CritterEmote_Message(CritterEmote_Strings["WELCOME_MESSAGE"]);
        CritterEmote_Message(CritterEmote_Strings["WELCOME_INFO"]);
        CritterEmote_Message(CritterEmote_Strings["WELCOME_VERSION"]);
  if(CritterEmote_enable) then
    CritterEmote_Message(CritterEmote_Strings["WELCOME_ACTIVE"] .. "Active!");
  else
    CritterEmote_Message(CritterEmote_Strings["WELCOME_ACTIVE"] .. "Deactivated.");
  end
end

function CritterEmote_Welcome()
        CritterEmote_Message(CritterEmote_Strings["WELCOME_MESSAGE"]);
        CritterEmote_Message(CritterEmote_Strings["WELCOME_INFO"]);
        CritterEmote_Message(CritterEmote_Strings["WELCOME_VERSION"]);
end

function CritterEmote_printDebug (msg)
  if( CritterEmote_debug ) then
    print(msg);
  end
end

-- return a new array containing the concatenation of all of its 
-- parameters. Scaler parameters are included in place, and array 
-- parameters have their values shallow-copied to the final array.
-- Note that userdata and function values are treated as scalar.
function CE_array_concat(...) 
    local t = {}
    for n = 1,select("#",...) do
        local arg = select(n,...)
        if type(arg)=="table" then
            for _,v in ipairs(arg) do
                t[#t+1] = v
            end
        else
            t[#t+1] = arg
        end
    end
    return t
end

