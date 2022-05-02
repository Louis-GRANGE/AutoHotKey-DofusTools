class Vector3
{
    __New(x := 0, y := 0, z := 0)
    {
        this.x := Format("{:.6f}", x)
        this.y := Format("{:.6f}", y)
        this.z := Format("{:.6f}", z)
    }
}

class Vector2
{
    __New(x := 0, y := 0)
    {
        this.x := Format("{:.6f}", x)
        this.y := Format("{:.6f}", y)
    }

    Add(Other_HB_Vector)
    {
		this.x+=Other_HB_Vector.x
		this.y+=Other_HB_Vector.y
	}
	Sub(Other_HB_Vector)
    {
		this.x-=Other_HB_Vector.x
		this.y-=Other_HB_Vector.y
	}
	mag()
    {
		return Sqrt(this.x*this.x + this.y*this.y)
	}
    mult(in1,in2:="",in3:="",in4:="",in5:="")
    {
		if(IsObject(in1)&&in2=""){
			this.x*=In1.x 
			this.y*=In1.y 
		}else if(!IsObject(In1)&&In2=""){
			this.x*=In1
			this.y*=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			this.x*=In1*In2.x
			this.y*=In1*In2.y
		}else if(IsObject(In1)&&IsObject(In2)){
			this.x*=In1.x*In2.x
			this.y*=In1.y*In2.y
		}	
	}
	div(in1,in2:="",in3:="",in4:="",in5:="")
    {
		if(IsObject(in1)&&in2=""){
			this.x/=In1.x 
			this.y/=In1.y 
		}else if(!IsObject(In1)&&In2=""){
			this.x/=In1
			this.y/=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			this.x/=In1/In2.x
			this.y/=In1/In2.y
		}else if(IsObject(In1)&&IsObject(In2)){
			this.x/=In1.x/In2.x
			this.y/=In1.y/In2.y
		}	
	}
	dist(in1)
    {
		return Sqrt(((this.x-In1.x)**2) + ((this.y-In1.y)**2))
	}
	dot(in1)
    {
		return (this.x*in1.x)+(this.y*In1.y)
	}
	cross(in1)
    {
		return this.x*In1.y-this.y*In1.x
	}
	Norm()
    {
		m:=this.Mag()
		this.x/=m
		this.y/=m
	}
}