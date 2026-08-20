extends Node3D

var shaking = false
var falling = false
@onready var startPos = position


func _on_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		shaking = true
		$Timer.start()


func _physics_process(delta: float) -> void:
	if falling:
		position.y -= 2
	elif shaking:
		position.x += randf_range(-0.5, 0.5)
		position.z += randf_range(-0.5, 0.5)
	

func _on_timer_timeout() -> void:
	shaking = false
	falling = true

func _Respawn():
	falling = false
	shaking = false
	$Timer.stop()
	position = startPos
