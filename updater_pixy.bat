@ECHO OFF

TITLE KanColle English Patch Updater ver. Pixy
WHERE git
IF %ERRORLEVEL% NEQ 0 GOTO CommandNotFound
git pull -f origin master

GOTO UpdaterEnd
:CommandNotFound
ECHO "Git wasn't found on this system."
ECHO "Please install from https://git-scm.com/download/win ."
ECHO "Follow the installation instructions and use all default settings."
:UpdaterEnd
PAUSE