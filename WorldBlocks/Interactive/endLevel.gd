extends Area3D

signal won

@export var nextLevel = "space_level"

#Triggers the win condition on the player
func _on_end_level_body_entered(body):
	if body.is_in_group("Player"):
		body.Win();
