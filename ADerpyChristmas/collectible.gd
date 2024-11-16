extends Sprite3D

@export var scoreValue = 1000


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var player := body as Player
		player._UpdateScore(scoreValue)
		queue_free()
