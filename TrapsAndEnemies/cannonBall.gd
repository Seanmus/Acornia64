extends Area3D
var speed = 10

@onready var explodeCloud = load("res://Player/jumpCloud.tscn")
#Destroys the cannonball when after its animation has finished playing
func _on_animation_player_animation_finished(_anim_name):	
	queue_free()
	
func explode():
	print("exploding")
	var cloud = explodeCloud.instantiate()
	$CollisionShape3D.add_child(cloud)
	$ball.visible = false

func _shoot():
	$AnimationPlayer.play("shoot")

func _process(delta: float) -> void:
	var forward = global_transform.basis.z
	global_position += forward * speed * delta
