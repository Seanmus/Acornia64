extends Area3D
signal collected

func _on_sunflower_seed_body_entered(body):
	if body.is_in_group("Player") :
		AudioManager._collectSeed()
		Manager._seed_Collected()
		emit_signal("collected")
		queue_free()
