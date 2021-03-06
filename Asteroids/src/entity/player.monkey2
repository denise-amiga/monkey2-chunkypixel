'Initialise as needed
Global Player:PlayerEntity

Enum PlayerStatus
	Release=0
	Active=1
	Complete=2
	Exploding=3
End

Class PlayerEntity Extends ShipEntity

'NOTES:
' - When ship resets still in direction of last direction - does not reset back up
' - Ship can fire a max of 4 bullets
' - Ship should only be released once there are no rocks within an exclusion zone
' - Ship could fade in with particle effects
Private
	Field _velocity:=New Vec2f
	Field _thrustChannel:Channel
	Field _counter:CounterTimer
	Field _status:PlayerStatus
	Field _levelComplete:Bool=False
	Field _score:Int=0
	Field _nextLife:Int=10000
Public
	Field Lives:Int=MAX_LIVES
	Field Level:Int=1
	
	Method New()
		'Create
		Self.Initialise()
	End Method
	
	Method Reset:Void() Override
		'Base
		Super.Reset()

		'Set
		Self.Visible=False
		Self.ResetPosition(VirtualResolution.Width/2,VirtualResolution.Height/2)	
		_velocity=New Vec2f()	
				
		'Remove 
		Debris.Remove()
	End Method
	
	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		
				
		'Problem! LAST rock is not removed until next cycle
		'we need to identify if active or exploding as each cycles differently
		
		'Level complete?
		If (Not _levelComplete And Rocks.Remaining()=0 And Not UFO.Released) 
			'Sound
			PlaySoundEffect("LevelUp",1.0,2.0)
			
			'Set
			Thump.Stop()
			_levelComplete=True
			_counter.Restart()
			
			'Change?
			If (_status=PlayerStatus.Active) _status=PlayerStatus.Complete
		End
		
		'Process
		Select _status
			Case PlayerStatus.Release
				'Prepare
				Local canRelease:Bool=True		 

				'Validate (check zone around player)
				Local group:=GetEntityGroup("rocks")
				For Local entity:=Eachin group.Entities
					If (InExclusionZone(entity)) canRelease=False
				Next		
				If (UFO.Released And InExclusionZone(UFO)) canRelease=False
				
				'Can we release?
				If (canRelease) 
					'Set
					_status=PlayerStatus.Active
					Self.Visible=True
					
					'Display rocks (if required)					
					Local group:=GetEntityGroup("rocks")
					For Local entity:Entity=Eachin group.Entities
						Local rock:=Cast<RockEntity>(entity)
						rock.Enabled=True
					Next
										
					'Remove life
					Self.Lives-=1
					
					'Sound
					PlaySoundEffect("Appear",1.0)
				End
				
			Case PlayerStatus.Active				
				'Sound?
				If (Not Thump.IsRunning) Thump.Start()
				
				'Enable?
				If (Not UFO.Enabled) UFO.Enabled=True
				
				'Process
				Self.PlayerMovement()
																		
				'Collision with UFO?	
				If (UFO.Visible And UFO.CheckCollision(Self)) 
					'Explode (and shake)
					Self.Destroy(2)	'Medium
					
					'Remove
					UFO.Destroy()
				End
					
			Case PlayerStatus.Exploding	
				'Game over?
				If (Self.Lives=0) 
					Self.Enabled=False
					Return
				End
				
				'Disable?
				If (Not UFO.Released) UFO.Enabled=False
						
				'Restart?
				If (_counter.Elapsed) 
					'Set
					Self.Reset()
					_status=PlayerStatus.Release
					'Increment level? (may have exploded on last rock) 			
					If (_levelComplete) Self.IncrementLevel() 							
					_levelComplete=False
				End
				
			Case PlayerStatus.Complete
				'Process
				Self.PlayerMovement()

				'Disable?
				If (Not UFO.Released) UFO.Enabled=False

				'Restart?
				If (_counter.Elapsed) 
					'Set
					_status=PlayerStatus.Active
					
					'Increment level
					Self.IncrementLevel() 			
					_levelComplete=False
				End				
		End
	End Method

	Method Destroy:Void(explosionSize:Int)
		'Destroy
		Particles.CreateExplosion(Self.Position,explosionSize)
		Debris.Create(Self.Position)
		Camera.Shake(10.0)

		'Sound
		PlaySoundEffect("Explode1",0.50)
		
		'Sound
		Thump.Stop()
		_thrustChannel.Paused=True

		'Set
		_status=PlayerStatus.Exploding
		Self.Visible=False
		_counter.Restart()
	End Method
	
	Property Status:Int()
		Return _status
	End
	
	Property Score:Int()
		Return _score
	Setter(value:Int)
		'Update
		_score=value
		
		'Validate
		If (Self.Enabled And _score>_nextLife)
			'Icrement
			_nextLife+=10000
			Self.Lives+=1
			
			'Sound
			PlaySoundEffect("Life",1.0)		
		End
	End
	
Private
	Method Initialise:Void() Override
		'Base
		Super.Initialise()

		'Counter
		_counter=New CounterTimer(200,False)
		
		'Other
		'Self.Scale=New Vec2f(1.2,1.2)
		Self.Color=ShipColor
		Self.Speed=0.07
		Self.Rotation=0.0
		Self.Collision=True
		Self.Radius=5
		'Reset
		Self.Reset()
		Self.Enabled=False
		
		'Thrust
		_thrustChannel=PlaySoundEffect("Thrust",0.75,1.0,True)
		_thrustChannel.Paused=True
		
		'Status
		_status=PlayerStatus.Release
	End Method
		
	Method PlayerMovement:Void()
		'This can be used in Active and Complete state
		
		'Rotation
		If (KeyboardControlDown("LEFT")) Self.Rotation+=3
		If (KeyboardControlDown("RIGHT")) Self.Rotation-=3
		' analogue rotation. more is faster turn
		' a little deadzone of 0.1
		Local axisValue:Float=JoystickAxisValue("TURN")
		If (axisValue<-0.2) Self.Rotation+=4*Abs(axisValue)
		If (axisValue>0.2) Self.Rotation-=4*axisValue
		' check joy hat
		' if there is no hat, the value of 0 is returned
		Local hatValue:JoystickHat=JoystickHatValue(0)
		If (hatValue=JoystickHat.Left) Self.Rotation+=3
		If (hatValue=JoystickHat.Right) Self.Rotation-=3

		'Thrust?
		Local acceleration:=New Vec2f()
		If (KeyboardControlDown("THRUST") Or JoystickButtonDown("THRUST"))
			'Calculate
			Local radian:=DegreesToRadians(Self.Rotation)
			acceleration.X=Cos(radian)*Self.Speed
			acceleration.Y=-Sin(radian)*Self.Speed
			'Thrust trail
			Particles.CreateTrail(Self.Position,Self.Rotation-180)
			
			'Play?
			If (_thrustChannel.Paused) _thrustChannel.Paused=False
		Else
			'Stop?
			 _thrustChannel.Paused=True
		End
		
		'Fire?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) Bullets.Create(BulletOwner.Player,Self.Position,Self.Rotation)
		
		'Position
		_velocity+=acceleration
		_velocity*=0.99
		Self.Position+=_velocity
	End Method

	Method IncrementLevel:Void()
		'Rocks start at 4 and increment 2 each level until a max of 11

		'Increment
		Self.Level+=1
		Rocks.MaxRocks+=2
		Rocks.MaxRocks=Min(Rocks.MaxRocks,11)
				
		'Restart
		Rocks.Create(True)
	End Method
			
End Class
