extends Node3D

@export var nextLevel = "title"
@export var gameMode = "standard"

@onready var totalCheese = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Manager.nextLevel = nextLevel
	Manager._setGameMode(gameMode)
	if gameMode == "standard":
		totalCheese = $Cheese.get_child_count()
		print("Cheese count "+ str($Cheese.get_child_count()))
		UI.SetCheeseTotal(totalCheese)
	
