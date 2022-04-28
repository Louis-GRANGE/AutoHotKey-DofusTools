#Include GUIWindow.ahk

Class GUIMacro extends GUIWindow
{
	__New(Title := "Macro", TickSpeed := 0, IsVisible := true) ;Construtor
	{
		this.Macro := []
		this.detectKeyboard := true
		this.detectMouse := false

        super.__New(Title, TickSpeed, IsVisible)

		this.Opt("+lastfound +alwaysontop -caption +toolwindow +resize")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		
		this.SetFont("s32")  ; Set a large font size (32-point).
		this.Add("Text", "VMyText CLime", "Macro")

		this.SetFont("s10") 
		this.LVKeysAction := this.Add("ListView","NoSort -ReadOnly -WantF2 +Report r20 w150",["KeyName","State"])

		this.SetFont("s20")
		this.TImportant := this.Add("Text", "W2000 Cff0000", "Listening...")

		this.BackColor := "3A3635"
		
		this.ListeningTextEdit()
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
		SetTimer(() => this.ListeningTextEdit(), -200)	
	}

	Update()
	{
		this.CheckKeyDown()
	}

	CheckKeyDown()
	{
		key := this.AnyKeyIsDown(this.detectKeyboard, this.detectMouse)
		if (key)
		{
			this.AddKey(key)
			OutputDebug("Adding Key " key.KeyName)
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
					return {KeyName: keyname, State: 1} ; KEY DOWN
				}
				else
				{
					if(!GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 1)
					{
						return {KeyName: keyname, State: 0} ; KEY UP
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
					return {KeyName: mouseArr[A_Index], State: 1}
				}
				else
				{
					if(!GetKeyState(keyname) && this.GetLastStateOfKey(keyname) == 1)
					{
						return {KeyName: keyname, State: 0}
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
		loop this.Macro.Length ;-1
		{
			index := this.Macro.Length - 1 * A_Index + 1
			key := this.Macro[index]

			if(key.KeyName == keyname)
			{
				return key.State
			}
		}
		return 0
	}

	AddKey(key)
	{
		this.Macro.Push(key)
		this.LVKeysAction.Add(, key.KeyName, key.State)
	}
}