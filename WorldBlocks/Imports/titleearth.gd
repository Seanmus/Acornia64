extends Node3D

@export var rotationRate: float = 0.5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(rotationRate * delta)
