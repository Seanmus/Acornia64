extends Node


@export var speed  = 0.5
@export var speedBoostMaterial : Material
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speedBoostMaterial.uv1_offset.y += delta * speed
	#get_surface_override_material(0).uv1_offset.x = 1
	
