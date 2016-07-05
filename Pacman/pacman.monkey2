Namespace pacman

'Game
#Import "src/sprites"
#Import "src/grid"
#import "src/images"
#import "src/font"
'System
#Import "<std>"
#Import "<mojo>"

Using mojo..
Using std..

' Globals
Global window:PacmanWindow
Global DisplayOffset:=New Vec2i(32,0)

Function Main()
	New AppInstance()
	window = New PacmanWindow("Pacman", 640, 480, WindowFlags.Resizable)	'WindowFlags.Resizable)
	App.Run()
End

Class PacmanWindow Extends Window

	Field IsPaused:Bool
	Field IsSuspended:Bool
	Field ShowFPS:Bool=False
	Field IsDebug:Bool=False
	Field MoveGhosts:Bool=False
	
	Method New(title:String, width:Int, height:Int, flags:WindowFlags)
		' Setup display
		Super.New(title, width, height, flags)
		'Layout = "letterbox"
		ClearColor = Color.Black
		Mouse.PointerVisible=False
		'SwapInterval=60
			
		' Setup
		InitialiseSprites()
		InitialiseGrid()
		InitialiseFont()
		
		'Random Seed
		SeedRnd(12345678)
		
	End Method
	
	Method OnRender(canvas:Canvas) Override
		' Update
		UpdateSprites()
		
		'Double ScreenSize
		'canvas.BlendMode=BlendMode.Alpha
		'canvas.Scale(1.5,1.5)
		
		' Render
		App.RequestRender()
		RenderGrid(canvas)		
		RenderSprites(canvas)
		
		'Score
		canvas.Color=Color.White
		DrawFont(canvas,"1UP",24,0,Color.White)
		Local p1Score:String="      "+Yellow.Score
		DrawFont(canvas,p1Score.Right(6),8,8,Color.White)
		DrawFont(canvas,"HIGH SCORE",72,0,Color.White)
		
		'System
		canvas.Color=Color.White
		If (ShowFPS) DrawFont(canvas,"FPS-" + App.FPS,0,240,Color.White)
		'If (IsDebug) DrawFont(canvas," T-"+Red.Tile.X+"x"+Red.Tile.Y, 0, 15)
		'If (IsDebug) DrawFont(canvas,"AT-"+Red.Tile.X+"x"+Red.Tile.Y, 0, 30)
		'If (IsDebug) DrawFont(canvas,"Dir-"+Yellow.Dir,0,45)
		
	End Method
	
	Method OnKeyEvent( event:KeyEvent ) Override	
		Select event.Type
			Case EventType.KeyDown
				Select event.Key
					Case Key.F12
						Fullscreen = Not Fullscreen				
					Case Key.Escape
						App.Terminate()
					Case Key.F
						ShowFPS=Not ShowFPS
					Case Key.D
						IsDebug=Not IsDebug
					Case Key.F1
						SetGhostMode(GhostMode.Chase)
					Case Key.F2
						SetGhostMode(GhostMode.Scatter)
					Case Key.F3
						SetGhostMode(GhostMode.Frightened)
					Case Key.M
						MoveGhosts=Not MoveGhosts
					Case Key.R
						SetGhostReverseDirection()
				End		
		End 
	End
	
	Method OnWindowEvent(event:WindowEvent) Override
		Select event.Type
			Case EventType.WindowMoved
			Case EventType.WindowResized
				App.RequestRender()
			Case EventType.WindowGainedFocus
				Self.IsSuspended = False
			Case EventType.WindowLostFocus
				Self.IsSuspended = True
			Default
				Super.OnWindowEvent(event)
		End
	End
	
End Class
