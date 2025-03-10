extends Node3D

@onready var anim = $AnimationPlayer
@onready var sound = $sound

@export var bounceMultiplier = 1.3

#Emits a bounce signal which is linked the player object, also plays the bounce animation and sound.
func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.Bounce(bounceMultiplier);
		anim.play("bounce")
		sound.play()
