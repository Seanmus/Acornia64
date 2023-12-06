extends CharacterBody3D

var maxSpeed = 15.0
var speed = 0
var airSpeed = 10.0
var groundSpeed = 15.0
var sprintMultiplier = 1.0
var acceleration = 60
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
@onready var landSound = $LandSound
@onready var runCloud = $runCloud
@onready var auri = $auriModel
@onready var poofCloud = load("res://Player/jumpCloud.tscn")

var spawnPos

#Occurs when the game is loaded
func _ready():
	Manager.on_win.connect(Win)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	spawnPos = global_transform
	
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
	if is_on_floor():
		acceleration = 60
	else:
		acceleration = 40
	if Input.is_action_pressed("sprint"):
		sprintMultiplier = 1.5
		maxSpeed = 22.5
	else:
		maxSpeed = 15
		sprintMultiplier = 1.0
		runCloud.emitting = false
	if not Manager.won && not dead:
		if is_on_floor():
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
			if Input.is_action_just_pressed("jump") && canDoubleJump && !dead:
				canDoubleJump = false
				addPoofCloud()
				jump()
			velocity.y -= gravity * 1.2 * delta
			if(velocity.y < 0):
				velocity.y -= gravity * 5 * delta
			if !landing:
				landing = true

		var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		if cameraInput:
			rotate_y(-cameraInput.x * controller_sensitivity)
			$Pivot.rotate_x(-cameraInput.y * controller_sensitivity)
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)

		var input_dir = Input.get_vector("left", "right", "forward", "back")
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
		
		print(abs(input_dir.y))
		
		if is_on_floor() && Input.is_action_pressed("sprint") && (input_dir.length() > 0):
			runCloud.emitting = true
		else:
			runCloud.emitting = false
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			#Forward
			speed += acceleration * sprintMultiplier * delta;
			if speed > maxSpeed:
				speed = maxSpeed
			velocity.z = direction.z * speed 
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			speed -= acceleration * 3 * delta;
			if(speed < 0):
				speed = 0
		var _returnValue = move_and_slide()

#Starts the win animation
func Win():
	animationState.travel("win")

func Reset():
	$acorn/AnimationPlayer.play("Reset")
	$acorn/AnimationPlayer.play("walking")
	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	global_transform = spawnPos
	dead = false

#Occurs when another area enters the player area
func _on_area_3d_area_entered(area):
	if area.is_in_group("deadly"):
		kill()
