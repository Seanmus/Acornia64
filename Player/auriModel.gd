extends Node3D

signal deathFinished
signal jumpFinished

func death_Finished():
	emit_signal("deathFinished")
	$SKM_Auri/AnimationPlayer.play("RESET")
	$SKM_Auri/AnimationTree.active = true
	$SKM_Auri/AnimationPlayer.play("idle")

func jump_Finished():
	emit_signal("jumpFinished")
