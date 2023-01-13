extends Node3D

signal deathFinished;

func death_Finished():
	emit_signal("deathFinished");
