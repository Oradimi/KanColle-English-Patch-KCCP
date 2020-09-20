# KanColle English Patch
![](https://i.imgur.com/kYiiHRo.png)

[Join the Update Notice Discord!](https://discord.gg/krMeMKB)

Translated textures to be used by the assets modifier of [KCCacheProxy](https://github.com/Tibowl/KCCacheProxy/wiki/Installation-and-setup).
Now also supports raw text patching, such as ship names etc. *(v3.XX)*
It's enabled by default. To disable raw text patching, follow the instructions below.

Use at your own risk, make sure to clear your cache when installing/updating.
Unlike the POI method, the assets don't break when updates happen in the game.
No ban risk as the API is never touched.

## Instructions
Download the master and extract it anywhere, then use KCCP (right click in the tray)
to add the mod by checking "Enable assets modifier", saving, then clicking on "Add a patcher".
From there, select the "EN-patch.mod.json" file inside of the master folder.
To disable raw text patching (ship names etc.), open the "EN-patch.mod.json"
file and replace ("requireScripts": true,) with ("requireScripts": false,).