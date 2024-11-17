extends Node3D

@export var nextLevel = "title"
@export var gameMode = "standard"

@onready var totalCheese = 0
@export var UINode : Node
# Called when the node enters the scene tree for the first time.d
func _ready():
	print(UINode)
	Manager.nextLevel = nextLevel
	Manager._setGameMode(gameMode)


	
