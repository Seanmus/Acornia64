extends Node3D

@onready var player = get_tree().get_nodes_in_group("Player")
func _process(_delta: float) -> void:
	if !Manager.won and player && position.distance_to(player[0].position) <= 40:
		look_at(player[0].global_position)
