; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.


;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.
#Include WindowInfo.ahk
#Include WindowMacro.ahk
#Include Menu.ahk
#Include Drawing.ahk
#Include Vector.ahk

#Include Library/INIMacro.ahk

OutputDebug("[Init] Program start`n")

; Init Update Function
SetTimer UpdateOSD, 100

; VARIABLES
DofusClassName := "ApolloRuntimeContentWindow"
WINDOWS := []

; ======================= STATIC Class =====================
GUIInfo("NEWGUI1", 0, true)
GUIInfo("NEWGUI2", 0, false)
WindowMacro := GUIMacro(,1,false)


CustomMenu(WINDOWS[3], WINDOWS) ;ADD menu on all active windows

UpdateOSD()
{
	For GuiWin in WINDOWS
		;if(GuiWin.TickEnable)
			;GuiWin.Update()
	return
}
;Hotstring "::btw", "by the way"

F1::
{
	For GuiWin in WINDOWS
		if(GuiWin.TickSpeed != 0)
			GuiWin.SetTick(0)
		else
			GuiWin.SetTick(10)
	return
}

F2::
{
	WindowMacro.GUICreateEditMacro.SendMacro()
	return
}

F3::
{
	WindowMacro.GUICreateEditMacro.DisplayMouseWay(!WindowMacro.GUICreateEditMacro.IsDisplayMouseWay)
	return
}

F4::
{
	return
}

F5::
{
	WinClass := WinGetClass("A")
	WinGetPos &X, &Y, &W, &H, "A"
	WinSetRegion "0-0 W" W-10 " H" H-10 " R40-40", "ahk_class " WinClass
	return
}

F6::
{
	Y := 0
	SearchTreeRecursively(Y)
}

F7::
{
	ToolTip A_Cursor
	SetTimer () => ToolTip(), -5000
	return
}

F8::
{
	MouseGetPos &MouseX, &MouseY
	color := PixelGetColor(MouseX, MouseY)
	ToolTip "The color is " color "."
	SetTimer () => ToolTip(), -5000
	return
}

F9::
{
	if PixelSearch(&Px, &Py, 0, 0, 1920, 1080, 0x94C129, 3)
    	MsgBox "A color within 3 shades of variation was found at X" Px " Y" Py
	else
    	MsgBox "That color was not found in the specified region."
    return
}

F10::
{
	;MyGUIWindow.Push(GUIWindow("NEWGUI" . MyGUIWindow.Length)) ; TO ADD NEW GUI
	WINDOWS[1].ToggleView()
	return
}

#HotIf WinActive("ahk_class" DofusClassName)
	Up::
	{
		WinGetPos &X, &Y, &W, &H
		ShiftMouseClick(W/2, 40)
		return
	}

	Down::
	{
		WinGetPos &X, &Y, &W, &H
		ShiftMouseClick(W/2, H - H/8)
		return
	}

	Left::
	{
		WinGetPos &X, &Y, &W, &H
		ShiftMouseClick(W/6, H/2)
		return
	}

	Right::
	{
		WinGetPos &X, &Y, &W, &H
		ShiftMouseClick(W - W/8, H/2)
		return
	}
#HotIf


Esc::ExitApp


ShiftMouseClick(x, y)
{
	MouseGetPos &xinit, &yini
	SendInput "{LShift down}"
	MouseMove x, y
	Click
	Send "{LShift up}"
	MouseMove xinit, yini
	return
}

#t::  ; Press Win+T to make the color under the mouse cursor invisible.
{
	MouseGetPos &MouseX, &MouseY
	;MouseRGB := PixelGetColor(MouseX, MouseY)
	; It seems necessary to turn off any existing transparency first:
	;WinSetTransColor "Off", "ahk_id" MouseWin
	;WinSetTransColor MouseRGB 220, "ahk_id" MouseWin
	return
}


^r:: ; press control+r to reload
{
	Reload
  	return
}

; Change volume if scrolling middle mouse on Windows task bar
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
{
	WheelUp::Send "{Volume_Up}"
	WheelDown::Send "{Volume_Down}"

	MouseIsOver(WinTitle) {
	    ;MouseGetPos ,,, Win
	    ;return WinExist(WinTitle . " ahk_id " . Win)
	}
}

SearchTreeRecursively(Y)
{
;	try
;	{
		tmpY := SearchOne(Y)
		if(tmpY != -1)
		{
			SearchTreeRecursively(tmpY)
			; MsgBox("Found one at " tmpY)
		}
		Else
		{
			MsgBox("No more found after " tmpY)
			Y := 0
		}
;	}
	;catch as exc
;		ToolTip("Prblm" exc)
}

SearchOne(Y)
{
	if ImageSearch(&FoundX, &FoundY, 0, Y, A_ScreenWidth, A_ScreenHeight, "*48 " A_ScriptDir "\Ressources\Treev2.png")
	{
		;MouseMove(FoundX, FoundY)
		ShiftMouseClick(FoundX, FoundY)
		Sleep(100)
		Return FoundY + 10
	}
	else
	{
		Return -1
	}

}

SearchColor(MyColor)
{
	WinGetPos &X, &Y, &W, &H, "A"
	if PixelSearch(&Px, &Py, 0, 0, W, H, MyColor, 0) ;MyColor have to look like 0x989F92
	{
    	ToolTip "A color within 3 shades of variation was found at X" Px " Y" Py
    	MouseMove Px, Py
	}
	else
	{
    	ToolTip "That color was not found in the specified region."
	}
	SetTimer () => ToolTip(), -5000
}