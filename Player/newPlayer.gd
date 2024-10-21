class_name player
extends CharacterBody3D

var maxSpeed = 15.0
var acceleration = 130
var air_acceleration = 90
var decceleration = 130
var air_decceleration = 90
const JUMP_VELOCITY = 7
var mouse_sensitivty = 0.002 #radiains/pixel
var controller_sensitivity = 0.02
var canDoubleJump = true
var landing : bool
var dead : bool
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animationTree = $auriModel/AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var anim = $auriModel/AnimationPlayer
@onready var cameraAnimPlayer = $Pivot/SpringArm3D/Camera3D/AnimationPlayer
@onready var landSound = $LandSound
@onready var runCloud = $runCloud
@onready var auri = $auriModel
@onready var poofCloud = load("res://Player/jumpCloud.tscn")
@onready var targetPath = $TargetLine/Path3D


var spawnPos
var spawnRotation
var homingAttack = false
var overlappedTargets = []
var homingTarget : Node3D
var homingSpeed = 60

#Occurs when the game is loaded
func _ready():
	Manager.on_win.connect(Win)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spawnPos = position
	spawnRotation = rotation
	
#Makes the player bounce when hitting a bouncing object		
func Bounce():
	velocity.y = JUMP_VELOCITY * 2
	canDoubleJump = true
	animationState.travel("jump")
	
#Starts the proccess of the players death	
func kill():
	animationState.travel("die")
	$DeathSound.play()
	velocity.y = 0
	velocity.x = 0
	velocity.z = 0
	dead = true

#Sends the player flying towards the homingTargets position
func _HomingAttack(delta):
	print(homingTarget.name)
	position = position.move_toward(homingTarget.position, delta * homingSpeed)
	#Checks if the players has reached the target position
	if position == homingTarget.position:
		cameraAnimPlayer.play("ScreenShake")
		#Freeze frame
		OS.delay_msec(40)
		#Triggers the cameras screen shake	
		homingTarget._Hit()
		velocity.x = 0
		velocity.z = 0
		velocity.y = JUMP_VELOCITY
		homingAttack = false
		canDoubleJump = false
		
#Occurs when an input that has not been previously handled occurs.
func _unhandled_input(event):
	if not Manager.won:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivty)
			$Pivot.rotate_x(-event.relative.y * mouse_sensitivty)
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)
			
			
func jump():
	if dead:
		return
	$JumpSound.play()
	set_position(get_position() + Vector3(0,0.1,0));
	if velocity.y >= 0:
		velocity.y += JUMP_VELOCITY
	else:
		velocity.y = JUMP_VELOCITY
	animationState.travel("jump")
	
	
func addPoofCloud():
	var cloud = poofCloud.instantiate()
	$JumpCloudSpawnPoint.add_child(cloud)
	
		
