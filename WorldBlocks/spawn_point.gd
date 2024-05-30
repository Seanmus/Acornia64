extends Area3D


func _ready():
	$CSGMesh3D.visible = false

func _on_body_entered(body):
	if body is player:
		print("Setting spawnPoint")
		var Player = body as player
		Player._SetSpawnPoint(position, rotation)
