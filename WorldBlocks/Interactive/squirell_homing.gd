extends homingAttackDestroy
class_name Squirell_Homing
@onready var player = get_tree().get_nodes_in_group("Player")
@onready var startPos = position
var otherHoming = [self]

func _process(delta: float) -> void:
	if otherHoming.size() > 1:
		position += (otherHoming[1].position - position) * -0.5 * delta

	if !Manager.won and player && position.distance_to(player[0].position) <= 150:
		print(otherHoming.size())
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


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemies"):
		otherHoming.append(area)


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("enemies"):
		otherHoming.erase(area)
