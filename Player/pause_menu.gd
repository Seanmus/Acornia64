extends Panel
@onready var audioBus := AudioServer.get_bus_index("Master")

var paused = false

func _ready() -> void:
	$VFlowContainer/audioSlider.value = Manager.busLevel

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		_togglePause()
		


func _on_audio_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audioBus, -60 + value * 60)
	Manager.busLevel = value


func _on_quit_to_start_pressed() -> void:
	LevelLoader._loadLevel("title")


func _on_resume_pressed() -> void:
	_togglePause()


func _togglePause():
	paused = !paused
	visible = paused
	get_tree().paused = paused
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
