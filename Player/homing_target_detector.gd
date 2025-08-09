extends Area3D

var overlappedTargets = []
@export var player : CharacterBody3D
var homingTarget

func _physics_process(delta: float) -> void:
	_ActivateClosestTarget()

func _ActivateClosestTarget():
	var previousTarget = homingTarget
	homingTarget = _GetClosestTarget()
	if(previousTarget != homingTarget):
		if(homingTarget):
			homingTarget._HighLight()
		if(previousTarget):
			previousTarget._UnHighLight()


func _on_target_detection_area_area_entered(area):
	if area.is_in_group("targets"):
		print("overlapped target")
		overlappedTargets.append(area)


func _on_target_detection_area_area_exited(area):
	if area.is_in_group("targets"):
		overlappedTargets.erase(area)

#If the player is not on the ground, finds a new homing target if it exists and starts the homing attack
func _GetClosestTarget():
	if overlappedTargets:
		var closestTarget
		for target in overlappedTargets:
			#Raycasts towards the target to ensure a clear path
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(player.position, target.position)
			var result = space_state.intersect_ray(query)
			if not closestTarget:
				closestTarget = target
				
			#Checks if the distance to the target is less then the distance to the previous closest target
			if position.distance_to(target.global_position) < player.position.distance_to(closestTarget.global_position):
				closestTarget = target
		#If a closest target was found returns the one otherwise null is returned
		return closestTarget
