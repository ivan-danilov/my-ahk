#SingleInstance force ; Replace running script silently

TranslateNone = 0
TranslateEngToRus = 1
TranslateRusToEng = 2

LongMessageLength = 100 ; replace ToolTip with MessageBox for long messages
ShortMessageTooltipTimeout = 3000

; doesn't work for associative arrays, so fuck it
; works for InStr(), unfuck it
StringCaseSense, On

; my local strange keyboard
engSymbols := "``qwertyuiop[]asdfghjkl;'zxcvbnm,./~@#$%^&QWERTYUIOP{}ASDFGHJKL:""|ZXCVBNM<>?"
rusSymbols := "ёйцукенгшщзхъфывапролджэячсмитьбю.Ё""№;%:?ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,"

; if engSymbols.Length() != rusSymbols.Length()
; then you.IntelligenceLevel := Imbecile

GetSelectedText()
{
  clipSaved := clipboardAll
  Send {Ctrl Down}{sc02E}{Ctrl Up}
  textToProcess := clipboard
  clipboard := clipSaved
  clipSaved =
  return %textToProcess%
}

ReplaceSelectedText(textToPresent)
{
  clipSaved := clipboardAll
  clipboard := textToPresent
  Send {CtrlDown}{sc02F}{CtrlUp}
  clipboard := clipSaved
  clipSaved =
}

ShowTranslatedText(textToPresent)
{
  global LongMessageLength
  global ShortMessageTooltipTimeout
  if ( StrLen(textToPresent) >= LongMessageLength ) {
    MsgBox % textToPresent
  } else {
    if ( A_CaretX > 0 and A_CaretY > 0 ) {
      ToolTip , %textToPresent% , A_CaretX, A_CaretY
	} else {
	  MouseGetPos, mouseX, mouseY
      ToolTip , %textToPresent% , mouseX, mouseY
	}
	SetTimer, RemoveToolTip, %ShortMessageTooltipTimeout%
  }
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

GetTranslated(str)
{
  global TranslateNone
  global TranslateEngToRus
  global TranslateRusToEng
  global engSymbols
  global rusSymbols

  translation := GetTranslation(str)
  if ( translation = TranslateNone )
    return
  if ( translation = TranslateEngToRus ) {
    replaceFrom := engSymbols
	replaceTo := rusSymbols
  }
  if ( translation = TranslateRusToEng ) {
    replaceFrom := rusSymbols
	replaceTo := engSymbols
  }
  result =
  loop % StrLen(str)
  {
    actualChar := SubStr(str, a_index, 1)
	charIndex := InStr(replaceFrom, actualChar, true)
;	if ( SubStr(replaceFrom, charIndex, 1) != actualChar )
;	  charIndex := InStr(replaceFrom, actualChar, true, 2)
    if ( charIndex > 0 ) {
	  result := result . SubStr(replaceTo, charIndex, 1)
	} else {
	  result := result . actualChar
	}
  }
  return %result%
}

GetTranslation(str)
{
  global TranslateNone
  global TranslateEngToRus
  global TranslateRusToEng
  global engSymbols
  global rusSymbols

  loop % StrLen(str)
  {
    actualChar := SubStr(str, a_index, 1)
    isEngToRus := InStr(engSymbols, actualChar)
	isRusToEng := InStr(rusSymbols, actualChar)
	if ( isEngToRus and not isRusToEng )
	  return TranslateEngToRus
	if ( isRusToEng and not isEngToRus )
	  return TranslateRusToEng
  }
  return TranslateNone
}