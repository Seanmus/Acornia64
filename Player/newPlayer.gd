class_name player
extends CharacterBody3D

var maxSpeed = 22.5
var acceleration = 130
var air_acceleration = 90
var decceleration = 130
var air_decceleration = 90
var push_force = 10
const JUMP_VELOCITY = 11
var mouse_sensitivty = 0.002 #radiains/pixel
var rotationSpeed = 0.00
var controller_sensitivity = 0.025
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
@export var UI : Node

var spawnPos
var spawnRotation
var homingAttack = false
var overlappedTargets = []
var homingTarget : Node3D
var homingSpeed = 60
var bouncing = true
var turnHeldDownTime = 0

#Occurs when the game is loaded
func _ready():
	if UI == null:
		UI = get_node("/root/UI")
	Manager.on_win.connect(Win)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spawnPos = position
	spawnRotation = rotation
	
#Makes the player bounce when hitting a bouncing object		
func Bounce(bounceMultiplier):
	bouncing = true
	print("bounce")
	velocity.y = JUMP_VELOCITY * bounceMultiplier
	canDoubleJump = true
	#gets player off the ground before transitioning to jump state
	set_position(get_position() + Vector3(0,0.1,0))
	landing = false
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
	$CollisionShape3D.disabled = true
	$Area3D.monitoring = false

	position = position.move_toward(homingTarget.global_position, delta * homingSpeed)
	if position.distance_to(homingTarget.global_position) > 1 && abs(position.y - homingTarget.position.y) > 1:
		var homingRot = position.direction_to(homingTarget.position)
		$Homing.rotation.x = homingRot.x
	#$Homing.process_material.set("direction", position.direction_to(prevPos))
	#Checks if the players has reached the target position
	if position == homingTarget.global_position:
		$CollisionShape3D.disabled = false
		$Area3D.monitoring = true
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
		$Homing.emitting = false
		
#Occurs when an input that has not been previously handled occurs.
func _unhandled_input(event):
	if not Manager.won:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivty)
			auri.rotate_y(event.relative.x * mouse_sensitivty)
			$Pivot.rotate_x(-event.relative.y * mouse_sensitivty)
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)
			
			
func jump():
	if dead:
		return
	$JumpSound.play()
	set_position(get_position() + Vector3(0,0.1,0))
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
	if(Manager.won):
		$auriModel/AnimationTree.active = false
		$auriModel/AnimationPlayer.play("win")
		return
	if homingAttack:
		_HomingAttack(delta)
		return
	if(velocity.y != 0 && !is_on_floor()):
		animationState.travel("jump")
	
	var previousTarget = homingTarget
	homingTarget = _GetClosestTarget()
	if(previousTarget != homingTarget):
		if(homingTarget):
			homingTarget._HighLight()
		if(previousTarget):
			previousTarget._UnHighLight()

	#if is_on_floor():
	#	acceleration = 60
	#else:
	#	acceleration = 40
	if Input.is_action_pressed("sprint"):
		maxSpeed = 22.5
	else:
		pass
		#maxSpeed = 15
		#runCloud.emitting = false
	if not dead:
		if is_on_floor() && !dead && !bouncing:
			canDoubleJump = true
			if not dead:
				animationState.travel("idle")
				if(velocity.x != 0 || velocity.z != 0):
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
					$Homing.emitting = true
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
					target as homingAttackTarget
					target._Reset()
				landing = true

		var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		#controller camera controls
		if cameraInput:
			rotate_y(-cameraInput.x * controller_sensitivity)
			$Pivot.rotate_x(-cameraInput.y * controller_sensitivity)
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)

		var input_dir = Input.get_vector("left", "right", "forward", "back")
		_RotatePlayerModelInInputDirection(input_dir)
		#print(input_dir)
		if is_on_floor() && (input_dir.length() > 0) && velocity.length() > maxSpeed / 2:
			runCloud.emitting = true
		else:
			runCloud.emitting = false
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var movementVelocity = Vector3(velocity.x, 0, velocity.z)
		if direction:
			#auri.rotation = Vector3(0,0,0)
			#Forward
			if(input_dir.x != 0):
				turnHeldDownTime += delta
				if(turnHeldDownTime >= 3):
					turnHeldDownTime = 3
			else:
				turnHeldDownTime -= delta * 5
				if(turnHeldDownTime <= 0):
					turnHeldDownTime = 0
			if(turnHeldDownTime >= 0.5):
				rotate_y(-input_dir.x * rotationSpeed * (turnHeldDownTime / 1.5))
				auri.rotate_y(input_dir.x * rotationSpeed * (turnHeldDownTime / 1.5))
			if is_on_floor():
				#rotate_y(input_dir.x * -0.01)
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
		bouncing = false		
		var _returnValue = move_and_slide()
		
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody3D:
				c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		


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
	print("won")
	animationState.travel("win")

func Reset():
	$acorn/AnimationPlayer.play("Reset")
	$acorn/AnimationPlayer.play("idle")

func _SetSpawnPoint(spawnPoint, spawnerRotation):
	spawnPos = spawnPoint
	spawnRotation = spawnerRotation
	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	position = spawnPos
	rotation = spawnRotation
	$Pivot.rotation.x = spawnRotation.x
	dead = false
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy as MovingEnemiesBase
		enemy._Reset()

#Occurs when another area enters the player area
func _on_area_3d_area_entered(area):
	if area.is_in_group("deadly") or area.is_in_group("moving_platform"):
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
			#if(result):
				#if result.position != target.position:
					#continue
			if not closestTarget:
				closestTarget = target
			#Checks if the distance to the target is less then the distance to the previous closest target
			if position.distance_to(target.global_position) < position.distance_to(closestTarget.global_position):
				closestTarget = target
		#If a closest target was found returns the one otherwise null is returned
		return closestTarget

func _JumpFinished():
	animationState.travel("inAir")


func _on_area_3d_body_entered(body):
	if(body.is_in_group("moving_platform") && is_on_floor()):
		kill()
