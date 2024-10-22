extends Node3D


func _on_homing_attack_target_on_hit():
	queue_free()
