extends Node3D


func _on_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$AnimationPlayer.play("icicle_fall")

func _delete_icicle():
	queue_free()
