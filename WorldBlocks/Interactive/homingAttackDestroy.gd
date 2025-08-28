class_name homingAttackDestroy

extends homingAttackTarget

@export var parent : Node3D
@export var hitEffect : PackedScene
@export var hitSoundEffect : PackedScene

func _Hit():
	super()
	_SpawnCloud()

	var soundEffect  = hitSoundEffect.instantiate()
	get_tree().root.add_child(soundEffect)
	parent.process_mode = Node.PROCESS_MODE_DISABLED
	parent.visible = false

func _SpawnCloud():
	var cloud = hitEffect.instantiate()
	get_tree().root.add_child(cloud)
	cloud.position = global_position

func _Reset():
	super()

func _Respawn():	
	parent.process_mode = Node.PROCESS_MODE_INHERIT
	parent.visible = true
	_SpawnCloud()
