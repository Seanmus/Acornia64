extends Area3D

#Destroys the object after a set amount of time
func _on_timer_timeout():
	queue_free()

#Destroys the object when its body enters another
func _on_seed_body_entered(_body):
	queue_free()
