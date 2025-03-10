extends Node3D

var entered = false

#Preloads the cannonball asset so that it can be spawned in as many times as needed.
@onready var seedShot = load("res://Traps/auri_cannonBall.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && entered == false:
		entered = true
		$Camera3D.current = true
		body.queue_free()
		$AudioStreamPlayer.play()
		print("player entered")
		$ShootAnim.play("shoot")
		var s = seedShot.instantiate()
		$Muzzle.add_child(s)
