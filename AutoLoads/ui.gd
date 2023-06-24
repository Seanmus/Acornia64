extends Node

signal win
var won = true
var time = 0
var cheese = 0
@onready var cheeseCounter = $standard/cheeseCounter
@onready var lightSunflowerSeed = ResourceLoader.load("res://UI/Images/sunFlowerSeedRenderLight.png")
@onready var darkSunflowerSeed = ResourceLoader.load("res://UI/Images/sunFlowerSeedRenderDark.png")
func _ready():
	LevelLoader.level_loaded.connect(_reset)

func _reset():
	cheese = 0
	$collect_athon/Seed1.texture = darkSunflowerSeed
	$collect_athon/Seed2.texture = darkSunflowerSeed
	$collect_athon/Seed3.texture = darkSunflowerSeed
	$collect_athon/Seed4.texture = darkSunflowerSeed
	$collect_athon/Seed5.texture = darkSunflowerSeed
	$collect_athon/Seed6.texture = darkSunflowerSeed
	$collect_athon/Label.text = "x 0"

func _process(_delta):
	time += _delta
	var secs = fmod(time,60)
	var mins = fmod(time,60*60)/60
	var timePassed = "%02d : %02d" % [mins,secs]
	$standard/timeLabel.text = timePassed
	if Input.is_action_just_pressed("escape"):
		LevelLoader._loadLevel("title")

func SetCheeseTotal(cheeseAmount):
	$standard/totalCheese.text = "/" + str(cheeseAmount)
	cheese = 0
	cheeseCounter.text = "x" + str(cheese)

func CollectCoin():
	cheese+= 1
	cheeseCounter.text = "x" + str(cheese)

func GotSeed():
	Manager.totalSeedCount += 1

	if Manager.totalSeedCount == 6:
		$collect_athon/Seed6.texture = lightSunflowerSeed
	elif Manager.totalSeedCount == 5:
		$collect_athon/Seed5.texture = lightSunflowerSeed
	elif Manager.totalSeedCount == 4:
		$collect_athon/Seed4.texture = lightSunflowerSeed
	elif Manager.totalSeedCount == 3:
		$collect_athon/Seed3.texture = lightSunflowerSeed
	elif Manager.totalSeedCount == 2:
		$collect_athon/Seed2.texture = lightSunflowerSeed
	elif Manager.totalSeedCount == 1:
		$collect_athon/Seed1.texture = lightSunflowerSeed


func FlowerPlanted():
		$collect_athon/Label.text = "x " + str(Manager.plantedCount)
		if(Manager.plantedCount >= 6): 
			Manager._win()
				
func _collect_athon():
	time = 0
	$standard.visible = false
	$collect_athon.visible = true

func _standard():
	time = 0
	$standard.visible = true
	$collect_athon.visible = false
	
func hide():
	$standard.visible = false
	$collect_athon.visible = false
