extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		LevelLoader._loadLevel("title")


func _on_title_pressed() -> void:
	LevelLoader._loadLevel("title")


func _on_city_level_pressed() -> void:
	LevelLoader._loadLevel("city_level")


func _on_lava_level_pressed() -> void:
	LevelLoader._loadLevel("lava_level")


func _on_space_station_pressed() -> void:
	LevelLoader._loadLevel("spaceStationLevel")


func _on_forest_pressed() -> void:
	LevelLoader._loadLevel("Forest")


func _on_city_level_2_pressed() -> void:
	LevelLoader._loadLevel("city_level2")
