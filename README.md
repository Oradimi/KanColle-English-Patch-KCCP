![English KanColle icon](https://raw.githubusercontent.com/Oradimi/KanColle-English-Patch-KCCP/master/EN-patch/kcs2/img/title/title_main.png/patched/title_main_004.png)
# KanColle English Patch
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C76IFME)
## Discord server
[Please join the English Patch Discord!](https://discord.gg/krMeMKB)
- Receive pings for polls and update notices about the patch (Ping Squad, optional)
- Receive pings for game updates, DMM festivals, and more! (Ping Squad+, optional)
- Detailed information to get into the game if you're new ([Tutorial Video, with the patch](https://www.youtube.com/watch?v=XjG6kRgm9qc))
- Advice and resources to learn how to play the game
- Most up-to-date instructions to install the patch
- People to talk about KanColle to, and links to more populated KanColle related servers

## Features
##### What it is
This patch is composed of translated textures to be used by the assets modifier of [KCCacheProxy](https://github.com/Tibowl/KCCacheProxy/wiki/Installation-and-setup).\
It also supports raw text patching, such as ship names, quests, flavor text etc.\
[Showcase in images](https://imgur.com/a/oAB9f7x) (Screenshots from v3.04a to v3.17.1)

##### How it works
Unlike other patching methods like MITM, POI's "My Cache" folder or ShimakazeGo's "Cache Mode hack",\
KCCacheProxy compares the original sprites with the sprites in sprite sheets,\
and injects the patched resources into these sprite sheets on the fly.\
That means patches using this method will not break after updates to the game.

##### English Patch specificities and disclaimer
This patch does not interfere with any of the files that communicate directly with the game servers.\
Everything that is altered by the patch is local: english textures will be stored locally on your PC,\
and raw text is patched just before it gets rendered on your screen.\
There is currently nothing within the KanColle client to detect such changes.\
Modifiying game assets is technically against the Terms of Service, so use at your own risk.

##### What is currently translated
A more detailed summary is in the works, but everything that is essential to comfortable gameplay,\
or that is very often seen in the game, is translated. This even includes event flavor text.

## Special Thanks

To Tibo for implementing new ways to patch the game's textures with KCCacheProxy,\
as well as for making some code specially to patch raw text in a stable way.\
To Dark Sentinel for contributing (LBAS menu aircraft names, world icons, server banners, and more).\
To Amelek for the chuuha/taiha cut-in texture jigsaw splitter.\
To Globalnet for the quick updater.\
To the EN wiki staff and the kc3 staff for providing a good part of the translations.

To all the others in the Discord server for regularly suggesting\
new things to fix or translate in the patch.

## Instructions
Please refer to the instructions in the #how-to-play-kc channel of the [Discord server](https://discord.gg/krMeMKB).\
Whether you are new or not, you can also check out the [video guide](https://www.youtube.com/watch?v=XjG6kRgm9qc)\
that covers everything you need to know.\
If you don't want to use the video, proceed with the instructions below.

##### Prerequisites

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
Go into your English Patch folder, and double-click on "quick_updater_v0.4.1".\
Let the program do its thing. Once done, you have the option to proceed to a program\
that will automatically clear your browser cache, so you don't have to do it manually.\
Clearing the browser cache is necessary to delete old or untranslated assets that are still stored.\
If you're not on Windows, you'll have to update the patch by reinstalling it or by using Git.

If you're using Git, pull from the repo, then open KCCacheProxy\
(right click in the task bar tray, bottom right), click on "Reload mod data",\
and clear your browser cache (see above for the Chrome cache clear instructions).\
You can also use the browser cache clearer provided in the English Patch folder if you're on Windows!

##### Additional note
*To disable raw text patching (ship names etc.), open the "EN-patch.mod.json" file\
and replace `"requireScripts": true,` with `"requireScripts": false,`.\
Don't forget to "Reload mod data"!*