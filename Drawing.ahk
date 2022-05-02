#include Vector.ahk

Class GUIDrawing extends Gui
{
	__New() ;Construtor
	{ 
		; WINDOWS.Push(this) ;ADD to the list of all windows
        MouseGetPos &sx, &sy ; start position for measurement

        this.Old_M := Vector2(sx, sy)

		super.__New("+Resize", "Untitled - Drawing", this)

        this.Opt("+LastFound +AlwaysOnTop +ToolWindow -Caption")
        this.BackColor := "008000"
        this.Show()
        this.Maximize()
        this.GuiHwnd := WinExist() ; capture window handle
        this.hdc := DllCall("GetDC", "UInt", this.GuiHwnd)

        this.DrawOnMouseFunc := () => this.DrawOnMouse()
        
        WinSetTransColor("008000", this.Title)
	}

    DrawOnMouse()
    {
        MouseGetPos &M_x, &M_y
        ;If (M_x != this.Old_M_x or M_y != this.Old_M_y)
        ;    WinRedraw(,, "ahk_id " this.GuiHwnd)
        this.Canvas_DrawLine(this.Old_M.x, this.Old_M.y, M_x, M_y, 2, "0x00FF00")
        this.Old_M.x := M_x
        this.Old_M.y := M_y
        Return
    }

    ;DrawLine(p1 := Vector2(0, 0), p2 := Vector2(0, 0), p_color)
    DrawLine(p1, p2, p_color)
    {
        p1 := p1 ? p1 : Vector2(0, 0)
        p2 := p2 ? p2 : Vector2(0, 0)
        this.Canvas_DrawLine(p1.x, p1.y, p2.x, p2.y, 2, p_color)
    }

    DrawWithArrayPoint(Points, p_color)
    {
        Points := Points ? Points : [Vector2(0, 0), Vector2(0, 0)]

        if(Points.Length < 2)
            return

        loop Points.Length - 1
        {
            this.Canvas_DrawLine(Points[A_Index].x, Points[A_Index].y, Points[A_Index + 1].x, Points[A_Index + 1].y, 2, p_color)
        }
    }

    Canvas_DrawLine(p_x1, p_y1, p_x2, p_y2, p_w, p_color)
    {
        p_x1 -= 1, p_y1 -= 1, p_x2 -= 1, p_y2 -= 1
        hCurrPen := DllCall("CreatePen", "UInt", 0, "UInt", p_w, "UInt", p_color)
        DllCall("SelectObject", "UInt",this.hdc, "UInt",hCurrPen)
        DllCall("gdi32.dll\MoveToEx", "UInt", this.hdc, "UInt",p_x1, "UInt", p_y1, "UInt", 0 )
        DllCall("gdi32.dll\LineTo", "UInt", this.hdc, "UInt", p_x2, "UInt", p_y2 )
        ;DllCall("ReleaseDC", "UInt", 0, "UInt", hDC)  ; Clean-up.
        ;DllCall("DeleteObject", "UInt",hCurrPen)
        ;DllCall("ReleaseDC", "UInt", 0, "UInt", this.hdc)  ; Clean-up.
        ;DllCall("DeleteObject", "UInt",hCurrPen)
    }

    CleanUp()
    {
        ;DllCall("ReleaseDC", "UInt", 0, "UInt", this.hdc)  ; Clean-up
        ;this.Destroy()
        WinRedraw(this.Title)
    }
    
}
