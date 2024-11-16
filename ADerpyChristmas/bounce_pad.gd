extends Node3D


@export var bounceVelocity = 15

@onready var animPlayer = $AnimationPlayer

@onready var bounceEffect = $BounceEffect

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		body.velocity.y = bounceVelocity
		animPlayer.play("bounce")
		bounceEffect.play()
