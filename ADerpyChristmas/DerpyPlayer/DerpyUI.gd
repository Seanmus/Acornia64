extends Control

@export var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player.presentsUpdated.connect(_PresentsUpdated)
	player.scoreUpdated.connect(_ScoreUpdated)
	
func _PresentsUpdated():
	$PresentCollectedAnim.play("presentCollected")
	$PresentsLbl.text = str(player.presents) + "/"+ str(player.presentsInLevel) 

func _ScoreUpdated():
	$ScoreLbl.text = "Score: " + str(player.score)
