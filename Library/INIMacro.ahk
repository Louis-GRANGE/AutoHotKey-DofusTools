; #include MacroData.ahk
; #include Vector.ahk

Class INIMacro
{
	__New()
	{

	}

	GetAllMacros()
	{
		Macros := []
		Loop Files A_ScriptDir "\Ressources\*.ini" ; Recurse into subfolders.
		{
			Macros.Push(this.GetMacro(A_ScriptDir "\Ressources\" A_LoopFileName))
		}
		return Macros
	}


	AddMacro(MacroName, HotKey, Keys, MousePos)
	{
		; ==========================  INFO  ==========================
		IniWrite(MacroName, A_ScriptDir "\Ressources\" MacroName ".ini", "info", "name")
		IniWrite(HotKey, A_ScriptDir "\Ressources\" MacroName ".ini", "info", "hotkey")

		; ==========================  KEYS  ==========================
		ParsedKeysName := ""
		ParsedKeysState := ""
		ParsedKeysTime := ""

		for key in Keys
		{
			ParsedKeysName := ParsedKeysName "," key.Name
			ParsedKeysState := ParsedKeysState "," key.State
			ParsedKeysTime := ParsedKeysTime "," key.Time
		}

		ParsedKeysName := SubStr(ParsedKeysName, 2, StrLen(ParsedKeysName))
		ParsedKeysState := SubStr(ParsedKeysState, 2, StrLen(ParsedKeysState))
		ParsedKeysTime := SubStr(ParsedKeysTime, 2, StrLen(ParsedKeysTime))

		IniWrite(ParsedKeysName, A_ScriptDir "\Ressources\" MacroName ".ini", "key", "name")
		IniWrite(ParsedKeysState, A_ScriptDir "\Ressources\" MacroName ".ini", "key", "state")
		IniWrite(ParsedKeysTime, A_ScriptDir "\Ressources\" MacroName ".ini", "key", "time")

		; ==========================  MOUSE  ==========================
		ParsedMousePosX := ""
		ParsedMousePosY := ""
		ParsedMouseTime := ""

		for mouse in MousePos
		{
			ParsedMousePosX := ParsedMousePosX "," mouse.Position.x
			ParsedMousePosY := ParsedMousePosY "," mouse.Position.y
			ParsedMouseTime := ParsedMouseTime "," mouse.Time
		}

		ParsedMousePosX := SubStr(ParsedMousePosX, 2, StrLen(ParsedMousePosX))
		ParsedMousePosY := SubStr(ParsedMousePosY, 2, StrLen(ParsedMousePosY))
		ParsedMouseTime := SubStr(ParsedMouseTime, 2, StrLen(ParsedMouseTime))

		IniWrite(ParsedMousePosX, A_ScriptDir "\Ressources\" MacroName ".ini", "mouse", "x")
		IniWrite(ParsedMousePosY, A_ScriptDir "\Ressources\" MacroName ".ini", "mouse", "y")
		IniWrite(ParsedMouseTime, A_ScriptDir "\Ressources\" MacroName ".ini", "mouse", "time")
	}

	GetMacro(File)
	{
		Macro := ""
		
		; ==========================  INFO  ==========================
		MacroName := IniRead(File, "info", "name")
		HotKey := IniRead(File, "info", "hotkey")

		; ==========================  KEYS  ==========================
		KeysName := IniRead(File, "key", "name")
		KeysState := IniRead(File, "key", "state")
		KeysTime := IniRead(File, "key", "time")

		KeysName := StrSplit(KeysName, ",")
		KeysState := StrSplit(KeysState, ",")
		KeysTime := StrSplit(KeysTime, ",")

		Keys := []
		Loop KeysName.Length
		{
			Keys.Push({Name: KeysName[A_Index], State: KeysState[A_Index], Time: KeysTime[A_Index]})
		}

		; ==========================  MOUSE  ==========================
		MousePosX := IniRead(File, "mouse", "x")
		MousePosY := IniRead(File, "mouse", "y")
		MouseTime := IniRead(File, "mouse", "time")

		MousePosX := StrSplit(MousePosX, ",")
		MousePosY := StrSplit(MousePosY, ",")
		MouseTime := StrSplit(MouseTime, ",")

		MousePos := []
		Loop MousePosX.Length
		{
			MousePos.Push({Position: Vector2(MousePosX[A_Index], MousePosY[A_Index]), Time: MouseTime[A_Index]})
		}

		return MacroData(MacroName, HotKey, Keys, MousePos)
	}
}