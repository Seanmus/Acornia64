extends homingAttackDestroy

@onready var player = get_tree().get_nodes_in_group("Player")
@onready var startPos = position

func _process(delta: float) -> void:

	if !Manager.won and player && position.distance_to(player[0].position) <= 150:
		$RayCast3D.target_position = player[0].global_position - $RayCast3D.global_position
		print($RayCast3D.get_collider())
		if $RayCast3D.get_collider() != player[0]:
			_ReturnToStart(delta)
		else:
			position = position.move_toward(Vector3(player[0].position.x, player[0].position.y + 1, player[0].position.z), 10 * delta)
			$squirell.look_at(player[0].position)
	else:
		_ReturnToStart(delta)

func _ReturnToStart(delta):
	if position != startPos:
		position = position.move_toward(startPos, 10 * delta)
		if position.distance_to(startPos) > 10:
			$squirell.look_at(startPos)


func _Respawn():	
	position = startPos
	super._Respawn()
