#include WindowCreateMacro.ahk
#Include GUIWindow.ahk

Class MacroData
{
    __New(Name, HotKeyShortCutStr, Keys, MousePos) ;Construtor
	{
        this.Name := Name
        this.Keys := Keys
        this.MousePos := MousePos
        this.HotKeyShortCutStr := HotKeyShortCutStr

        this.HotKeyFunc := (ThisHotkey) => this.SendMacro(ThisHotkey)
        this.HotKey := Hotkey(HotKeyShortCutStr, this.HotKeyFunc)
    }

    ; ======================= FUNCTION =====================
	SendMacro(ThisHotkey)
	{
		StartTime := A_TickCount
		KeyIndex := 1
		MouseIndex := 1
		whileSize := (this.Keys.Length < this.MousePos.Length ? this.MousePos.Length : this.Keys.Length)

		while((this.Keys.Length < this.MousePos.Length ? MouseIndex : KeyIndex) < whileSize)
		{
			timer := (A_TickCount - StartTime) / 1000
			if(KeyIndex < this.Keys.Length && timer > this.Keys[KeyIndex].AtTime)
			{
				Send "{"  this.Keys[KeyIndex].Name (this.Keys[KeyIndex].State == 0 ? " up" : " down") "}"
				KeyIndex := KeyIndex + 1
			}
			if(MouseIndex < this.MousePos.Length && timer > this.MousePos[MouseIndex].AtTime)
			{
				MouseMove(this.MousePos[MouseIndex].Position.x, this.MousePos[MouseIndex].Position.y) ;The speed to move the mouse in the range 0 (fastest) to 100 (slowest).
				MouseIndex := MouseIndex + 1
			}
		}
	}

    ChangeHotKey(HotKeyShortCutStr)
    {
        Hotkey(this.HotKeyShortCutStr, "off")
        this.HotKeyShortCutStr := HotKeyShortCutStr
        Hotkey(this.HotKeyShortCutStr, this.HotKeyFunc)
    }

    TurnOn()
    {
        Hotkey(this.HotKeyShortCut, "on")
    }

    TurnOff()
    {
        Hotkey(this.HotKeyShortCut, "off")
    }
}



Class GUIMacro extends GUIWindow
{
	__New(Title := "Keys", TickSpeed := 0, IsVisible := true) ;Construtor
	{
        this.MacrosData := []
        this.MacroSelectEditIndex := 0

        super.__New(Title, TickSpeed, IsVisible)
		this.Opt("+lastfound +alwaysontop -caption +toolwindow +resize")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
        this.Show("w435 h625")
		this.SetFont("s24")
		this.Add("Text", "x150 y5 VMyText CLime", "Macro")
        this.BackColor := "3A3635"

        this.SetFont("s10")
        this.Tabs := this.Add("Tab", "-Multi x5 y45 w420 h550 cFFFFFF", ["Macros", "Create / Edit"])
        this.Tab_ChangeFunc := (GuiCtrlObj, Info) => this.Tab_Change(GuiCtrlObj, Info) ; Callback Btn
        this.Tabs.OnEvent("Change", this.Tab_ChangeFunc) ; Call BtnOK_ClickFunc when clicked.
        
		; =======================  TAB 1  ========================= for all macros
		this.SetFont("s10")
		this.LVMacros := this.Add("ListView","x10 y130 NoSort -ReadOnly -WantF2 +Report r20 w300",["Name                     ", "HotKey","Keys","Mouse Pos"])
		; Notify the script whenever the user double clicks a row:
		this.LV_DoubleClickMacroFunc := (LV, RowNumber) => this.LV_DoubleClickMacro(LV, RowNumber)
		this.LV_ItemSelectMacroFunc := (LV, RowNumber, other) => this.LV_ItemSelectMacro(LV, RowNumber, other)
		this.LVMacros.OnEvent("DoubleClick", this.LV_DoubleClickMacroFunc)
		this.LVMacros.OnEvent("ItemSelect", this.LV_ItemSelectMacroFunc)    
        
        
        
        ; =======================  TAB 2  =========================
        this.Tabs.UseTab(2)
        this.GUICreateEditMacro := GUICreateMacro(this)

        ;this.MacrosData.Push(MacroData("Name", {Name: "A", State: 1, AtTime: Format("{:.2f}", 1)}, {Position: Vector2(0, 0), AtTime: Format("{:.2f}", 1)}))
        ;this.AddMacro("Name", [{Name: "A", State: 1, AtTime: Format("{:.2f}", 1)}], [{Position: Vector2(0, 0), AtTime: Format("{:.2f}", 1)}])
    }

    AddMacro(Name, HotKey, Keys, MousePos)
    {
		;HotKey()
        if(this.MacroSelectEditIndex)
        {
            this.MacrosData[this.MacroSelectEditIndex].ChangeHotKey(HotKey)
            this.MacrosData[this.MacroSelectEditIndex].Name := Name
            this.MacrosData[this.MacroSelectEditIndex].Keys := Keys
            this.MacrosData[this.MacroSelectEditIndex].MousePos := MousePos
            ;this.MacrosData[this.MacroSelectEditIndex].HotKey := MacroData(Name, HotKey, Keys, MousePos)
            this.LVMacros.Modify(this.MacroSelectEditIndex,, Name, HotKey, Keys.Length, MousePos.Length)
        }
        else
        {
            this.MacrosData.Push(MacroData(Name, HotKey, Keys, MousePos))
            this.LVMacros.Add(, Name, HotKey, Keys.Length, MousePos.Length)
        }
        this.Tabs.Choose(1)
        this.MacroSelectEditIndex := 0
    }

    ; =======================  CALLBACKS  =========================
    LV_DoubleClickMacro(LV, RowNumber)
    {
        if(RowNumber)
        {
            this.MacroSelectEditIndex := RowNumber
            this.Tabs.Choose(2)
            this.GUICreateEditMacro.InitDatas(this.MacrosData[RowNumber].Name, this.MacrosData[RowNumber].HotKey, this.MacrosData[RowNumber].Keys, this.MacrosData[RowNumber].MousePos)
        }
    }
    LV_ItemSelectMacro(LV, RowNumber, other)
    {

    }
    Tab_Change(GuiCtrlObj, Info)
    {
        ;this.GUICreateEditMacro.InitDatas(this.MacrosData[this.MacroSelectEditIndex].Name, this.MacrosData[this.MacroSelectEditIndex].Keys, this.MacrosData[this.MacroSelectEditIndex].MousePos)
        this.GUICreateEditMacro.InitDatas("Macro_" this.MacrosData.Length, "", [], [])
    }
}