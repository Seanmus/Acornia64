extends Area3D

@export var player : CharacterBody3D

#crush monitor
func _on_crush_detector_entered(body):
	if(body.is_in_group("moving_platform") && player.is_on_floor()):
		player.kill()

#Occurs when another area enters the player area
func _on_area_3d_area_entered(area):
	if area.is_in_group("deadly") or area.is_in_group("moving_platform"):
		player.kill()
