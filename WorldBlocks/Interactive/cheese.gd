extends Area3D

#Destroys the cheese(Coins in this game) when its body is entered by the player object
func _on_cheese_body_entered(body):
	if body.is_in_group("Player"):
		AudioManager._collectCoin()
		Manager._Collect_Cheese()
		body.UI._CollectCheese()
		queue_free()
