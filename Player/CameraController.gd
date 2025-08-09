extends Node3D

@export var playerModel : Node3D
@export var rootNode : Node3D
var mouse_sensitivty = 0.002 #radiains/pixel
var rotationSpeed = 0.00
var controller_sensitivity = 0.025
#Occurs when an input that has not been previously handled occurs.
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var input_dir = Vector2(event.relative.x, event.relative.y)
		_CameraController( input_dir, mouse_sensitivty)


func _CameraController(input_dir, sensitivity):
	if not Manager.won:
		rootNode.rotate_y(-input_dir.x * sensitivity)
		playerModel.rotate_y(input_dir.x * sensitivity)
		rotate_x(-input_dir.y * sensitivity)
		rotation.x = clamp(rotation.x, -0.9, -0.1)


func _physics_process(delta: float) -> void:
	var cameraInput = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if cameraInput:
		_CameraController(cameraInput, controller_sensitivity)
