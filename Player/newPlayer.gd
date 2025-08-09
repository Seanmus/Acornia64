class_name player
extends CharacterBody3D

var maxSpeed = 22.5
var acceleration = 130
var air_acceleration = 90
var decceleration = 130
var air_decceleration = 90
const JUMP_VELOCITY = 11
var canDoubleJump = true
var coyoteTime = false
var landing : bool
var wasOnGround : bool
var dead : bool
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var pivot = $CameraControllerPivot
@onready var cameraAnimPlayer = $CameraControllerPivot/SpringArm3D/Camera3D/AnimationPlayer
@onready var mainCamera = $CameraControllerPivot/SpringArm3D/Camera3D
@onready var landSound = $LandSound
@onready var runCloud = $auriModel/SKM_Auri/runCloud
@onready var auri = $auriModel
@onready var poofCloud = load("res://Player/jumpCloud.tscn")
@onready var hurtMonitor = $HurtMonitor
@onready var homingTargetDetector = $HomingTargetDetector

var spawnPos
var spawnRotation
var homingAttack = false
var homingSpeed = 60
var bouncing = true
var turnHeldDownTime = 0

#Occurs when the game is loaded
func _ready():
	Manager.on_win.connect(Win)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_SetSpawnPoint(position, rotation)

func _SetSpawnPoint(spawnPoint, spawnerRotation):
	spawnPos = spawnPoint
	spawnRotation = spawnerRotation
	
#Makes the player bounce when hitting a bouncing object		
func Bounce(bounceMultiplier):
	bouncing = true
	print("bounce")
	velocity.y = JUMP_VELOCITY * bounceMultiplier
	canDoubleJump = true
	#gets player off the ground before transitioning to jump state
	set_position(get_position() + Vector3(0,0.1,0))
	landing = false

#Jumps the player does a double jump if already in the air
func jump():
	if dead:
		return
	$JumpSound.play()
	#gets player off the ground before transitioning to jump state
	set_position(get_position() + Vector3(0,0.1,0))
	#if falling sets velocity to jump velocity, if going up adds onto the jump velocity
	if velocity.y >= 0:
		velocity.y += JUMP_VELOCITY
	else:
		velocity.y = JUMP_VELOCITY

#Gives the player a short amount of time in which they can do their first jump even when not on the ground
func _on_coyote_timer_timeout() -> void:
	coyoteTime = false
	
#Sends the player flying towards the homingTargets position
func _HomingAttack(delta):
	$CollisionShape3D.disabled = true
	hurtMonitor.monitoring = false
	position = position.move_toward(homingTargetDetector.homingTarget.global_position, delta * homingSpeed)
	if position == homingTargetDetector.homingTarget.global_position:
		$CollisionShape3D.disabled = false
		hurtMonitor.monitoring = true
		cameraAnimPlayer.play("ScreenShake")
		#Freeze frame
		OS.delay_msec(40)
		#Triggers the cameras screen shake	
		homingTargetDetector.homingTarget._Hit()
		velocity.x = 0
		velocity.z = 0
		velocity.y = JUMP_VELOCITY
		homingAttack = false
		canDoubleJump = false
		$Homing.emitting = false
	
func addPoofCloud():
	var cloud = poofCloud.instantiate()
	$JumpCloudSpawnPoint.add_child(cloud)
	
		
#Occurs every frame with a delta to ensure that player movement is consistent no matter the frame rate
func _physics_process(delta):
	if(Manager.won):
		$auriModel/SKM_Auri/AnimationTree.active = false
		$auriModel/SKM_Auri/AnimationPlayer.play("win")
		return
	if homingAttack:
		_HomingAttack(delta)
		return
	hurtMonitor.monitoring = true
	
	if not dead:		
		if is_on_floor() && !dead && !bouncing:
			wasOnGround = true
			canDoubleJump = true
			if(velocity.x != 0 || velocity.z != 0):
				if landing:
					landing = false
			else:
				if landing:
					landing = false
			if Input.is_action_just_pressed("jump"):
				jump()
		else:
			if wasOnGround:
				coyoteTime = true
				$coyoteTimer.start()
				wasOnGround = false
			if Input.is_action_just_pressed("jump"):
				if(homingTargetDetector.homingTarget):
					homingAttack = true
					$Homing.emitting = true
					_HomingAttack(delta)
				else:
					if coyoteTime:
						jump()
						coyoteTime = false
						addPoofCloud()
					elif canDoubleJump:
						jump()
						canDoubleJump = false
						addPoofCloud()
						
			velocity.y -= gravity * 1.2 * delta
			if(velocity.y < 0):
				velocity.y -= gravity * 5 * delta
		if !landing:
			var targets = get_tree().get_nodes_in_group("targets")
			for target in targets:
				target as homingAttackTarget
				target._Reset()
			landing = true

		var input_dir = Input.get_vector("left", "right", "forward", "back")	
		if is_on_floor() && (input_dir.length() > 0) && velocity.length() > maxSpeed / 2:
			runCloud.emitting = true
		else:
			runCloud.emitting = false
			
			
		#Movement	
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var movementVelocity = Vector3(velocity.x, 0, velocity.z)
		if direction:
			if is_on_floor():
				movementVelocity.z += direction.z * acceleration * delta
				movementVelocity.x += direction.x * acceleration * delta
			else:
				movementVelocity.z += direction.z * air_acceleration * delta
				movementVelocity.x += direction.x * air_acceleration * delta
		else:
			if is_on_floor():
				movementVelocity = movementVelocity.move_toward(Vector3.ZERO, decceleration * delta)
			else:
				movementVelocity = movementVelocity.move_toward(Vector3.ZERO, air_decceleration * delta)
		movementVelocity = movementVelocity.limit_length(maxSpeed)
		velocity.x = movementVelocity.x
		velocity.z = movementVelocity.z		
		bouncing = false		
		var _returnValue = move_and_slide()	

#Starts the win animation
func Win():
	print("won")
	$auriModel/SKM_Auri/AnimationTree.active = false
	$auriModel/SKM_Auri/AnimationPlayer.play("RESET")
	$auriModel/SKM_Auri/AnimationPlayer.play("win")

	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	position = spawnPos
	rotation = spawnRotation
	pivot.rotation.x = spawnRotation.x
	dead = false
	$auriModel/SKM_Auri/AnimationPlayer.play("idle")
	$auriModel/SKM_Auri/AnimationTree.active = true
	mainCamera.current = true
	$DeathCam.current = false
	Manager._ResetLevel()

#fixes bug with spin anim on vertical moving platform
func _on_moving_platform_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("moving_platform"):
		print("moving platform on bottom")
		velocity.y = -1000


#Starts the proccess of the players death	
func kill():
	mainCamera.current = false
	$DeathCam.current = true
	$auriModel/SKM_Auri/AnimationTree.active = false
	$auriModel/SKM_Auri/AnimationPlayer.play("die")
	#animationState.travel("die")
	$DeathSound.play()
	velocity.y = 0
	velocity.x = 0
	velocity.z = 0
	dead = true
