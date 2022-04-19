#If
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CustomColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s32  ; Set a large font size (32-point).
Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
Gui, Show, x0 y400 NoActivate  ; NoActivate avoids deactivating the currently active window.
return

UpdateOSD:
MouseGetPos, MouseX, MouseY
GuiControl,, MyText, X%MouseX%, Y%MouseY%
return


DofusClassName = ApolloRuntimeContentWindow

F1::			; press Space key to check
	if (A_Cursor = "Arrow")
		MsgBox Yes. Arrow
	else
		MsgBox % "No arrow: " A_cursor
	return

F2::
	MouseGetPos, xpos, ypos 
	ToolTip The cursor is at X%xpos% Y%ypos%.
	return

F3::
	WinGetActiveTitle, Title
	ToolTip Active Window:`t%Title%`
	return

F4::
	WinGetClass, class, A
	WinSet, Region,, ahk_class %class%
	return

F5::
	WinGetClass, class, A
	WinGetActiveStats, Title, Width, Height, X, Y
	WinSet, Region, 0-0 W%Width% H%Height% -50 R100-100, ahk_class %class%
	return

F6::
	WinGetClass, class, A
	MsgBox, The active window's class is "%class%".
	return

F7::
	ToolTip % A_Cursor
	return

F8::

	return

#If WinActive("ahk_class" DofusClassName)
	Up::
		WinGetClass, class, A
		WinGetActiveStats, Title, Width, Height, X, Y
		ShiftMouseClick(Width/2, 40)
		return

	Down::
		WinGetActiveStats, Title, Width, Height, X, Y
		ShiftMouseClick(Width/2, Height - Height/8)
		return
		
	Left::
		WinGetActiveStats, Title, Width, Height, X, Y
		ShiftMouseClick(Width/6, Height/2)
		return

	Right::
		WinGetActiveStats, Title, Width, Height, X, Y
		ShiftMouseClick(Width - Width/8, Height/2)
		return
#If


Esc::ExitApp


ShiftMouseClick(x, y)
{
	MouseGetPos, xinit, yini
	SendInput {LShift down}
	MouseMove, x, y
	Click
	Send, {LShift up}
	MouseMove, xinit, yini
	return
}

#t::  ; Press Win+T to make the color under the mouse cursor invisible.
	MouseGetPos, MouseX, MouseY, MouseWin
	PixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
	; It seems necessary to turn off any existing transparency first:
	WinSet, TransColor, Off, ahk_id %MouseWin%
	WinSet, TransColor, %MouseRGB% 220, ahk_id %MouseWin%
	return


^r:: ; press control+r to reload
	Reload
  	return

; Change volume if scrolling middle mouse on Windows task bar
#If MouseIsOver("ahk_class Shell_TrayWnd")
	WheelUp::Send {Volume_Up}
	WheelDown::Send {Volume_Down}

	MouseIsOver(WinTitle) {
	    MouseGetPos,,, Win
	    return WinExist(WinTitle . " ahk_id " . Win)
	}