#Occurs every frame with a delta to ensure that player movement is consistent no matter the frame rate
func _physics_process(delta):
	if(homingTarget):
		$TargetLine.visible = true
		targetPath.curve.set_point_in(0, position)
		targetPath.curve.set_point_in(1, global_position - homingTarget.global_position)
	else:
		$TargetLine.visible = false
	if homingAttack:
		_HomingAttack(delta)
		return
	homingTarget = _GetClosestTarget()

	#if is_on_floor():
	#	acceleration = 60
	#else:
	#	acceleration = 40
	if Input.is_action_pressed("sprint"):
		maxSpeed = 22.5
	else:
		#maxSpeed = 15
		runCloud.emitting = false
	if not Manager.won && not dead:
		if is_on_floor() && !dead:
			canDoubleJump = true
			if not dead:
				animationState.travel("walking")
			if landing:
				landSound.play()
				animationState.travel("land");
				landing = false	
			if Input.is_action_just_pressed("jump"):
				jump()
		else:
			if Input.is_action_just_pressed("jump"):
				if(homingTarget):
					homingAttack = true
					_HomingAttack(delta)
				else:
					if canDoubleJump:
						jump()
						canDoubleJump = false
						addPoofCloud()
			velocity.y -= gravity * 1.2 * delta
			if(velocity.y < 0):
				velocity.y -= gravity * 5 * delta
			if !landing:
				var targets = get_tree().get_nodes_in_group("targets")
				for target in targets:
					print("reseting target")
					target as homingAttackTarget
					target._Reset()
				landing = true

		var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		if cameraInput:
			rotate_y(-cameraInput.x * controller_sensitivity)
			$Pivot.rotate_x(-cameraInput.y * controller_sensitivity)
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)

		var input_dir = Input.get_vector("left", "right", "forward", "back")
		_RotatePlayerModelInInputDirection(input_dir)
		print(velocity)
		if is_on_floor() && Input.is_action_pressed("sprint") && (input_dir.length() > 0):
			runCloud.emitting = true
		else:
			runCloud.emitting = false
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var movementVelocity = Vector3(velocity.x, 0, velocity.z)
		if direction:
			#Forward
			if is_on_floor():
				movementVelocity.z += direction.z * acceleration * delta
				movementVelocity.x += direction.x * acceleration * delta
			else:
				movementVelocity.z += direction.z * air_acceleration * delta
				movementVelocity.x += direction.x * air_acceleration * delta

		else:
			#Fix bug with y velocity when you get back!
			if is_on_floor():
				movementVelocity = movementVelocity.move_toward(Vector3.ZERO, decceleration * delta)
			else:
				movementVelocity = movementVelocity.move_toward(Vector3.ZERO, air_decceleration * delta)
				#velocity.x = move_toward(velocity.x , 0, air_decceleration * delta)
				#velocity.z = move_toward(velocity.z , 0, air_decceleration * delta)
		movementVelocity = movementVelocity.limit_length(maxSpeed)
		velocity.x = movementVelocity.x
		velocity.z = movementVelocity.z		
				
		var _returnValue = move_and_slide()


func _RotatePlayerModelInInputDirection(input_dir):
	#Turn right
	if input_dir.x > 0 && abs(input_dir.y) <= 0.35:
		auri.rotation_degrees.y = -90
	elif input_dir.y < 0 && abs(input_dir.x) <= 0.35:
		auri.rotation_degrees.y = 0
	elif input_dir.y > 0 && abs(input_dir.x) <= 0.35:
		auri.rotation_degrees.y = 180
	#Turn left	
	elif input_dir.x < 0 && abs(input_dir.y) <= 0.35:
		auri.rotation_degrees.y = 90
	#Turn left forward	
	elif input_dir.x < 0 && input_dir.y < 0:
		auri.rotation_degrees.y = 45
	#
	#Turn right forward	
	elif input_dir.x > 0 && input_dir.y < 0:
		auri.rotation_degrees.y = -45			
	elif input_dir.x < 0 && input_dir.y > 0:
		auri.rotation_degrees.y = 135	
	elif input_dir.x > 0 && input_dir.y > 0:
		auri.rotation_degrees.y = 225		

#Starts the win animation
func Win():
	animationState.travel("win")

func Reset():
	$acorn/AnimationPlayer.play("Reset")
	$acorn/AnimationPlayer.play("walking")

func _SetSpawnPoint(spawnPoint, spawnerRotation):
	spawnPos = spawnPoint
	spawnRotation = spawnerRotation
	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	position = spawnPos
	rotation = spawnRotation
	dead = false

#Occurs when another area enters the player area
func _on_area_3d_area_entered(area):
	if area.is_in_group("deadly"):
		kill()

func _on_target_detection_area_area_entered(area):
	if area.is_in_group("targets"):
		overlappedTargets.append(area)


func _on_target_detection_area_area_exited(area):
	if area.is_in_group("targets"):
		overlappedTargets.erase(area)

#If the player is not on the ground, finds a new homing target if it exists and starts the homing attack
func _GetClosestTarget():
	if overlappedTargets:
		var closestTarget
		for target in overlappedTargets:
			#Raycasts towards the target to ensure a clear path
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(position, target.position)
			var result = space_state.intersect_ray(query)
			if(result):
				if result.position != target.position:
					continue
			if not closestTarget:
				closestTarget = target
			#Checks if the distance to the target is less then the distance to the previous closest target
			if position.distance_to(target.position) < position.distance_to(closestTarget.position):
				closestTarget = target
		#If a closest target was found returns the one otherwise null is returned
		print(closestTarget)
		return closestTarget
