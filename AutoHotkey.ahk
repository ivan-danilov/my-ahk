if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

EnvGet, HOME, HOME
FilePath = C:\__temp__.ahk

FileDelete, %FilePath% ; clear the file if exists

FileAppend,
(
if not A_IsAdmin
{
   Run *RunAs "`%A_ScriptFullPath`%"
   ExitApp
}

Run, %A_AhkPath% "%HOME%\AHK\MyRoot.ahk", %HOME%

FileDelete, %FilePath%

), %FilePath%

Run %A_AhkPath% "%FilePath%"