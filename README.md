#
WoW Addon BP Critter Emote

The addon in your file will say, "CritterEmote".

This addon will have your non-combat pets do fun and random things. 

When you have a pet out it will emote something fun every 5 minutes or so as long as you aren't in combat.  If you desire them to emote something custom you can use /ce instead of /emote.

Your pets will also respond to in-game interaction.  Try /wave while targetting your pet.

They might just do something different when you target another player or NPC.

If you would like to add your own emotes you can go into the CritterEmote file in addons and edit the file CritterEmote_Emotes.lua You can also delete the emotes you just don't like. Keep in mind that when you modify the file, you will need to remodify the file when it is updated. You may want to make a list in notepad of deletions/additions for your own ease or save a copy of CritterEmote_Emotes.lua in the file. The copied lua should say "-Copy" at the end of the file (i.e. CritterEmote_Emote-Copy.Lua). You can then open the files in your favorite editor for ease of comparison and editing. (I use Visual Studio Code).

If you would like to see an emote added or deleted please send the request to me for review. 

Usage:
/ce - have your pet perform a random emote.
/ce <message> - have your pet emote your <message>.
/ce [options] - perform the various option:
[options] =
info  : displays Critter Emote information.
help  : displays this help.
off   : turns the random emote off.
on    : turns the random emotes back on.

If you have any ideas for new emotes please let me know.
Currently emotes can be in the following category:

Default - for all critters
type - subtype of critter ( cat )
name - specific pet ( Lil' K.T. )

Under each category there is 
emote - such as /cry or /wave
random - anything
target - if something is targeted

CritterEmote was originally authored by Zompter, then Seegeen, I loved this add-on so much I just couldn't let it go.  The add-on guidelines required a rename for CurseForge, though it is still found under CritterEmote.