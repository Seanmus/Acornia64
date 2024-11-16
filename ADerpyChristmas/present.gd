extends Node3D

var rotationRate = 1

func _process(delta):
	rotate_x(rotationRate * delta)
	rotate_y(rotationRate * delta)
	rotate_z(rotationRate * delta)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body._PresentCollected()
		queue_free()
