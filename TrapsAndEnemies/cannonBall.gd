extends Area3D

@onready var explodeCloud = load("res://Player/jumpCloud.tscn")
#Destroys the cannonball when after its animation has finished playing
func _on_animation_player_animation_finished(_anim_name):
	queue_free()
	
func explode():
	var cloud = explodeCloud.instantiate()
	$CollisionShape3D.add_child(cloud)
	$ball.visible = false
