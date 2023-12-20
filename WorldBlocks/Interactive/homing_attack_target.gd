class_name homingAttackTarget
extends Area3D

@onready var collision = $CollisionShape3D

var disabled = false

func _Hit():
	collision.set_deferred("disabled", true)
	disabled = true

func _Reset():
	collision.set_deferred("disabled", false)
	disabled = true	
