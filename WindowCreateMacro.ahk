#Include WindowEditingKey.ahk
#Include Vector.ahk

Class GUICreateMacro
{
	__New(GUIparent := "") ;Construtor
	{
		this.GUIparent := GUIparent
		this.Keys := []
		this.M_Pos := []
		this.detectKeyboard := true
		this.detectMouse := true
		this.detectMousePos := true
		this.StartTime := A_TickCount
		this.ListeningInput := false
		this.NumberSelectedKey := 0
		this.NumberSelectedMousePos := 0

		CoordMode("Mouse", "Screen")
		
		this.WindowDrawing := GUIDrawing() ;Drawing GUI for way mouse pos

		; =======================  EditBox  =========================
		this.GUIparent.Add("Text", "x10 y85 cLime", "Name: ")
        this.EdtName := this.GUIparent.Add("Edit", "x55 y80 r1 vEditTime w150 h10", "Macro Name")

		; =======================  HotKey  =========================
		this.GUIparent.HKMacro := this.GUIparent.Add("HotKey", "vChosenHotkey x250 y80 r1 w150 h10", "F2")

		; =======================  CheckBox  ========================= for input keyboard / mouse btn
		this.GUIparent.SetFont("s10")
		this.CBInputKeyboard := this.GUIparent.Add("CheckBox", "vCBInputKeyboard x10 y110 cWhite" (this.detectKeyboard?" Checked":""), "Keyboard")
		this.CBInputKeyboardFunc := (GuiCtrlObj, Info) => this.CBInputKeyboard_Click(GuiCtrlObj, Info)
		this.CBInputKeyboard.OnEvent("Click", this.CBInputKeyboardFunc)
		this.CBInputMouse := this.GUIparent.Add("CheckBox", "vCBInputMouse x100 y110 cWhite" (this.detectMouse?" Checked":""), "Mouse")
		this.CBInputMouseFunc := (GuiCtrlObj, Info) => this.CBInputMouse_Click(GuiCtrlObj, Info)
		this.CBInputMouse.OnEvent("Click", this.CBInputMouseFunc)
		this.CBPosMouse := this.GUIparent.Add("CheckBox", "vCBPosMouse x170 y110 cWhite"  (this.detectMousePos?" Checked":""), "Mouse Pos")
		this.CBPosMouseFunc := (GuiCtrlObj, Info) => this.CBPosMouse_Click(GuiCtrlObj, Info)
		this.CBPosMouse.OnEvent("Click", this.CBPosMouseFunc)


		; =======================  Text  ========================= Important text Info
		this.GUIparent.SetFont("s10")
		this.TImportant := this.GUIparent.Add("Text", "x40 y100 W2000 Cff0000 Hidden", "Listening...")


		; =======================  List View  ========================= for all key of Keys
		this.GUIparent.SetFont("s10")
		this.LVKeysAction := this.GUIparent.Add("ListView","x10 y130 NoSort -ReadOnly -WantF2 +Report r20 w200",["Name","State  ","Time (en s)"])
		; Notify the script whenever the user double clicks a row:
		this.LV_DoubleClickKeyFunc := (LV, RowNumber) => this.LV_DoubleClickKey(LV, RowNumber)
		this.LV_ItemSelectKeyFunc := (LV, RowNumber, other) => this.LV_ItemSelectKey(LV, RowNumber, other)
		this.LVKeysAction.OnEvent("DoubleClick", this.LV_DoubleClickKeyFunc)
		this.LVKeysAction.OnEvent("ItemSelect", this.LV_ItemSelectKeyFunc)

		this.LVMousePos := this.GUIparent.Add("ListView","x220 y130 NoSort -ReadOnly -WantF2 +Report r20 w200",["      X      ", "      Y      ","Time (en s)"])
		; Notify the script whenever the user double clicks a row:
		this.LV_DoubleClickMouseFunc := (LV, RowNumber) => this.LV_DoubleClickMouseKey(LV, RowNumber)
		this.LV_ItemSelectMouseFunc := (GuiCtrlObj, Item, other) => this.LV_ItemSelectMouse(GuiCtrlObj, Item, other)
		this.LVMousePos.OnEvent("DoubleClick", this.LV_DoubleClickMouseFunc)
		this.LVMousePos.OnEvent("ItemSelect", this.LV_ItemSelectMouseFunc)


		; =======================  Button  ========================= 
		; Start Listen Inputs Button
        this.BtnListen := this.GUIparent.Add("Button", "x70 y560 Default w80", "Start")
        this.BtnListen_ClickFunc := (GuiCtrlObj, n) => this.BtnListen_Click(GuiCtrlObj, n) ; Callback Btn
        this.BtnListen.OnEvent("Click", this.BtnListen_ClickFunc) ; Call BtnOK_ClickFunc when clicked.
		; Delete Selection
        this.BtnDelete := this.GUIparent.Add("Button", "x280 y560 Default w80", "Delete")
        this.BtnDelete_ClickFunc := (GuiCtrlObj, n) => this.BtnDelete_Click(GuiCtrlObj, n) ; Callback Btn
        this.BtnDelete.OnEvent("Click", this.BtnDelete_ClickFunc) ; Call BtnOK_ClickFunc when clicked.
		this.BtnDelete.Enabled := 0
		; Save Inputs Button
        this.BtnSave := this.GUIparent.Add("Button", "x175 y560 Default w80", "SAVE")
        this.BtnSave_ClickFunc := (GuiCtrlObj, n) => this.BtnSave_Click(GuiCtrlObj, n) ; Callback Btn
        this.BtnSave.OnEvent("Click", this.BtnSave_ClickFunc) ; Call BtnOK_ClickFunc when clicked.
		this.BtnDelete.Enabled := 0

		;this.GUIparent.BackColor := "3A3635"

		this.ListeningTextEditFunc := () => this.ListeningTextEdit()
		this.ListenKeyboardMouseFunc := () => this.ListenKeyboardMouse()
	}

	; ======================= FUNCTION =====================
	InitDatas(Name, HotKey, Keys, MousePos)
	{
		this.EdtName.Text := Name
		this.HKMacro := Hotkey

		this.Keys := []  ; Keys
		this.M_Pos := [] ; MousePos

		this.LVKeysAction.Delete()
		this.LVMousePos.Delete()

		for key in Keys
		{
			this.AddKey({Name: key.Name, State: key.State}, key.Time * 1000)
		}
		for M_pos in MousePos
		{
			this.AddMousePos(M_pos.Position, M_pos.Time * 1000)
		}
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

	ListenKeyboardMouse()
	{
		key := this.AnyKeyIsDown(this.detectKeyboard, this.detectMouse)
		MouseGetPos &M_x, &M_y

		if (key)
		{
			this.AddKey(key, A_TickCount - this.StartTime)
		}

		if(this.detectMousePos)
		{
			if(this.M_Pos.Length > 0 && this.M_Pos[this.M_Pos.Length].Position.dist(Vector2(M_x, M_y)) > 10)
			{
				this.AddMousePos(Vector2(M_x, M_y), A_TickCount - this.StartTime)
			}
			else if (this.M_Pos.Length == 0)
			{
				this.AddMousePos(Vector2(M_x, M_y), A_TickCount - this.StartTime)
			}
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
		if(this.Keys.Length == 0)
			return 0
		loop this.Keys.Length
		{
			index := this.Keys.Length - 1 * A_Index + 1
			key := this.Keys[index]

			if(key.Name == keyname)
			{
				return key.State
			}
		}
		return 0
	}

	EditKeyAtRow(RowNumber, Name, State, Time) ;Time en ms
	{
		this.Keys[RowNumber].Name := Name
        this.Keys[RowNumber].Time := Format("{:.2f}", Time/1000)
        this.Keys[RowNumber].State := State

        this.LVKeysAction.Modify(RowNumber,, Name, (State == 0 ? "Up" : "Down"), Format("{:.2f}", Time/1000))
	}

	AddKey(key, Time) ; Time en ms
	{
		this.Keys.Push({Name: key.Name, State: key.State, Time: Format("{:.2f}", Time/1000)})
		this.LVKeysAction.Add(, key.Name, (key.State == 0 ? "Up" : "Down"), Format("{:.2f}", Time/1000))
	}

	AddMousePos(M_pos, Time) ; Time en ms
	{
		this.M_Pos.Push({Position: M_pos, Time: Time/1000})
		this.LVMousePos.Add(, Format("{:i}", M_pos.x), Format("{:i}", M_pos.y), Format("{:.2f}", Time/1000))
	}

	; ======================= CALLBACKS =====================
	;List View for Editing
	LV_DoubleClickKey(LV, RowNumber)
	{
		if(RowNumber)
			GUIEditingKey(this, LV, RowNumber)
	}
	LV_DoubleClickMouse(LV, RowNumber)
	{
		if(RowNumber)
			GUIEditingKey(this, LV, RowNumber)
	}
	LV_ItemSelectKey(LV, RowNumber, other)
	{
		this.NumberSelectedKey := this.LVKeysAction.GetCount("Selected")
		AllSelected := this.NumberSelectedKey + this.NumberSelectedMousePos
		this.BtnDelete.Text := "Delete (" AllSelected ")"

		if(AllSelected != 0)
		{
			this.BtnDelete.Text := "Delete (" AllSelected ")"
			this.BtnDelete.Enabled := 1
		}
		else
		{
			this.BtnDelete.Text := "Delete"
			this.BtnDelete.Enabled := 0
		}
	}
	LV_ItemSelectMouse(GuiCtrlObj, Item, other)
	{
		this.NumberSelectedMousePos := this.LVMousePos.GetCount("Selected")
		;ToolTip "Selected Number is " nbSelected
		AllSelected := this.NumberSelectedKey + this.NumberSelectedMousePos

		if(AllSelected != 0)
		{
			this.BtnDelete.Text := "Delete (" AllSelected ")"			
			this.BtnDelete.Enabled := 1
		}
		else
		{
			this.BtnDelete.Text := "Delete"
			this.BtnDelete.Enabled := 0
		}
	}


	;Listen Btn
	BtnListen_Click(GuiCtrlObj, n)
    {
        this.ListeningInput := !this.ListeningInput
		this.StartTime := A_TickCount

		SetTimer(this.ListenKeyboardMouseFunc,  (this.ListeningInput ? 10 : 0))
		SetTimer(this.ListeningTextEditFunc, (this.ListeningInput ? 200 : 0))

		GuiCtrlObj.Text := (this.ListeningInput ? "Stop" : "Start")
		if(this.ListeningInput)
		{
			this.TImportant.Visible := 1
			this.CBInputKeyboard.Visible := 0
			this.CBInputMouse.Visible := 0
			this.CBPosMouse.Visible := 0
		}
		else
		{
			this.TImportant.Visible := 0
			this.CBInputKeyboard.Visible := 1
			this.CBInputMouse.Visible := 1
			this.CBPosMouse.Visible := 1
		}
    }

	BtnDelete_Click(GuiCtrlObj, n) ; DELETE Btn
	{
		RowNumber := 0  ; This causes the first iteration to start the search at the top.
		Loop ; DELETE All row SELECTED on Key List View
		{
			RowNumber := this.LVKeysAction.GetNext(RowNumber - 1)
			if not RowNumber  ; The above returned zero, so there are no more selected rows.
				break
			this.LVKeysAction.Delete(RowNumber)  ; Clear the row from the ListView.
			this.Keys.RemoveAt(RowNumber)
		}
		Loop ; DELETE All row SELECTED on Mouse List View
		{
			RowNumber := this.LVMousePos.GetNext(RowNumber - 1)
			if not RowNumber  ; The above returned zero, so there are no more selected rows.
				break
			this.LVMousePos.Delete(RowNumber)  ; Clear the row from the ListView.
			this.M_Pos.RemoveAt(RowNumber)
		}
	}

	BtnSave_Click(GuiCtrlObj, n)
	{
		this.GUIparent.AddMacro(this.EdtName.Value, this.GUIparent.HKMacro.Value, this.Keys, this.M_Pos)
	}

	CBInputKeyboard_Click(GuiCtrlObj, Info)
	{
		this.detectKeyboard := GuiCtrlObj.Value
	}
	CBInputMouse_Click(GuiCtrlObj, Info)
	{
		this.detectMouse := GuiCtrlObj.Value
	}
	CBPosMouse_Click(GuiCtrlObj, Info)
	{
		this.detectMousePos := GuiCtrlObj.Value
	}



	; ======================= FUNCTION =====================
	SendMacro()
	{
		this.StartTime := A_TickCount
		KeyIndex := 1
		MouseIndex := 1
		whileSize := (this.Keys.Length < this.M_Pos.Length ? this.M_Pos.Length : this.Keys.Length)

		while((this.Keys.Length < this.M_Pos.Length ? MouseIndex : KeyIndex) < whileSize)
		{
			timer := (A_TickCount - this.StartTime) / 1000
			if(KeyIndex < this.Keys.Length && timer > this.Keys[KeyIndex].Time)
			{
				Send "{"  this.Keys[KeyIndex].Name (this.Keys[KeyIndex].State == 0 ? " up" : " down") "}"
				KeyIndex := KeyIndex + 1
			}
			if(MouseIndex < this.M_Pos.Length && timer > this.M_Pos[MouseIndex].Time)
			{
				MouseMove(this.M_Pos[MouseIndex].Position.x, this.M_Pos[MouseIndex].Position.y) ;The speed to move the mouse in the range 0 (fastest) to 100 (slowest).
				MouseIndex := MouseIndex + 1
			}
		}
	}

	DisplayMouseWay(IsShow)
	{
		if(isShow)
		{
			;if(this.GUIparent.WindowDrawing)
			;	this.GUIparent.WindowDrawing.Show
			;else
			;	this.GUIparent.WindowDrawing := GUIDrawing
			m_pos := []
			for	M_Position in this.M_Pos
			{
				m_pos.Push(M_Position.Position)
			}
			this.WindowDrawing.DrawWithArrayPoint(m_pos, "0xFFFFFF")
		}
		else if(this.WindowDrawing)
		{
			this.WindowDrawing.CleanUp()
		}
	}
}