extends Area3D

var hasBeenTriggered = false

func _ready():
	$CSGMesh3D.visible = false
	$CSGCylinder3D.visible = false

func _on_body_entered(body):
	if body is player and not hasBeenTriggered:
		hasBeenTriggered = true
		print("Setting spawnPoint")
		var Player = body as player
		Player._SetSpawnPoint(position, rotation)
