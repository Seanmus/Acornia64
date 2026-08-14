extends Area3D


signal nutcracker_trigger_entered
var enteredAlready = false


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if !enteredAlready:
			#enteredAlready = true
			emit_signal("nutcracker_trigger_entered")
