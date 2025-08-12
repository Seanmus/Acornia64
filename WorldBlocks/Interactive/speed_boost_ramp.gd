extends Node3D

@export var upwardsVelocity = 15

func _on_speed_boost_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Speed boost entered")
		body.velocity.y = upwardsVelocity
