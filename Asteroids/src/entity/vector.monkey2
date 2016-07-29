
Class VectorEntity Extends ObjectEntity
Private
	Field _renderPoints:VectorPoint[]
	Field _basePoints:VectorPoint[]
	Field _points:Int=0
	Field _currentScale:Vec2f
	Field _currentRotation:Float
Public
	Field LineColor:Color
	Field PointColor:Color

	Method New()
		'Initialise
		Self.BlendMode=BlendMode.Additive
		_renderPoints=New VectorPoint[20]	
		_basePoints=New VectorPoint[20]	
		Self.LineColor=Color.FromARGB($A0A0A088)
		Self.PointColor=Color.FromARGB($C0C0C088)
	End Method
	
	Property RenderPoints:VectorPoint[]()
		Return _renderPoints
	End
	
	Property Points:Int()
		Return _points
	End
	
	Method AddPoint(x:Float,y:Float)
		'Set
		_basePoints[_points].x=x
		_basePoints[_points].y=y
		_points+=1	
		'Plot
		Self.PlotPoints()
	End Method
	
	Method Reset:Void() Virtual
		'Plot
		Self.PlotPoints()	
	End Method
	
	Method Update:Void() Override
		'Validate
		If (Not Self.Enabled) Return

		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)

		'Validate
		If (_currentScale.X<>Self.Scale.X Or _currentScale.Y<>Self.Scale.Y Or _currentRotation<>Self.Rotation)
			'Plot
			Self.PlotPoints()
								
			'Store
			_currentScale=Self.Scale
			_currentRotation=Self.Rotation
		End
	End Method
	
	Method Render:Void(canvas:Canvas) Override
		'Validate
		If (Not Self.Enabled Or Not Self.Visible) Return
		
		'Canvas
		'Local currentTextureFilteringEnabled:Bool=canvas.TextureFilteringEnabled
		'canvas.TextureFilteringEnabled=True
		'canvas.BlendMode=BlendMode.Additive	'Self.BlendMode	
		canvas.LineWidth=2.5	'For now make all lines >1.0 for smoothing
				
		'Prepare
		Local dx:Float=_renderPoints[0].x+Self.X
		Local dy:Float=_renderPoints[0].y+Self.Y
		
		'Process
		For Local index:Int=1 Until _points
			'Render
			canvas.Color=Self.LineColor
			canvas.DrawLine(dx,dy,_renderPoints[index].x+Self.X,_renderPoints[index].y+Self.Y)
			'canvas.Color=Self.PointColor
			canvas.DrawPoint(Int(dx),Int(dy))
			'Update
			dx=_renderPoints[index].x+Self.X
			dy=_renderPoints[index].y+Self.Y
		Next
		
		'Reset
		canvas.Alpha=1.0
		canvas.Color=Color.White
		'canvas.TextureFilteringEnabled=currentTextureFilteringEnabled
		'canvas.LineWidth=1.0
	End Method
	
	Method CheckCollision:Bool(entity:Entity) Override
		'Validate
		If (Not Self.Collision) Return False
		Return Self.OverlapCollision(Cast<VectorEntity>(entity))
	End Method
		
	'Comparision between two objects
	Method OverlapCollision:Bool(entity:VectorEntity)
		'Process
		For Local k:Int=0 until entity.Points
			'Prepare
			Local eX:Float=entity.RenderPoints[k].x+entity.X
			Local eY:Float=entity.RenderPoints[k].y+entity.Y
			
			'Validate
			If (Self.CollisionState(_renderPoints,_points,Self.X,Self.Y,eX,eY)) Return True
			
			'Local j:Int=_points-1
			'Local isColliding:Bool = False
			
			'Process
			'For Local i:Int=0 Until _points
			'	'Prepare
			'	Local xI:Float=_renderPoints[i].x+Self.X
			'	Local yI:Float=_renderPoints[i].y+Self.Y
			'	Local xJ:Float=_renderPoints[j].x+Self.X
			'	Local yJ:Float=_renderPoints[j].y+Self.Y
			'	
			'	'Validate
			'	'https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
			'	If (((yI>nY)<>(yJ>nY)) And (nX<(xJ-xI)*(nY-yI)/(yJ-yI)+xI)) 
			'		isColliding=Not isColliding
			'	End
			'	'If ((((yI<=entity.Y) And (entity.Y<yJ)) Or ((yJ<=entity.Y) And (entity.Y<yI))) And (entity.X<(xJ-xI)*(entity.Y-yI)/(yJ-yI)+xI)) 
			'	'	isColliding=Not isColliding
			'	'End
			'	
			'	'Store
			'	j=i
			'Next
			
			'Result?
			'If (isColliding) Return True
		Next
		
		'Process (Double check??)
		For Local k:Int=0 until _points
			'Prepare
			Local sX:Float=_renderPoints[k].x+Self.X
			Local sY:Float=_renderPoints[k].y+Self.Y
			
			'Validate
			If (Self.CollisionState(entity.RenderPoints,entity.Points,entity.X,entity.Y,sX,sY)) Return True
			
			'Local j:Int=entity.Points-1
			'Local isColliding:Bool = False
			
			'Process
			'For Local i:Int=0 Until entity.Points
			'	'Prepare
			'	Local xI:Float=entity.RenderPoints[i].x+entity.X
			'	Local yI:Float=entity.RenderPoints[i].y+entity.Y
			'	Local xJ:Float=entity.RenderPoints[j].x+entity.X
			'	Local yJ:Float=entity.RenderPoints[j].y+entity.Y
			'	
			'	'Validate
			'	'https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
			'	If (((yI>nY)<>(yJ>nY)) And (nX<(xJ-xI)*(nY-yI)/(yJ-yI)+xI)) 
			'		isColliding=Not isColliding
			'	End
			'	'If ((((yI<=entity.Y) And (entity.Y<yJ)) Or ((yJ<=entity.Y) And (entity.Y<yI))) And (entity.X<(xJ-xI)*(entity.Y-yI)/(yJ-yI)+xI)) 
			'	'	isColliding=Not isColliding
			'	'End
			'	
			'	'Store
			'	j=i
			'Next
			
			'Result?
			'If (isColliding) Return True
		Next
		
		'Return
		Return False	
	End
	
	'Comparison between object and point
	Method PointInPolyCollision:Bool(entity:VectorEntity)
		Return Self.CollisionState(_renderPoints,_points,Self.X,Self.Y,entity.X,entity.Y)
	End Method

