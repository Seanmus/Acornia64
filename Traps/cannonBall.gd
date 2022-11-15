extends Area3D

#Destroys the cannonball when after its animation has finished playing
func _on_animation_player_animation_finished(_anim_name):
	queue_free()
