#Include GUIWindow.ahk
#Include WindowEditingKey.ahk

Class GUIMacro extends GUIWindow
{
	__New(Title := "Macro", TickSpeed := 0, IsVisible := true) ;Construtor
	{
		this.Macro := []
		this.detectKeyboard := true
		this.detectMouse := false
		this.StartTime := A_TickCount
		this.ListeningInput := false

        super.__New(Title, TickSpeed, IsVisible)

		this.Opt("+lastfound +alwaysontop -caption +toolwindow +resize")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		this.Show("w290 h625")
		
		this.SetFont("s32")  ; Set a large font size (32-point).
		this.Add("Text", "VMyText CLime", "Macro")

		this.SetFont("s10")
		this.TImportant := this.Add("Text", "x10 y80 W2000 Cff0000 Hidden", "Listening...")
		this.LVKeysAction := this.Add("ListView","x10 y100 NoSort -ReadOnly -WantF2 +Report r20 w200",["Name","State","Time (en s)"])

		; Notify the script whenever the user double clicks a row:
		this.LV_DoubleClickFunc := (LV, RowNumber) => this.LV_DoubleClick(LV, RowNumber)
		this.LVKeysAction.OnEvent("DoubleClick", this.LV_DoubleClickFunc)

		; Start Listen Inputs Button
        this.BtnListen := this.Add("Button", "x50 y550 Default w80", "Start")
        this.BtnListen_ClickFunc := (GuiCtrlObj, n) => this.BtnListen_Click(GuiCtrlObj, n) ; Callback Btn
        this.BtnListen.OnEvent("Click", this.BtnListen_ClickFunc) ; Call BtnOK_ClickFunc when clicked.

		this.BackColor := "3A3635"
		

		this.ListeningTextEditFunc := () => this.ListeningTextEdit()
	}

	ListeningTextEdit()
	{
		if(this.TImportant.text == "Listening...")
			this.TImportant.text := "Listening"
		if(this.TImportant.text == "Listening..")
			this.TImportant.text := "Listening..."
		if(this.TImportant.text == "Listening.")
			this.TImportant.text := "Listening.."
		if(this.TImportant.text == "Listening")
			this.TImportant.text := "Listening."
	}

	Update()
	{
		if(this.ListeningInput)
			this.CheckKeyDown()
	}

	CheckKeyDown()
	{
		key := this.AnyKeyIsDown(this.detectKeyboard, this.detectMouse)
		if (key)
		{
			this.AddKey(key, A_TickCount - this.StartTime)
		}
	}

	AnyKeyIsDown(detectKeyboard:=1,detectMouse:=1)
	{ ; return whatever key is down that has the largest scan code
		if (detectKeyboard) {
			loop 84
			{ ; detect all common physical keys: https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
				keyname:=GetKeyName("sc" Format("{1:x}",A_Index))
				;MsgBox(keyname)
				if (GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 0)
				{
					return {Name: keyname, State: 1} ; KEY DOWN
				}
				else
				{
					if(!GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 1)
					{
						return {Name: keyname, State: 0} ; KEY UP
					}
				}
			}
		}
		if (detectMouse)
		{
			mouseArr := ["LButton","RButton","MButton","XButton1","XButton2"]
			loop mouseArr.Length {
				keyname := mouseArr[A_Index]
				if (GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 0) {
					return {Name: mouseArr[A_Index], State: 1}
				}
				else
				{
					if(!GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 1)
					{
						return {Name: keyname, State: 0}
					}
				}
			}
		}
		return false
	}

	GetLastStateOfKey(keyname)
	{
		if(this.Macro.Length == 0)
			return 0
		loop this.Macro.Length
		{
			index := this.Macro.Length - 1 * A_Index + 1
			key := this.Macro[index]

			if(key.Name == keyname)
			{
				return key.State
			}
		}
		return 0
	}

	EditKeyAtRow(RowNumber, Name, State, AtTime)
	{
		this.Macro[RowNumber].Name := Name
        this.Macro[RowNumber].AtTime := AtTime
        this.Macro[RowNumber].State := State

        this.LVKeysAction.Modify(RowNumber,, Name, (State == 0 ? "Up" : "Down"), AtTime)
	}

	AddKey(key, atTime)
	{
		this.Macro.Push({Name: key.Name, State: key.State, AtTime: atTime})
		this.LVKeysAction.Add(, key.Name, (key.State == 0 ? "Up" : "Down"), atTime/1000)
	}

	; CALLBACKS
	;List View for Editing
	LV_DoubleClick(LV, RowNumber)
	{
		GUIEditingKey(this, LV, RowNumber)
	}
	;Listen Btn
	BtnListen_Click(GuiCtrlObj, n)
    {
        this.ListeningInput := !this.ListeningInput
		this.StartTime := A_TickCount

		GuiCtrlObj.Text := (this.ListeningInput ? "Stop" : "Start")
		if(this.ListeningInput)
			this.TImportant.Visible := 1
		else
			this.TImportant.Visible := 0
		SetTimer(this.ListeningTextEditFunc, (this.ListeningInput ? 200 : 0))
    }


	SendMacro()
	{
		this.StartTime := A_TickCount
		index := 1

		while(index < this.Macro.Length)
		{
			if(A_TickCount - this.StartTime > this.Macro[index].AtTime)
			{
				Send "{"  this.Macro[index].Name (this.Macro[index].State == 0 ? " up" : " down") "}"
				index := index + 1
			}
		}
	}
}