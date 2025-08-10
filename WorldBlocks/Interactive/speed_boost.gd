extends Area3D

@export var newMaxSpeed = 50

#Increases the players new max speed
func _on_speed_boost_body_entered(body):
	if body.is_in_group("Player"):
		print("Speed boost entered")
		body._SpeedBoost(newMaxSpeed)
