extends homingAttackDestroy

@onready var player = get_tree().get_nodes_in_group("Player")
func _process(delta: float) -> void:
	if !Manager.won and player:
		position = position.move_toward(player[0].position, 10 * delta)
