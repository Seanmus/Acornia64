extends CharacterBody3D

var speed = 15.0
var sprintMultiplier = 1.0
const ACCELERATION = 5
const JUMP_VELOCITY = 7
var mouse_sensitivty = 0.002 #radiains/pixel
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
@onready var poofCloud = load("res://Player/explodeCloud.tscn")


var spawnPos;
#Occurs when the game is loaded
func _ready():
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
	#$auriModel/AnimationPlayer.play("die")
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
			$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, 0.9)
			
			
func jump():
	if dead:
		return
	$JumpSound.play()
	if velocity.y >= 0:
		animationState.travel("jump")
		anim.play("jump")
		velocity.y += JUMP_VELOCITY
	else:
		velocity.y = JUMP_VELOCITY
		animationState.travel("jump")

func addPoofCloud():
	var cloud = poofCloud.instantiate()
	$SpotLight3D.add_child(cloud)
	
		
#Occurs every frame with a delta to ensure that player movement is consistent no matter the frame rate
func _physics_process(delta):
	if Input.is_action_pressed("sprint"):
		sprintMultiplier = 1.5
	else:
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

		var input_dir = Input.get_vector("left", "right", "forward", "back")
		#Turn right
		if input_dir.x > 0 && input_dir.y == 0:
			auri.rotation_degrees.y = -90
		#Turn right forward	
		if input_dir.x > 0 && input_dir.y < 0:
			auri.rotation_degrees.y = -45
		#Turn left	
		if input_dir.x < 0 && input_dir.y == 0:
			auri.rotation_degrees.y = 90
		#Turn left forward	
		if input_dir.x < 0 && input_dir.y < 0:
			auri.rotation_degrees.y = 45
		#	
		if input_dir.y < 0 && input_dir.x == 0:
			auri.rotation_degrees.y = 0
			
		if input_dir.x < 0 && input_dir.y > 0:
			auri.rotation_degrees.y = 135	
			
		if input_dir.y > 0 && input_dir.x == 0:
			auri.rotation_degrees.y = 180
		if input_dir.x > 0 && input_dir.y > 0:
			auri.rotation_degrees.y = 225	
		
		
		if is_on_floor() && Input.is_action_pressed("sprint") && (velocity.x !=0 || velocity.z != 0):
			runCloud.emitting = true
		else:
			runCloud.emitting = false
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:

			#Forward
			velocity.z = direction.z * speed * sprintMultiplier
			velocity.x = direction.x * speed * sprintMultiplier 
		else:
			velocity.x = move_toward(velocity.x, 0, speed * sprintMultiplier)
			velocity.z = move_toward(velocity.z, 0, speed * sprintMultiplier)
		
		var _returnValue = move_and_slide()

#Starts the win animation
func Win():
	animationState.travel("win")
	Manager._win()

func Reset():
	$acorn/AnimationPlayer.play("Reset")
	$acorn/AnimationPlayer.play("walking")
	
#Teleports the player back to its spawn position on player death.
func _on_deathFinished():
	global_transform = spawnPos
	dead = false

#Occurs when another area enters the player area
func _on_area_3d_area_entered(area):
	print("you should be dead")
	if area.is_in_group("deadly"):
		kill()
