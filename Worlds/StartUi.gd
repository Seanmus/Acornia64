extends Node
@onready var audioBus := AudioServer.get_bus_index("Master")
@onready var animationPlayer = $Transition/AnimationPlayer
var loadLevel
#@onready var collect_a_thon = load("res://Worlds/collect_athon.tscn")
#var forest = preload("res://Worlds/new_forest.tscn").instance()

func _ready():
	MusicPlayer.playing = true
	Manager.seedCount = 0
	Manager.flowerCount = 0
	Manager.totalSeedCount = 0
	Manager.won = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Transition.visible = false
#Closes the game when the player presses the escape key
func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
#Plays the transition animation
func _on_button_pressed():
	animationPlayer.play("endFast")

#Loads the first level
func _on_animation_player_animation_finished(_anim_name):
	var _returnValue = get_tree().change_scene_to_file("res://Worlds/new_forest.tscn")

#Sets the audio bus volume to the sliders value
func _on_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(audioBus, -60 + value * 60)

#Loads the collectathon level
func collect_athon():
	LevelLoader._loadLevel("collect_athon")
	#get_tree().change_scene_to_file("res://Worlds/collect_athon.tscn")
