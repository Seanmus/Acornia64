extends CSGBox3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticBody3D/CollisionShape3D.shape.size.x = size.x
	$StaticBody3D/CollisionShape3D.shape.size.y = size.y
	$StaticBody3D/CollisionShape3D.shape.size.z = size.z
