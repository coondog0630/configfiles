set pluginFolder to do shell script "echo ~"
set pluginFolder to pluginFolder & "/Library/Application Support/SIMBL/Plugins"
do shell script "mkdir -p " & quoted form of pluginFolder

set pluginPath to POSIX path of (path to me)
set pluginPath to do shell script "dirname " & quoted form of pluginPath
set pluginPath to pluginPath & "/MouseTerm.bundle"
do shell script "cp -R " & quoted form of pluginPath & " " & quoted form of pluginFolder

display dialog "Installed into " & pluginFolder buttons {"OK"}
