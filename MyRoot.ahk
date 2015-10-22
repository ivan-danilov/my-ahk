#SingleInstance force

SetTitleMatchMode, RegEx
DetectHiddenWindows, off

;#include %A_ScriptDir%\Switcher.ahk
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
	if WinActive("ahk_class mintty")
		return input
	StringReplace, input, input, :, {shift down}{sc027}{shift up}, All
	StringReplace, input, input, /, {sc035}, All
	StringReplace, input, input, ., {sc034}, All
	StringReplace, input, input, ^, {shift down}{sc007}{shift up}, All
	return input
}
;!+q::
;  textToProcess := GetSelectedText()
;  textToPresent := GetTranslated(textToProcess)
;  if ( StrLen(textToPresent) > 0 )
;    ReplaceSelectedText(textToPresent)
;  Send {Ctrl Down}{LShift}{Ctrl Up}
;return

;!+w::
;  ShowTranslatedText(GetTranslated(GetSelectedText()))
;return

#IfWinActive MINGW(32|64):/.*/ets$
!w::SendInput % FixString("git rebase origin/tfs/dev{enter}")
!i::SendInput % FixString("git rebase -i --autosquash origin/tfs/dev{enter}")
!r::SendInput % FixString("./rcheckin{enter}")
!b::SendInput % FixString("./qbuild{enter}")
!+d::SendInput % FixString("git reset --hard origin/tfs/dev{enter}")
#IfWinActive

#IfWinActive MINGW(32|64):/.*/ets-cimems$
!w::SendInput % FixString("git rebase origin/tfs/dev{enter}")
!i::SendInput % FixString("git rebase -i --autosquash origin/tfs/dev{enter}")
!r::SendInput git tfs bootstrap{enter}git tfs rcheckin -i dev{enter}
#IfWinActive

#IfWinActive MINGW(32|64):/.*/ets-psr($|/)
!f::SendInput git svn fetch{enter}
!r::SendInput git svn dcommit{enter}
!w::SendInput git rebase git-svn{enter}
!i::SendInput git rebase -i --autosquash git-svn{enter}
!d::SendInput git reset --hard git-svn
#IfWinActive

#IfWinActive MINGW(32|64):
!s::SendInput git status{enter}
!a::SendInputAndActivate(FixString("TortoiseGitProc.exe /command:log /path:. &{enter}"), "Log Messages - ")
!c::SendInputAndActivate("gitex commit{enter}", "Commit - ")
!d::SendInput git reset --hard{space}
!f::SendInput git fetch --prune{enter}
!q::SendInput git stash --include-untracked{enter}
!+q::SendInput git stash{enter}
!^q::SendInput git stash --keep-index --include-untracked{enter}
!w::SendInput % FixString("git rebase origin/master{enter}")
!i::SendInput % FixString("git rebase -i --autosquash origin/master{enter}")
!e::SendInput git stash pop{enter}
!p::SendInput git push{enter}
!BS::SendInput % FixString("git reset @^{enter}")
!+BS::SendInput git reset --hard @^{enter}
#IfWinActive

; APF window
#IfWinActive Credential Input
!q::
	SendInput idanilov\csm{Tab}B@ckd00r
	Sleep 200
	SendInput {Enter}
	WinWait, Console - Applications -, , 8
	WinGet ConsoleHwnd
	if ErrorLevel
	{
		return
	}
	WinActivate
	Sleep 100
	CoordMode Mouse, Relative
	Click 445, 176, 2
	WinWait, e-terrasource, , 5
	if (ErrorLevel = 0)
	{
		WinActivate
		Sleep 300
		CoordMode Mouse, Relative
		Click 176, 260
	}
	WinWait, e-terrasource - A - APF - , , 120
	WinClose, ahk_id %ConsoleHwnd%
return
!+q::  ; just type in the credentials
	SendInput idanilov\csm{Tab}B@ckd00r
	Sleep 200
	SendInput {Enter}
return
#IfWinActive

#IfWinActive Windows Security
!q::SendInput localhost\csm{Tab}B@ckd00r{Enter}
#IfWinActive

#IfWinActive NMSproject - Mozilla Firefox
^#c::SendInput % "{{}noformat:wrap=nowrap{}}{{}noformat{}}{Ctrl Down}{Left}{Ctrl Up}{Left}"
#IfWinActive

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