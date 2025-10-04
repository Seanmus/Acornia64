extends Area3D

var overlappedTargets = []
@export var player : CharacterBody3D
@export var hurtMonitor : Area3D
@export var cameraAnimPlayer : AnimationPlayer
@export var homingEffect : GPUParticles3D
@export var playerCollider : CollisionShape3D
@export var raycast : RayCast3D
var homingTarget
var homingSpeed = 85
var homingAttackBounceVelocity = 15

func _ready() -> void:
	raycast.add_exception(player)
	raycast.add_exception(hurtMonitor)
	raycast.add_exception(self)

#Sends the player flying towards the homingTargets position
func _HomingAttack(delta):
	homingEffect.emitting = true
	playerCollider.disabled = true
	hurtMonitor.monitoring = false
	player.position = player.position.move_toward(homingTarget.global_position, delta * homingSpeed)
	if player.position == homingTarget.global_position:		
		cameraAnimPlayer.play("ScreenShake")
		#Freeze frame
		OS.delay_msec(40)
		#Triggers the cameras screen shake	
		homingTarget._Hit()
		player.velocity.x = 0
		player.velocity.z = 0
		player.velocity.y = homingAttackBounceVelocity
		player.homingAttack = false
		player.canDoubleJump = false
		_StopHomingAttack()
		

func _StopHomingAttack():
	homingEffect.emitting = false 
	playerCollider.disabled = false
	hurtMonitor.monitoring = true
	
func _physics_process(delta: float) -> void:
	if not player.homingAttack:
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
			#var query = PhysicsRayQueryParameters3D.create(player.position, target.position)
			raycast.target_position = to_local(target.global_position)
			#raycast.force_raycast_update()
			#var result = space_state.intersect_ray(query)
			
			if not closestTarget && !raycast.is_colliding():
				closestTarget = target
			#Checks if the distance to the target is less then the distance to the previous closest target
			if closestTarget && position.distance_to(target.global_position) < player.position.distance_to(closestTarget.global_position) && !raycast.is_colliding():
				closestTarget = target
			#print("Collision point " + str(raycast.is_colliding()) + "Target:" + str(target))
		return closestTarget
