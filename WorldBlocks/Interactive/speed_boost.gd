extends Area3D

@export var newMaxSpeed = 50

#Increases the players new max speed
func _on_speed_boost_body_entered(body):
	if body.is_in_group("Player"):
		print("Rotation" + str(global_rotation))
		print("Speed boost entered")
		body._SpeedBoost(newMaxSpeed)
		body.velocity.x = cos(global_rotation.y) * 50
		body.velocity.z  = sin(global_rotation.y) * -50
		body.velocity.y = -1000
