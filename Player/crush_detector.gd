extends Area3D

@export var player : CharacterBody3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("moving_platform") && player.is_on_floor():
		player.kill()
