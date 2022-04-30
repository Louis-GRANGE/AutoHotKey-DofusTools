Class GUIEditingKey extends Gui
{
	__New(GUIMacroRef, LV, RowNumber) ;Construtor
	{
        this.GUIMacroRef := GUIMacroRef
        this.LV := LV
        this.RowNumber := RowNumber
        ; this.Title := "Editing Key"
		super.__New("+AlwaysOnTop +Resize", "Editing Key", this)
		
        this.SetFont("s20")
        this.BackColor := "3A3635"

        this.Add("Text", "x10 y10 cLime", "Timer (s): ")
        this.Timer := this.Add("Edit", "x150 y10 r1 Number vEditTime w150 h10", GUIMacroRef.Macro[RowNumber].AtTime/1000)

        this.Add("Text", "x10 y50 cLime", "Key: ")
        this.Input := this.Add("Edit", "x150 y50 r1 vEditKey w150 h10", GUIMacroRef.Macro[RowNumber].Name)

        this.Add("Text", "x10 y90 cLime", "State: ")
        this.State := this.Add("DropDownList", "x150 y90 w100 vStateChoise Choose" GUIMacroRef.Macro[RowNumber].State + 1, ["Up","Down"])
        
        ; Close Button
        this.CloseBtn := this.Add("Button", "x10 y220 Default w80", "Close")
        this.BtnClose_ClickFunc := (GuiCtrlObj, n) => this.BtnClose_Click(GuiCtrlObj, n) ; Callback Btn
        this.CloseBtn.OnEvent("Click", this.BtnClose_ClickFunc) ; Call BtnOK_ClickFunc when clicked.

        ; OK Button
        this.EditBtn := this.Add("Button", "x450 y220 Default w80", "OK")
        this.BtnOK_ClickFunc := (GuiCtrlObj, n) => this.BtnOK_Click(GuiCtrlObj, n)    ; Callback Btn
        this.EditBtn.OnEvent("Click", this.BtnOK_ClickFunc)  ; Call BtnOK_ClickFunc when clicked.

		this.Show("xCenter yCenter NoActivate w550 h300")
	}

    BtnOK_Click(GuiCtrlObj, n)
    {        
        this.GUIMacroRef.EditKeyAtRow(this.RowNumber, this.Input.Value, this.State.Value - 1, this.Timer.Value)
        this.Destroy()
    }

    BtnClose_Click(GuiCtrlObj, n)
    {
        this.Destroy()
    }
}