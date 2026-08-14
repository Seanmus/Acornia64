extends TextureButton


@onready var outline = $Outline


func _on_focus_entered() -> void:
	grab_focus()
	print("focused")
	$Outline.visible = true

func _on_focus_exited() -> void:
	$Outline.visible = false
