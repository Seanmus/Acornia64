extends Node

@onready var seedCollectSound = get_node("seedCollect")
@onready var coinCollectSound = get_node("coinCollect")
@onready var Woosh = $Woosh
@onready var startingPitch = $Woosh.pitch_scale
@onready var startingDB = $Woosh.volume_db

func _collectSeed():
	seedCollectSound.play()

func _collectCoin():
	coinCollectSound.play()

func _speedBoost():
	if !Woosh.playing:
		Woosh.pitch_scale = startingPitch
		Woosh.volume_db = startingDB
		Woosh.pitch_scale += randf_range(-0.05, 0.05)
		Woosh.volume_db += randf_range(-0.5, 0.5)
		Woosh.play()
