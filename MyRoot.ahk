#SingleInstance force

SetTitleMatchMode, RegEx
DetectHiddenWindows, off

#include %A_ScriptDir%\Switcher.ahk
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

!+q::
  textToProcess := GetSelectedText()
  textToPresent := GetTranslated(textToProcess)
  if ( StrLen(textToPresent) > 0 )
    ReplaceSelectedText(textToPresent)
  Send {Ctrl Down}{LShift}{Ctrl Up}
return

!+w::
  ShowTranslatedText(GetTranslated(GetSelectedText()))
return

#IfWinActive MINGW32:/.*/ets$
!w::SendInput % FixString("git rebase origin/tfs/dev{enter}")
!i::SendInput % FixString("git rebase -i --autosquash origin/tfs/dev{enter}")
#IfWinActive

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
!w::SendInput % FixString("git rebase origin/master{enter}")
!i::SendInput % FixString("git rebase -i --autosquash origin/master{enter}")
!e::SendInput git stash pop{enter}
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

#IfWinActive MyRoot ahk_class Notepad
!s::
	SendInput {LCtrl down}s{LCtrl up}
	Reload
return
#IfWinActive