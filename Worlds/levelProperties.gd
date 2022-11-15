extends Node3D

@export var nextLevel = "title"
@export var gameMode = "standard"
# Called when the node enters the scene tree for the first time.
func _ready():
	Manager.nextLevel = nextLevel
	Manager._setGameMode(gameMode)
	
