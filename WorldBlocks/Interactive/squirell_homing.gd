extends homingAttackDestroy

@onready var player = get_tree().get_nodes_in_group("Player")
@onready var startPos = position

func _process(delta: float) -> void:
	if !Manager.won and player && position.distance_to(player[0].position) <= 40:
		position = position.move_toward(player[0].position, 10 * delta)
		$squirell.look_at(player[0].position)
	else:
		if position != startPos:
			position = position.move_toward(startPos, 10 * delta)
			if position.distance_to(startPos) > 10:
				$squirell.look_at(startPos)
