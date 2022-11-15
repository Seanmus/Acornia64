extends Node

signal win
var won = true
var time = 0


func _process(_delta):
	time += _delta
	var secs = fmod(time,60)
	var mins = fmod(time,60*60)/60
	var timePassed = "%02d : %02d" % [mins,secs]
	$timeLabel.text = timePassed
	if Input.is_action_just_pressed("escape"):
		LevelLoader._loadLevel("title")

	
func GotSeed():
	Manager.totalSeedCount += 1
	if Manager.totalSeedCount == 6:
		$collect_athon/Seed6.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")
	elif Manager.totalSeedCount == 5:
		$collect_athon/Seed5.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")
	elif Manager.totalSeedCount == 4:
		$collect_athon/Seed4.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")
	elif Manager.totalSeedCount == 3:
		$collect_athon/Seed3.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")
	elif Manager.totalSeedCount == 2:
		$collect_athon/Seed2.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")
	elif Manager.totalSeedCount == 1:
		$collect_athon/Seed1.texture = load("res://UI/Images/sunFlowerSeedRenderLight.png")


func FlowerPlanted():
		$collect_athon/Label.text = "x " + str(Manager.plantedCount)
		if(Manager.plantedCount >= 6): 
			Manager._win()
				
func _collect_athon():
	$collect_athon.visible = true

func _standard():
	$collect_athon.visible = false
