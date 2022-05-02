#Include GUIWindow.ahk

Class GUIInfo extends GUIWindow
{
	__New(Title := "Untitled - AhkPad", TickSpeed := 0, IsVisible := true) ;Construtor
	{
        super.__New(Title, TickSpeed, IsVisible)
		this.BackColor := "EEAA99"
		this.Opt("+lastfound +alwaysontop -caption +toolwindow +resize")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		
		this.SetFont("s32")  ; Set a large font size (32-point).
		this.MousePos := this.Add("Text", "VMyText CLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
		
		this.SetFont("s20")
		this.DataTitle := this.Add("Text", "W2000 CLime", "XXXXX YYYYY")
		this.DataClass := this.Add("Text", "W2000 CLime", "XXXXX YYYYY")
		this.DataWindowPosSize := this.Add("Text", "W2000 CLime", "XXXXX YYYYY")
		; Make all pixels of this color transparent and make the text itself translucent (150):
		;this.CustomColor := "EEAA99"
		;WinSetTransColor(CustomColor, "200", this.GUI)

		this.ShowColorCursor := this.Add("Progress", "x350 y30 w38 h38", "100")
		this.ShowColorOffsetCursor := this.Add("Progress", "x390 y30 w38 h38", "100")

		this.BackColor := "3A3635"
		this.SetTick(10)
		;if(this.IsVisible)
	;		this.Show("AutoSize Center")  ; NoActivate avoids deactivating the currently active window.

	}

	Update()
	{
		MouseGetPos &MouseX, &MouseY, &id, &control
		Title := WinGetTitle(id)
		MyClass := WinGetClass(id)
		WinGetPos &X, &Y, &W, &H, id
		PixColor := PixelGetColor(MouseX, MouseY)
		this.ShowColorCursor.Opt("c" PixColor)

		PixColorOffset := PixelGetColor(MouseX + 20, MouseY + 15)
		this.ShowColorOffsetCursor.Opt("c" PixColorOffset)

		; MsgBox "Pos X" MouseX " Y" MouseY
		this.MousePos.Value := "X" MouseX " Y" MouseY
		this.DataTitle.Value := "Title: " Title
		this.DataClass.Value := "Class: " MyClass
		this.DataWindowPosSize.Value := "Position: " X " " Y " | Size: " W "x" H
	}


}
/*
On_WM_LBUTTONDOWN(wParam,lParam,msg,hwnd){
    PostMessage 0xA1, 2
}*/