extends Decal

@export var raycast: RayCast3D

func _physics_process(delta):
	if raycast.is_colliding():
		var origin = raycast.global_transform.origin
		var collision_point = raycast.get_collision_point()
		var distance = origin.distance_to(collision_point)
		#adds 0.6 for slopes
		size.y = distance + 0.6
		position.y = -distance/1.8 
