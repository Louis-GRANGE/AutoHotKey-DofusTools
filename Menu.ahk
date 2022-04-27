;MyMenuBar := MenuBar()
;MyMenuBar.Add("Random", MenuHandler)
;MenuHandler(ItemName, ItemPos, MyMenu) {
;    MsgBox "You selected " ItemName " (position " ItemPos ")"
;}
;MyGUIWindow[1].MenuBar := MyMenuBar

class CustomMenu extends MenuBar
{
	__New(GUIToAddMenu, AllGUI) ;Construtor
	{
        this.SBAllWindows := Menu()
        this.SBAllWindows.Base := this
        this.AllGUI := AllGUI
        this.CurrentGUI := GUIToAddMenu
        for GuiWindow in AllGUI
        {
            this.SBAllWindows.Add(GUIWindow.Title, MenuHandler)
            GUIWindow.SetVisibility(false)
        }
        ;this.Add("Random", MenuHandler)
        
        for GuiWindow in AllGUI
        {
            GuiWindow.MenuBar := this
        }

        this.Add("Windows", this.SBAllWindows)
        ;GUIToAddMenu.MenuBar := this
	}


}

MenuHandler(ItemName, ItemPos, MyMenu)
{
    MyMenu.Base.CurrentGUI.GetPos(&CurrentX, &CurrentY)
    for SelectGUIInMenu in MyMenu.Base.AllGUI
    {
        if(ItemName == SelectGUIInMenu.Title)
        {
            SelectGUIInMenu.Move(CurrentX, CurrentY)
            SelectGUIInMenu.SetVisibility(true)
            MyMenu.Base.CurrentGUI := SelectGUIInMenu
        }
        else
        {
            SelectGUIInMenu.SetVisibility(false)
        }
    }

    ;MsgBox "You selected " ItemName " (position " ItemPos ")"
}


;for n in FibF()
;    if MsgBox("#" A_Index " = " n "`nContinue?",, "y/n") = "No"
;        break

;FibF() {
;    a := 0, b := 1
;    return (&n) => (
;        n := c := b, b += a, a := c,
;        true
;    )
;}