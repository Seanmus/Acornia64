class_name homingAttackTarget
extends Node3D

@onready var collision = $CollisionShape3D
@onready var soundEffect = $AudioStreamPlayer3D
signal onHit
var disabled = false

func _HighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/highLightTarget.tres")
	pass

func _UnHighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/unHighLight.tres")
	pass

func _Hit():
	print("I got hit")
	emit_signal("onHit")
	collision.set_deferred("disabled", true)
	soundEffect.play()
	disabled = true
	_UnHighLight()

func _Reset():
	collision.set_deferred("disabled", false)
	disabled = true	
