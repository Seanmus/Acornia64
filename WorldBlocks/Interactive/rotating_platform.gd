extends AnimatableBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(delta * 1.5)
