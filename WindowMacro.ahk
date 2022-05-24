#include WindowCreateMacro.ahk
#include GUIWindow.ahk
#include MacroData.ahk

Class GUIMacro extends GUIWindow
{
	__New(Title := "Keys", TickSpeed := 0, IsVisible := true) ;Construtor
	{
        this.INITMacroFile := INIMacro()
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
		this.LVMacros := this.Add("ListView","x10 y130 NoSort -ReadOnly -WantF2 +Report r20 w300",["Name                     ", "HotKey", "Loop","Keys","Mouse Pos"])
		; Notify the script whenever the user double clicks a row:
		this.LV_DoubleClickMacroFunc := (LV, RowNumber) => this.LV_DoubleClickMacro(LV, RowNumber)
		this.LV_ItemSelectMacroFunc := (LV, RowNumber, other) => this.LV_ItemSelectMacro(LV, RowNumber, other)
		this.LVMacros.OnEvent("DoubleClick", this.LV_DoubleClickMacroFunc)
		this.LVMacros.OnEvent("ItemSelect", this.LV_ItemSelectMacroFunc)    
        
        
        
        ; =======================  TAB 2  =========================
        this.Tabs.UseTab(2)
        this.GUICreateEditMacro := GUICreateMacro(this)

        ;this.MacrosData.Push(MacroData("Name", {Name: "A", State: 1, Time: Format("{:.2f}", 1)}, {Position: Vector2(0, 0), Time: Format("{:.2f}", 1)}))
        ;this.AddMacro("Name", [{Name: "A", State: 1, Time: Format("{:.2f}", 1)}], [{Position: Vector2(0, 0), Time: Format("{:.2f}", 1)}])


        ; INIT Array and LV with File datas
        this.MacrosData := this.INITMacroFile.GetAllMacros()
        for Macro in this.MacrosData
        {
            this.LVMacros.Add(, Macro.Name, Macro.HotKeyShortCutStr, Macro.IsLoop == 0 ? "No" : "Yes", Macro.Keys.Length, Macro.MousePos.Length)
        }
    }

    AddMacro(Name, HotKey, IsLoop, Keys, MousePos)
    {
		;HotKey()
        if(this.MacroSelectEditIndex)
        {
            this.MacrosData[this.MacroSelectEditIndex].ChangeHotKey(HotKey)
            this.MacrosData[this.MacroSelectEditIndex].Name := Name
            this.MacrosData[this.MacroSelectEditIndex].Keys := Keys
            this.MacrosData[this.MacroSelectEditIndex].IsLoop := IsLoop
            this.MacrosData[this.MacroSelectEditIndex].MousePos := MousePos
            ;this.MacrosData[this.MacroSelectEditIndex].HotKey := MacroData(Name, HotKey, Keys, MousePos)
            this.LVMacros.Modify(this.MacroSelectEditIndex,, Name, HotKey, IsLoop == 0 ? "No" : "Yes", Keys.Length, MousePos.Length)
        }
        else
        {
            this.MacrosData.Push(MacroData(Name, HotKey, IsLoop, Keys, MousePos))
            this.LVMacros.Add(, Name, HotKey, IsLoop == 0 ? "No" : "Yes", Keys.Length, MousePos.Length)
        }
        this.Tabs.Choose(1)

        ; Adding Macro to the .ini file
        this.INITMacroFile.AddMacro(Name, HotKey, IsLoop, Keys, MousePos)

        this.MacroSelectEditIndex := 0
    }

    ; =======================  CALLBACKS  =========================
    LV_DoubleClickMacro(LV, RowNumber)
    {
        if(RowNumber)
        {
            this.MacroSelectEditIndex := RowNumber
            this.Tabs.Choose(2)
            this.GUICreateEditMacro.InitDatas(this.MacrosData[RowNumber].Name, this.MacrosData[RowNumber].HotKey, this.MacrosData[RowNumber].IsLoop, this.MacrosData[RowNumber].Keys, this.MacrosData[RowNumber].MousePos)
        }
    }
    LV_ItemSelectMacro(LV, RowNumber, other)
    {

    }
    Tab_Change(GuiCtrlObj, Info)
    {
        ;this.GUICreateEditMacro.InitDatas(this.MacrosData[this.MacroSelectEditIndex].Name, this.MacrosData[this.MacroSelectEditIndex].Keys, this.MacrosData[this.MacroSelectEditIndex].MousePos)
        this.GUICreateEditMacro.InitDatas("Macro_" this.MacrosData.Length, "", 0, [], [])
    }
}