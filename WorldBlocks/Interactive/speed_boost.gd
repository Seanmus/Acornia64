extends Area3D

@export var newMaxSpeed = 50

#Increases the players new max speed
func _on_speed_boost_body_entered(body):
	if body.is_in_group("Player"):
		body._SpeedBoost(newMaxSpeed)
		body.velocity.x = cos(global_rotation.y) * newMaxSpeed
		body.velocity.z  = sin(global_rotation.y) * -newMaxSpeed
		body.velocity.y = -1000