Private
	Method PlotPoints()
		'Process
		For Local index:Int=0 Until _points
			'Prepare
			Local fx:Float=_basePoints[index].x
			Local fy:Float=_basePoints[index].y
			
			'Scale
			fx*=Self.Scale.x
			fy*=Self.Scale.y
			
			'Rotation
			If (Self.Rotation<>0.0)
				Local radian:=DegreesToRadians(-Self.Rotation)
				Local rX:Float=Cos(radian)*fx-Sin(radian)*fy
				Local rY:Float=Sin(radian)*fx+Cos(radian)*fy
				fx=rX
				fy=rY
			End 
			
			'Finalise
			_renderPoints[index].x=fx
			_renderPoints[index].y=fy
		Next
	End Method
	
	Method CollisionState:Bool(points:VectorPoint[],totalPoints:Int,x1:Int,y1:Int,x2:Int,y2:Int)
		'Prepare
		Local j:Int=totalPoints-1
		Local isColliding:Bool=False
		
		'Process
		For Local i:Int=0 Until totalPoints
			'Prepare
			Local xI:Float=points[i].x+x1
			Local yI:Float=points[i].y+y1
			Local xJ:Float=points[j].x+x1
			Local yJ:Float=points[j].y+y1
			
			'Validate
			'https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
			If (((yI>y2)<>(yJ>y2)) And (x2<(xJ-xI)*(y2-yI)/(yJ-yI)+xI)) isColliding=Not isColliding
			
			'Store
			j=i
		Next

		'Return result
		Return isColliding
	End
	
End Class

Struct VectorPoint
	Field x:Float=0.0
	Field y:Float=0.0
End Struct 