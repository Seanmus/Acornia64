extends Node3D

@onready var player = get_tree().get_nodes_in_group("Player")
func _process(delta: float) -> void:
	if !Manager.won:
		look_at(player[0].global_position)
