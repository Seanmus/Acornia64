extends Node

var cheeseCount : int
var seedCount : int
var totalSeedCount : int
var plantedCount : int
var won
var nextLevel
var gameMode
var busLevel = 0.65


var AppID = "3572080"

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

signal on_win
#Sets win to false
func _ready():
	Steam.steamInit()
	won = false
	LevelLoader.level_loaded.connect(_reset)

func _reset():
	cheeseCount = 0
	plantedCount = 0
	totalSeedCount = 0
	seedCount = 0

func _setGameMode(newGameMode):
	gameMode = newGameMode
	#if(gameMode == "collect_athon"):
	#	UI._collect_athon()
	#elif(gameMode == "standard"):
	#	UI._standard()
	#else:
	#	UI.hide()
#Increases the seed count
func _seed_Collected():
	seedCount += 1
	#UI.GotSeed()
	
#Increases the planted count	
func _planted():
	plantedCount += 1
	#UI.FlowerPlanted()
	if(plantedCount >= 6):
		_win()

func _Collect_Cheese():
	cheeseCount+=1
	#UI._CollectCheese(cheeseCount)
		
#Plays the win sound and sets win to true	
func _win():
	won = true
	plantedCount = 0
	MusicPlayer.playing = false
	$winSound.play()
	on_win.emit()
	LevelLoader._loadLevel(nextLevel)
