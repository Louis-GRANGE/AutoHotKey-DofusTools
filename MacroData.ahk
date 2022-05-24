Class MacroData
{
    __New(Name, HotKeyShortCutStr, isLoop, Keys, MousePos) ;Construtor
	{
        this.Name := Name
        this.Keys := Keys
        this.MousePos := MousePos
        this.HotKeyShortCutStr := HotKeyShortCutStr
        this.isLoop := isLoop
        this.isLooping := false

        this.LoopTimerFunc := () => this.UseMacro()
        this.HotKeyFunc := (ThisHotkey) => this.SendMacro(ThisHotkey)
        this.HotKey := Hotkey(HotKeyShortCutStr, this.HotKeyFunc)
    }

    ; ======================= FUNCTION =====================
	SendMacro(ThisHotkey)
	{
        if(this.isLoop)
        {
            if(!this.isLooping)
            {
                SetTimer(this.LoopTimerFunc, this.GetTimeOfMacro())
                this.isLooping := true
            }
            else
            {
                SetTimer(this.LoopTimerFunc, 0)
                this.isLooping := false
            }
        }
        else
        {
            this.UseMacro()
        }
	}

    UseMacro()
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

    GetTimeOfMacro()
    {
        KeyMaxTime := (this.Keys.Length != 0 ? this.Keys[this.Keys.Length].Time : 0)
        MousePosMaxTime := (this.MousePos.Length != 0 ? this.MousePos[this.MousePos.Length].Time : 0)
        
        if(KeyMaxTime > MousePosMaxTime)
            return KeyMaxTime
        else
            return MousePosMaxTime
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
