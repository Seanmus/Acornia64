class_name homingAttackTarget
extends Node3D

@onready var collision = $Shield
@onready var soundEffect = $AudioStreamPlayer3D
signal onHit

func _HighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/highLightTarget.tres")

func _UnHighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/unHighLight.tres")

func _Hit():
	print("I got hit")
	onHit.emit()
	collision.set_deferred("disabled", true)
	soundEffect.play()
	_UnHighLight()

func _Reset():
	if process_mode == Node.PROCESS_MODE_INHERIT:
		collision.set_deferred("disabled", false)
