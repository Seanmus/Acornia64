class_name UI
extends Node

signal win
var won = true
var time = 0
@onready var cheeseCounter = $standard/cheeseCounter
@export var cheeseParent : Node3D

func _ready() -> void:
	#if(cheeseParent == null):
	#	cheeseParent = get_tree().get_node($"root/../Cheese")
	SetCheeseTotal(cheeseParent.get_child_count()) 

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
	cheeseCounter.text = "x 0" 

func _CollectCheese():
	cheeseCounter.text = "x" + str(Manager.cheeseCount)

func hide():
	$standard.visible = false
	$collect_athon.visible = false
