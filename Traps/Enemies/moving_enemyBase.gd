extends Path3D
class_name MovingEnemiesBase


@onready var path_follow3D = $PathFollow3D
@export var ease: Tween.EaseType
@export var transition : Tween.TransitionType
@export var timeToCompletePath : int
@export var hitEffect : PackedScene
@export var hitSoundEffect : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween()

func move_tween():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(path_follow3D, "progress_ratio" , 1.0, 5).set_ease(ease).set_trans(transition)
	tween.tween_property(path_follow3D, "progress_ratio" , 0, 0.0)
	tween.bind_node(self)



func _on_homing_attack_target_on_hit():
	var cloud = hitEffect.instantiate()
	get_tree().root.add_child(cloud)
	cloud.position = $nutcracker/Hat.global_position

	var soundEffect  = hitSoundEffect.instantiate()
	get_tree().root.add_child(soundEffect)
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	
func _Reset():
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true

func _Respawn():
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true

func _on_player_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		pass
		#queue_free()
