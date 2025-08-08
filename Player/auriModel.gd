extends Node3D

signal deathFinished
signal jumpFinished

func death_Finished():
	emit_signal("deathFinished")
	$SKM_Auri/AnimationPlayer.play("RESET")
	$SKM_Auri/AnimationTree.active = true
	$SKM_Auri/AnimationPlayer.play("idle")

func jump_Finished():
	emit_signal("jumpFinished")

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	_RotatePlayerModelInInputDirection(input_dir)


func _RotatePlayerModelInInputDirection(input_dir):
	#Turn right
	if input_dir.x > 0 && abs(input_dir.y) <= 0.35:
		rotation_degrees.y = -90
	elif input_dir.y < 0 && abs(input_dir.x) <= 0.35:
		rotation_degrees.y = 0
	elif input_dir.y > 0 && abs(input_dir.x) <= 0.35:
		rotation_degrees.y = 180
	#Turn left	
	elif input_dir.x < 0 && abs(input_dir.y) <= 0.35:
		rotation_degrees.y = 90
	#Turn left forward	
	elif input_dir.x < 0 && input_dir.y < 0:
		rotation_degrees.y = 45
	#
	#Turn right forward	
	elif input_dir.x > 0 && input_dir.y < 0:
		rotation_degrees.y = -45			
	elif input_dir.x < 0 && input_dir.y > 0:
		rotation_degrees.y = 135	
	elif input_dir.x > 0 && input_dir.y > 0:
		rotation_degrees.y = 225		
