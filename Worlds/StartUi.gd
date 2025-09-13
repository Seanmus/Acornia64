extends Node
@onready var audioBus := AudioServer.get_bus_index("Master")
@onready var animationPlayer = $Transition/AnimationPlayer

func _ready():
	$FlowContainer/startBtn.grab_focus()
	MusicPlayer.playing = true
	Manager.won = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Transition.visible = false
	$audioSlider.value = Manager.busLevel
#Closes the game when the player presses the escape key
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
#Loads the first level
func _on_button_pressed():
	LevelLoader._loadLevel("city_level")

#Sets the audio bus volume to the sliders value
func _on_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(audioBus, -60 + value * 60)
	Manager.busLevel = value
	if !MusicPlayer.playing:
		MusicPlayer.play()

#Loads the collectathon level
func collect_athon():
	LevelLoader._loadLevel("collect_athon")
	#get_tree().change_scene_to_file("res://Worlds/collect_athon.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_level_select_pressed() -> void:
	var _returnValue = get_tree().change_scene_to_file("res://Worlds/levelSelect.tscn")
