# KanColle English Patch [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C76IFME)
## [Instructions](https://docs.google.com/document/d/1S3-Uv9wbuv2lAkjc_5oH6T069rb7QlTP90W2AHoNPzg/edit?usp=sharing)

<img src="https://raw.githubusercontent.com/Oradimi/KanColle-English-Patch-KCCP/master/EN-patch/kcs2/img/title/title_main.png/patched/title_main_004.png"
  align="right" alt="English KanColle icon" width="300">

This link above redirects to a document that contains everything you need to get everything working,
whether it be as a new player, as a returning or active player, on PC, Mac, Linux or Android.
It also contains some useful resources for the game itself, and an early walkthrough if you feel lost.
## [Discord server](https://discord.gg/krMeMKB)
- Over 2,300 members and growing!
- Need help with installing the game or figuring out mechanics? We may be able to help!
- Want to explore the other existing KanColle Discords? You can find links in a channel!
- Receive pings for polls and update notices about the patch with the Ping Squad role.
- Receive pings for game updates, and all the other news with the Ping Squad+ role.

## Features
##### What it is
This patch is composed of translated textures to be used by the assets modifier of [KCCacheProxy](https://github.com/Tibowl/KCCacheProxy/wiki/Installation-and-setup).\
It also supports raw text patching, such as ship names, quests, flavor text etc.\
[Showcase in images](https://imgur.com/a/oAB9f7x) (Screenshots from v3.17.1 to v3.22.1)

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
Currently, everything that is essential to comfortable gameplay,\
or that is very often seen in the game, is translated. This even includes event flavor text.

##### English Patch Manager
The quick updater lets you easily update the patch\
without resorting to installing git. It also clears the browser cache for you!\
It is now also possible to launch "_enable_update_checker.bat" to be\
immediately notified of a patch update upon launching your PC!\
You can disable it at any time.

## Special Thanks
To Tibo for implementing new ways to patch the game's textures with KCCacheProxy,\
as well as for making some code specially to patch raw text in a stable way.\
To Dark Sentinel for contributing (LBAS menu aircraft names, world icons, server banners, and more).\
To Amelek for the chuuha/taiha cut-in texture jigsaw splitter.\
To Globalnet for the quick updater, and for general technical help.\
To the EN wiki staff and the kc3 staff for freely providing a good part of the translations.\
To all the others in the Discord server for regularly suggesting new things to fix or translate in the patch.
