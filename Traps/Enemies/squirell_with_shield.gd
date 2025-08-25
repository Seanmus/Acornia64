extends homingAttackDestroy

@export var startOffset = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if startOffset:
		$AnimationPlayer.play("toggleShield")
		$AnimationPlayer.seek(3.75, true)
