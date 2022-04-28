Class GUIWindow extends Gui
{
	__New(Title := "Untitled - AhkPad", TickSpeed := 0, IsVisible := true) ;Construtor
	{
        this.TickSpeed := TickSpeed
        this.IsVisible := IsVisible
		WINDOWS.Push(this) ;ADD to the list of all windows
		super.__New("+Resize", Title, this)
		OnMessage(0x201, On_WM_LBUTTONDOWN) ; to move the window by dragging
		
		;this.Show("AutoSize Center")
		this.Show("xCenter yCenter NoActivate w550 h300")

		if(!this.IsVisible)
		{
			;this.Show("AutoSize Center")
			;this.Show("x0 y20 NoActivate w550 h300")
			this.Hide()
		}

		this.UpdateFunc := () => this.Update()

		SetTimer(this.UpdateFunc, TickSpeed)
	}

	SetTick(TickSpeed)
	{
		SetTimer(this.UpdateFunc, TickSpeed)
		this.TickSpeed := TickSpeed
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