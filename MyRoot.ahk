#SingleInstance force

#include %A_ScriptDir%\Switcher.ahk

SetTitleMatchMode, RegEx
DetectHiddenWindows, off
return

SendInputAndActivate(input, winToActivate)
{
	SendInput, %input%
	WinWait, %winToActivate%,,3
	SetTitleMatchMode, RegEx
	if (ErrorLevel=0) 
	{
		WinActivate
	}
}

FixString(input)
{
	StringReplace, input, input, :, {shift down}{sc027}{shift up}, All
	StringReplace, input, input, /, {sc035}, All
	StringReplace, input, input, ., {sc034}, All
	return input
}

#IfWinActive MINGW32:
!s::SendInput git status{enter}
!a::SendInputAndActivate(FixString("TortoiseGitProc.exe /command:log /path:. &{enter}"), "Log Messages - ")
!b::SendInputAndActivate(FixString("TortoiseGitProc.exe /command:log /path:UI &{enter}"), "Log Messages - ")
!c::SendInputAndActivate("gitex commit{enter}", "Commit - ")
!d::SendInput git reset --hard{space}
!r::SendInput rcheckin{enter}
!f::SendInput git fetch --prune{enter}
!q::SendInput git stash --include-untracked{enter}
!+q::SendInput git stash{enter}
!^q::SendInput git stash --keep-index --include-untracked{enter}
!w::SendInput % FixString("git rebase origin/tfs/dev{enter}")
!e::SendInput git stash pop{enter}
!i::SendInput % FixString("git rebase -i --autosquash origin/tfs/dev{enter}")
!p::SendInput git push{enter}
#IfWinActive

#IfWinActive Credential Input
!q::SendInput idanilov\csm{Tab}B@ckd00r{Enter}{Enter}
#IfWinActive

#+`::
	ListLines  ; Show the script's main window.
	WinWaitActive ahk_class AutoHotkey
	Send {LCtrl down}{Shift}{LCtrl up}  ; Switch to alternate language (keys must be in this format).
	WinMinimize
return

#r::
	IfWinExist, Run ahk_class #32770
	{
		WinActivate
		return
	}
	Run *RunAs rundll32.exe shell32.dll`,#61
	WinWait, Run ahk_class #32770
	WinActivate
return

^!#r::Edit
^!#e::Run *RunAs d:\Programs\emacs-24.3\bin\runemacs.exe
^!#c::
	Runwait, taskkill /im cntlm.exe /f,, Hide
	Run, net start cntlm,, Hide
return

#IfWinActive MyRoot.ahk - Notepad
!s::
	SendInput {LCtrl down}s{LCtrl up}
	Reload
return
#IfWinActive