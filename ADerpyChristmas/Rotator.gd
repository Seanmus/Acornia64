extends Node3D

func _physics_process(delta: float) -> void:
	rotate_y(delta/2)
