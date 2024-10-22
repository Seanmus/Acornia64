extends Node3D

signal deathFinished
signal jumpFinished

func death_Finished():
	emit_signal("deathFinished")

func jump_Finished():
	emit_signal("jumpFinished")
