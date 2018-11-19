#
WoW Addon BP Critter Emote

Originally authored by Zompter, then Seegeen, I loved this add-on so much I just couldn't let it go.  The add-on guidelines required a rename. 

This addon will have your non-combat pets do fun and random things. 

When you have a pet out it will emote something fun every 5 minutes or so as long as you aren't in combat.  If you desire them to emote something custom you can use /ce instead of /emote.

Your pets will also now respond to in-game interaction.  Try /wave while targetting your pet.

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

Version 1.14b
Addition of new pets. General Emote updates.

Version 1.14a
Fixed bug that caused addon to continuously emote

Version 1.14
Updated to Battle for Azeroth
Please note that I am working on toggles for Faction and turning on and off the Song, Location, Seasonal, and Silly emotes.  

Version 1.13a
Updated to latest Legion patch (not published)

Version 1.13
Updated to Legion
Included updates from Acidfrost59
Big thanks to Acidfrost59 for adding many more emotes and fixing some minor issues!

Version 1.11a
Fixed some typos's added user requested emotes.

Version 1.11
Works with 6.2

Version 1.10a
One can now just turn off/on random emotes via: /ce random_off or /ce random_on
Fixed Typos

Version 1.10
Works with 6.1.0

Version 1.9b/c/d
Fixed typos

Version 1.9a
Invaded by the old ones!
(more emotes)

Version 1.9
More emotes! (and corrections)

Version 1.8a
Now respects custom pet names.

Version 1.8
Works with 6.0
Back again Chin is back Tell a friend

Version 1.7b
Works with 5.2.0

Version 1.7a
Fixed a bug where Critter Emote would crash if no pet was out.

Version 1.7
Updated to MoP!
Big Thanks to Liz.

Version 1.6
Updated by Jî - Sylvanas
Big Thanks!
Spellchecked (might have missed a few, but did alot) added all currents pets into the roster. Gave lil' ragnaros and gregarious grell quite alot of custom emotes.

Version 1.5b
Updated for 4.3 version of the game.

Version 1.5a
Updated for 4.1 version of the game.

Version 1.5
Rewrite of Emote Database.  This makes it easier to add new types without having the file size grow too large.  Also speeds things up slightly.
Added a lot more responsive emotes.

Version 1.4
Snake type creatures now have a full personality
Now remembers your state between sessions
Emotes now have a category.  This way you can turn on and off certain types of emotes.
silly, locations, jokes, songs
/ce help for more info on this.

Version 1.3
cat type creatures now have a full personality
Fixed a bug where pet types and names were not correctly being called in the table.

Version 1.2
Added more emotes.
Fixed typos
Random interval time is longer.

Version 1.1
Added additional emotes.
Removed some debugging info.
Now seed the random a bit better.

Version 1.0
Initial Version
