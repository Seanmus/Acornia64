extends Node3D

#Preloads the cannonball asset so that it can be spawned in as many times as needed.
@onready var seedShot = load("res://TrapsAndEnemies/cannon_ball.tscn")

#Linked to the cannon object and shoots every time the timer runs out, afterwards the timer is restarted
func _on_timer_timeout():
	var s = seedShot.instantiate()
	get_tree().root.add_child(s)
	s.global_position = $muzzle.global_position
	s.global_rotation = $muzzle.global_rotation
	s.scale = self.scale
	s._shoot()
	$Timer.start()
	$shoot.play("shoot")
	$sound.play()
