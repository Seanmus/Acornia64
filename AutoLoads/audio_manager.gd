extends Node

@onready var seedCollectSound = get_node("seedCollect")
@onready var coinCollectSound = get_node("coinCollect")

func _collectSeed():
	seedCollectSound.play()

func _collectCoin():
	coinCollectSound.play()
