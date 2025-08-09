class_name UI
extends Node

signal win
var won = true
var time = 0
@onready var cheeseCounter = $standard/cheeseCounter
func _ready() -> void:
	var cheeseNodes = get_tree().get_nodes_in_group("cheese")
	var cheeseCount = 0
	for cheese in cheeseNodes:
		cheeseCount += 1
		cheese.cheeseCollected.connect(_CollectCheese)
	#.size was giving array callable as the print out	
	SetCheeseTotal(cheeseCount)
	
func _process(_delta):
	time += _delta
	var secs = fmod(time,60)
	var mins = fmod(time,60*60)/60
	var timePassed = "%02d : %02d" % [mins,secs]
	$standard/timeLabel.text = timePassed

func SetCheeseTotal(cheeseAmount):
	$standard/totalCheese.text = "/" + str(cheeseAmount)
	cheeseCounter.text = "x 0" 

func _CollectCheese():
	cheeseCounter.text = "x" + str(Manager.cheeseCount)

func hide():
	$standard.visible = false
	$collect_athon.visible = false
