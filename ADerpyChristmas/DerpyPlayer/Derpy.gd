class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6
const HOVERFALLVELOCITY = -2.5
var mouse_sensitivty = 0.002
var controller_sensitivity = 0.02
var wasInAir

@onready var spawnPos = position

@onready var anim = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

@onready var landEffect = $JumpEffect
@onready var jumpEffect = $JumpEffect
@onready var presentCollect = $PresentCollectedEffect

@onready var derpy = $Derpy
@export var presentsParent : Node3D

var presents = 0
var presentsInLevel = 0
@onready var ui = $UI
signal presentsUpdated

var score = 0
signal scoreUpdated
@onready var collectibleCollectedEffect = $CollectibleCollected
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

var won = false

func _ready():
		presentsInLevel = presentsParent.get_child_count()
		presentsUpdated.emit()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _UpdateScore(scoreToAdd):
	score += scoreToAdd
	collectibleCollectedEffect.play()
	scoreUpdated.emit()

func _PresentCollected():
	presents += 1
	presentsUpdated.emit()
	ui._PresentsUpdated()
	presentCollect.play()
	print(presents)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivty)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivty)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, 0)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Worlds/title.tscn")


func _physics_process(delta):
	if won:
		return
		
	if position.y < -20:
		position = spawnPos
	
	
	# Add the gravity.
	if not is_on_floor():
		wasInAir = true

		if velocity.y < 0:
			velocity.y -= gravity * 0.5 * delta
		velocity.y -= gravity * delta
		if Input.is_action_pressed("jump") and velocity.y < 0:
			velocity.y = clamp(velocity.y, HOVERFALLVELOCITY, 0)
			
	else:
		if wasInAir:
			animationState.travel("Land")
			landEffect.play()
		wasInAir = false
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animationState.travel("Jump")
		jumpEffect.play()
	
	if not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			animationState.travel("Hover")
		elif Input.is_action_just_released("jump"):
			animationState.travel("InAir")

	#/Testing out a wall jump feature that didnt make it
	#if is_on_wall() and Input.is_action_just_pressed("jump"):
	#	print("wall jump")
	#	print(get_wall_normal())
	#	velocity.x = get_wall_normal().x * 40
	#	velocity.y = JUMP_VELOCITY
	#/	
	
	var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if cameraInput:
		rotate_y(-cameraInput.x * controller_sensitivity)
		$Pivot.rotate_x(-cameraInput.y * controller_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.9, -0.1)
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Handles the direction the player model faces when moving
	#Turn right
	if input_dir.x > 0 && abs(input_dir.y) <= 0.35:
		derpy.rotation_degrees.y = -90
	elif input_dir.y < 0 && abs(input_dir.x) <= 0.35:
		derpy.rotation_degrees.y = 0
	elif input_dir.y > 0 && abs(input_dir.x) <= 0.35:
		derpy.rotation_degrees.y = 180
	#Turn left	
	elif input_dir.x < 0 && abs(input_dir.y) <= 0.35:
		derpy.rotation_degrees.y = 90
	#Turn left forward	
	elif input_dir.x < 0 && input_dir.y < 0:
		derpy.rotation_degrees.y = 45
	#Turn right forward	
	elif input_dir.x > 0 && input_dir.y < 0:
		derpy.rotation_degrees.y = -45		
	elif input_dir.x < 0 && input_dir.y > 0:
		derpy.rotation_degrees.y = 135	
	elif input_dir.x > 0 && input_dir.y > 0:
		derpy.rotation_degrees.y = 225	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
