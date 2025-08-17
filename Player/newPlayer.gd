class_name player
extends CharacterBody3D

var maxSpeed = 25
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
const speedLimit = 25
const speedLossRate = 7
var heldDownTime = 0

@export var spawnPoints : Array[Node3D]
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var pivot = $CameraControllerPivot
@onready var mainCamera = $CameraControllerPivot/SpringArm3D/Camera3D
@onready var landSound = $LandSound
@onready var runCloud = $auriModel/SKM_Auri/runCloud
@onready var auri = $auriModel
@onready var poofCloud = load("res://Player/jumpCloud.tscn")
@onready var hurtMonitor = $HurtMonitor
@onready var HomingAttackComponent = $HomingAttackComponent

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

	
#Occurs every frame with a delta to ensure that player movement is consistent no matter the frame rate
func _physics_process(delta):
	if(Manager.won):
		$auriModel/SKM_Auri/AnimationTree.active = false
		$auriModel/SKM_Auri/AnimationPlayer.play("win")
		return
	if homingAttack:
		HomingAttackComponent._HomingAttack(delta)
		return
	if dead:
		return
	#If the game is not over and the player is not performing a homing attack
	hurtMonitor.monitoring = true
	HandleAerialMovements(delta)		
	MovePlayer(delta)

#########################################################################################################################################
#All in air activities

#Handles jumping and homing attacks
func HandleAerialMovements(delta):
	if not dead:		
		if is_on_floor() && !dead && !bouncing:
			velocity.y -= gravity * 1.2 * delta
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
				if(HomingAttackComponent.homingTarget):
					homingAttack = true
					HomingAttackComponent._HomingAttack(delta)
				else:
					if coyoteTime:
						jump()
						coyoteTime = false
						addPoofCloud()
					elif canDoubleJump:
						jump()
						canDoubleJump = false
						addPoofCloud()
			#Makes the player fall
			velocity.y -= gravity * 1.2 * delta
			if(velocity.y < 0):
				velocity.y -= gravity * 5 * delta
		if !landing:
			var targets = get_tree().get_nodes_in_group("targets")
			for target in targets:
				target as homingAttackTarget
				target._Reset()
			landing = true

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

	
func addPoofCloud():
	var cloud = poofCloud.instantiate()
	$JumpCloudSpawnPoint.add_child(cloud)

#########################################################################################################################################
#END OF AERIAL


#Player Movement
#########################################################################################################################################
func MovePlayer(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	#AUTO ROTATE WORKS BUT NOT SURE IF I LIKE IT
	#if abs(input_dir.x) > 0.1:
	#	heldDownTime +=  delta
	#	if(heldDownTime > 1):
	#		pivot._CameraController(Vector2(input_dir.x, 0), 0.05 * (heldDownTime - 1) / 5 )
	#else:
	#	heldDownTime = 0
	if is_on_floor() && (input_dir.length() > 0) && velocity.length() > maxSpeed / 2:
		runCloud.emitting = true
	else:
		runCloud.emitting = false	
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
	
	if maxSpeed > speedLimit:
		if velocity.length() < maxSpeed:
			maxSpeed = velocity.length()
		maxSpeed -= delta * speedLossRate
		if maxSpeed < speedLimit:
			maxSpeed = speedLimit
			
	velocity.x = movementVelocity.x
	velocity.z = movementVelocity.z		
	bouncing = false		
	var _returnValue = move_and_slide()	
#########################################################################################################################################
#END OF PLAYER MOVEMENT


#########################################################################################################################################
#Auxiallary functionality 

func _SpeedBoost(newMaxSpeed):
	maxSpeed = newMaxSpeed


#Starts the win animation
func Win():
	print("won")
	$auriModel/SKM_Auri/AnimationTree.active = false
	$auriModel/SKM_Auri/AnimationPlayer.play("RESET")
	$auriModel/SKM_Auri/AnimationPlayer.play("win")

#Starts the proccess of the players death	
func kill():
	mainCamera.current = false
	$SpringArm3D/DeathCam.current = true
	$auriModel/SKM_Auri/AnimationTree.active = false
	var rand = randi_range(0, 1)
	if rand == 0:
		$auriModel/SKM_Auri/AnimationPlayer.play("newDeathAnim")
	else:
		$auriModel/SKM_Auri/AnimationPlayer.play("die")
	#animationState.travel("die")
	$DeathSound.play()
	velocity.y = 0
	velocity.x = 0
	velocity.z = 0
	dead = true

	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	position = spawnPos
	rotation = spawnRotation
	pivot.rotation.x = spawnRotation.x
	dead = false
	$auriModel/SKM_Auri/AnimationPlayer.play("idle")
	$auriModel/SKM_Auri/AnimationTree.active = true
	mainCamera.current = true
	$SpringArm3D/DeathCam.current = false
	Manager._ResetLevel()

#fixes bug with spin anim on vertical moving platform
func _on_moving_platform_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("moving_platform"):
		print("moving platform on bottom")
		velocity.y = -1000
#########################################################################################################################################
