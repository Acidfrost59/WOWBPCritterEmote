#BP Critter Emote

The addon in your addon file will say, "CritterEmote".

This addon will have your companion, AKA battle pet, pet do fun and random things in chat. This addon does not work for minions or hunter pets.

When you have a pet out it will emote something fun every 5 minutes or so as long as you aren't in combat.  If you desire them to emote something custom you can use /ce instead of /emote.

Your pets will also respond to in-game slash commands.  Try /wave while targetting your pet.

They might just do something different when you target another player or NPC.

If you would like to add your own emotes you can go into the CritterEmote file in addons and edit the default_special section in the CritterEmote_Emotes.lua You can also delete the emotes you just don't like. Unless you keep a copy for yourself, you will lose changes when the file is updated. You may want to make a list in notepad of deletions/additions for your own ease or save a copy of CritterEmote_Emotes.lua in the file as a copy. The copied lua should say "-Copy" (i.e. CritterEmote_Emote-Copy.Lua). You can then open the files in your favorite editor for ease of comparison and editing. (I use Visual Studio Code).

If you would like to see an emote added or deleted please send the request to me for review. 

Usage:
/ce - The base slash command followed by your request.
/ce <message>   - have your pet emote your <message>.
/ce info        - Displays the Welcome information including the version
/ce options     - Displays which tables are on using true as on and false as off
/ce help        - Displays this Help
/ce on          - Turns on BP Critter Emote        
/ce off         - Turns off BP Critter Emote (default is on)
/ce silly       - Toggles the silly emotes on/off
/ce special     - Toggles the special emotes on/off
/ce locations   - Toggles the location emotes on/off
/ce songs       - Toggles the song emotes on/off
/ce PVP         - Toggles the PVP emotes on/off
/ce normal      - Toggles the normal emotes on/off
/ce debug       - Turns on debugging
/ce debug off   - Turns off debugging


If you have any ideas for new emotes please let me know.

Currently emotes relate to the battle pet as follows:
Default - for all critters
type - subtype of critter ( cat )
name - specific pet ( Lil' K.T. )

In the addon there are 3 distinct areas:
emote - such as /cry or /wave
random Emotes - This is broken into 6 categories--General, Silly, Song, PVP, Special and Location
target - if something is targeted (including the pet), a random emote may be directed at the target.

CritterEmote was originally authored by Zompter as Critter Emote, then Seegeen as Chinchilla Critter Emote. I loved this add-on so much I just couldn't let it go. The abandoned addon guidelines required a rename for CurseForge, though it is still found under CritterEmote in the addon files.
Special thanks to Fysker for all his programming assistance. 
