extends Area3D

var planted :bool
signal seedPlanted
func _ready():
	$sunflower.visible = false
	planted = false
func _on_flower_pot_body_entered(body):
	if body.is_in_group("Player") && Manager.seedCount > 0 && not planted:
		Manager.seedCount -= 1
		Manager._planted()
		emit_signal("seedPlanted")
		planted = true
		$sunflower.visible = true
		$growAnim.play("grow")
		$sound.play()
