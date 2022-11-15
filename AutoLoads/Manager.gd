extends Node

var seedCount : int
var totalSeedCount : int
var plantedCount : int
var flowerCount : int
var won
var nextLevel
var gameMode
#Sets win to false
func _ready():
	won = false

func _setGameMode(newGameMode):
	gameMode = newGameMode
	if(gameMode == "collect_athon"):
		UI._collect_athon()
	if(gameMode == "standard"):
		UI._standard()

#Increases the seed count
func _seed_Collected():
	seedCount += 1
	UI.GotSeed()
	
#Increases the planted count	
func _planted():
	plantedCount += 1
	UI.FlowerPlanted()
	if(plantedCount >= 6):
		_win()
		
#Plays the win sound and sets win to true	
func _win():
	won = true
	#player.Won()
	MusicPlayer.playing = false
	$winSound.play()
	LevelLoader._loadLevel(nextLevel)


