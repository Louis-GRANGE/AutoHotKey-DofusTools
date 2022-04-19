F1::			; press Space key to check
	if (A_Cursor = "Arrow")
		MsgBox Yes. Arrow
	else
		MsgBox % "No arrow: " A_cursor
	return

F2::
	MouseGetPos, xpos, ypos 
	MsgBox, The cursor is at X%xpos% Y%ypos%.
	return

F3::
	WinGetActiveTitle, Title
	MsgBox, The active window is "%Title%".
	return

F4::
	WinGetActiveTitle, Title
	MsgBox, The active window is "%Title%" to "Dofus my Boys".
	WinWaitActive, Title, Dofus my Boys
	return


Up::
	ShiftMouseClick(960, 38)
	return

Down::
	ShiftMouseClick(960, 919)
	return
	
Left::
	ShiftMouseClick(350, 540)
	return

Right::
	ShiftMouseClick(1575, 540)
	return

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