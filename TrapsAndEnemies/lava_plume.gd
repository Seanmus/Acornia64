extends Area3D

var emitting  = true

func _ready() -> void:
	$GPUParticles3D.emitting = true

func _on_timer_timeout() -> void:
	if emitting:
		emitting = false
		$GPUParticles3D.emitting = false
	else: 
		emitting = true
		$GPUParticles3D.emitting = true
