Class GUIWindow extends Gui
{
	__New(Title := "Untitled - AhkPad", TickEnable := false, IsVisible := true) ;Construtor
	{
        this.TickEnable := TickEnable
        this.IsVisible := IsVisible
		MyGUIWindow.Push(this)
		super.__New("+Resize", Title, this)
		OnMessage(0x201, On_WM_LBUTTONDOWN) ; to move the window by dragging 
	}

	ToggleView()
	{
		If(this.IsVisible)
		{
			this.Hide()
            this.IsVisible := false
		}
		Else
		{
			this.Show()
            this.IsVisible := true
		}
	}

	SetVisibility(NewVisiblility)
	{
		If(NewVisiblility)
		{
			this.Show()
            this.IsVisible := true
		}
		Else
		{
			this.Hide()
            this.IsVisible := false
        }
	}

	Update()
	{

    }

}

On_WM_LBUTTONDOWN(wParam,lParam,msg,hwnd){
    PostMessage 0xA1, 2
}