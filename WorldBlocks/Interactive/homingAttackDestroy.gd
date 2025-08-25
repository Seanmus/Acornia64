class_name homingAttackDestroy

extends homingAttackTarget

@export var parent : Node3D
@export var hitEffect : PackedScene
@export var hitSoundEffect : PackedScene

func _Hit():
	super()
	var cloud = hitEffect.instantiate()
	get_tree().root.add_child(cloud)
	cloud.position = global_position

	var soundEffect  = hitSoundEffect.instantiate()
	get_tree().root.add_child(soundEffect)
	parent.process_mode = Node.PROCESS_MODE_DISABLED
	parent.visible = false

func _Reset():
	super()

func _Respawn():	
	parent.process_mode = Node.PROCESS_MODE_INHERIT
	parent.visible = true
