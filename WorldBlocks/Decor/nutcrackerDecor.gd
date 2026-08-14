extends Node3D


@onready var player = get_tree().get_nodes_in_group("Player")
@onready var startingxRot = rotation.x
@onready var startingzRot = rotation.z
func _process(_delta: float) -> void:
	if !Manager.won and player:
		look_at(player[0].global_position)
		rotation.x = startingxRot
		rotation.z = startingzRot

func _play_Laugh():
	$AnimationPlayer.play("laugh")
	$Laugh.play()
