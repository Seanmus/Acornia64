extends Node


signal presentCollected

func _GotPresent():
	presentCollected.emit()
