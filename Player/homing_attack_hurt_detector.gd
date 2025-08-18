extends Area3D

@export var player : CharacterBody3D

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("deadly"):
		player.kill()
		
