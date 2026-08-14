extends TextureButton



func _on_focus_entered() -> void:
	grab_focus()
	print("focused")


func _on_focus_exited() -> void:
	release_focus()
