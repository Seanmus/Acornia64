extends Node2D

@onready var transitionAnimation = $Transition/AnimationPlayer
@export var nextLevel = "title"

#Loads level after transition anim has finished
func _on_animation_player_animation_finished(_anim_name):
	Manager.won = false
	MusicPlayer.play()
	$Transition.visible = false
	var _returnValue = get_tree().change_scene_to_file("res://Worlds/" + nextLevel + ".tscn")

	
#Triggers the transisition anim and sets the next level to be loaded
func _loadLevel(nextLevelInput):
	nextLevel = nextLevelInput
	transitionAnimation.play("end")
