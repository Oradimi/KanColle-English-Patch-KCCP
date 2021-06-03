![English KanColle icon](https://i.imgur.com/kYiiHRo.png)
# KanColle English Patch
## Discord server
[Please join the English Patch Discord!](https://discord.gg/krMeMKB)
- Receive pings for polls and update notices about the patch (optional)
- Detailed information to get into the game if you're new
- Advice and resources to learn how to play the game (wip)
- Most up-to-date instructions to install the patch
- People to talk about KanColle to, and links to more populated KanColle related servers

## Features
##### What it is
This patch is composed of translated textures to be used by the assets modifier of [KCCacheProxy](https://github.com/Tibowl/KCCacheProxy/wiki/Installation-and-setup).\
It also supports raw text patching, such as ship names, quests, flavor text etc.
[Showcase in images](https://imgur.com/a/oAB9f7x) (Screenshots from v3.04-3.05)

##### How it works
Unlike other patching methods like MITM, POI's "My Cache" folder or ShimakazeGo's "Cache Mode hack",\
KCCacheProxy compares the original sprites with the sprites in sprite sheets,\
and injects the patched resources into these sprite sheets on the fly.\
That means patches using this method will not break after updates to the game.\

##### English Patch specificities and disclaimer
This patch does not interfere with any of the files that communicate directly with the game servers.\
Everything that is altered by the patch is local: english textures will be stored locally on your PC,\
and raw text is patched just before it gets rendered on your screen.\
There is currently nothing within the KanColle client to detect such changes.\
Modifiying game assets is technically still against the Terms of Service, so use at your own risk.

##### What is currently translated
A more detailed summary is in the works, but everything that is essential to comfortable gameplay,\
or that is very often seen in the game, is translated. It is still a WIP, so anything can change.

## Special Thanks

To Tibo for implementing new ways to patch the game's textures with KCCacheProxy,\
as well as for making some code specially to patch raw text in a stable way.\
To Dark Sentinel for contributing (LBAS menu aircraft names, world icons, server banners, and more).\
To Amelek for the chuuha/taiha cut-in texture jigsaw splitter.\
To Globalnet for the quick updater.\
To the EN wiki staff and the kc3 staff for providing a good part of the translations.

To atikabubu, Althea, Dotsidious, TerminaHeart, LeftistTachyon\
and all the others in the Discord server for regularly suggesting\
new things to fix or translate in the patch.

## Instructions
*(Please refer to the instructions in the #how-to-play-kc channel of the* *[Discord server](https://discord.gg/krMeMKB)* *instead if you're new to the game)*

You need KCCacheProxy set up to install this mod!\
Get into the Discord server, or follow this guide below to install it. I recommend going with Option B.\
https://github.com/planetarian/KCDocumentation/blob/master/KCCacheProxy.md

##### Installation
Once KCCacheProxy is set up, download the master (green button, download the zip), and extract it anywhere.\
*If you're using Git, simply clone the repository of the patch on your computer using your preferred version of Git.*

Use KCCacheProxy (right click in the task bar tray, bottom right) to add the mod\
by checking "Enable assets modifier", saving, then clicking on "Add a patcher".\
From there, select the "EN-patch.mod.json" file inside of the master folder.

If you've downloaded the full cache dump, you can additionally click\
on "Pre-patch ALL assets" to make the game faster.\
Be sure to wait for everything to be done.

*Cache Clear*\
If it is running, close KanColle, and clear your browser's cache.\
Be sure to select all time cache rather than last hour, and only select the relevant option.\
*On Chrome, hit Ctrl+Shift+Del, choose "All time" on "Period", and in the "General" tab,\
check **only** "Images and files in cache", and delete.*\
If some assets still aren't patched, repeat the process until satisfaction. You're done!

##### Updating
Go into your English Patch folder, and double-click on "quick_updater_v0.2.1".\
Let the program do its thing, then close it.\
*If you're using Git, just pull from the repo.*

Open KCCacheProxy (right click in the task bar tray, bottom right), click on "Reload mod data",\
and clear your browser cache (see above for the cache clear instructions).

##### Additional note
*To disable raw text patching (ship names etc.), open the "EN-patch.mod.json" file\
and replace `"requireScripts": true,` with `"requireScripts": false,`.\
Don't forget to "Reload mod data"!*