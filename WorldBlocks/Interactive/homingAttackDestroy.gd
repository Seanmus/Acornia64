extends CollisionShape3D

@export var parent : Area3D
@export var hitEffect : PackedScene
@export var hitSoundEffect : PackedScene

func _on_homing_attack_target_on_hit() -> void:
	var cloud = hitEffect.instantiate()
	get_tree().root.add_child(cloud)
	cloud.position = global_position

	var soundEffect  = hitSoundEffect.instantiate()
	get_tree().root.add_child(soundEffect)
	parent.process_mode = Node.PROCESS_MODE_DISABLED
	parent.visible = false

func _Reset():
	parent.process_mode = Node.PROCESS_MODE_INHERIT
	parent.visible = true
