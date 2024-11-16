extends Node3D

@onready var winEffect = $WinEffect
@export var nextLevel: String

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var player := body as Player
		if player.presents >= player.presentsInLevel:
			winEffect.play()
			player.won = true
			$Transition/AnimationPlayer.play("transition")
			print("YOU WON!")
		else:
			print("Not enough presents yet")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transition":
		get_tree().change_scene_to_file(nextLevel)
