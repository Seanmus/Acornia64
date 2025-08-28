extends Node3D

@export var nextLevel = "title"
@export var gameMode = "standard"

@onready var totalCheese = 0
@export var UINode : Node
@export var levelMusic : AudioStream
# Called when the node enters the scene tree for the first time
func _ready():
	print(UINode)
	Manager.nextLevel = nextLevel
	Manager._setGameMode(gameMode)
	Manager.won = false
	MusicPlayer.stream = levelMusic
	MusicPlayer.play()
