class_name homingAttackTarget
extends Area3D

@onready var collision = $CollisionShape3D
@onready var soundEffect = $AudioStreamPlayer3D

var disabled = false

func _HighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/highLightTarget.tres")

func _UnHighLight():
	$CSGSphere3D.material = load("res://WorldBlocks/Interactive/unHighLight.tres")

func _Hit():
	collision.set_deferred("disabled", true)
	soundEffect.play()
	disabled = true
	_UnHighLight()

func _Reset():
	collision.set_deferred("disabled", false)
	disabled = true	
