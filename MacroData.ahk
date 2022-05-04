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
			if(KeyIndex < this.Keys.Length && timer > this.Keys[KeyIndex].Time)
			{
				Send "{"  this.Keys[KeyIndex].Name (this.Keys[KeyIndex].State == 0 ? " up" : " down") "}"
				KeyIndex := KeyIndex + 1
			}
			if(MouseIndex < this.MousePos.Length && timer > this.MousePos[MouseIndex].Time)
			{
				MouseMove(this.MousePos[MouseIndex].Position.x, this.MousePos[MouseIndex].Position.y) ;The speed to move the mouse in the range 0 (fastest) to 100 (slowest).
				MouseIndex := MouseIndex + 1
			}
		}
	}

    ChangeHotKey(HotKeyShortCutStr)
    {
        if(HotKeyShortCutStr != this.HotKeyShortCutStr)
        {
            Hotkey(this.HotKeyShortCutStr, "off")
            this.HotKeyShortCutStr := HotKeyShortCutStr
            this.HotKey := Hotkey(this.HotKeyShortCutStr, this.HotKeyFunc, "On")
        }
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
