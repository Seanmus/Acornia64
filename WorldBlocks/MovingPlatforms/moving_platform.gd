extends Path3D
class_name MovingPlatforms


@onready var path_follow3D = $PathFollow3D
@export var ease: Tween.EaseType
@export var transition : Tween.TransitionType
@export var timeToCompletePathOneWay : int
# Called when the node enters the scene tree for the first time.
func _ready():
	move_tween()

func move_tween():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(path_follow3D, "progress_ratio" , 1.0, 5).set_ease(ease).set_trans(transition)
	tween.tween_property(path_follow3D, "progress_ratio" , 0, 5).set_ease(ease).set_trans(transition)
