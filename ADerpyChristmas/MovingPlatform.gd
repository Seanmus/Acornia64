extends Node3D


@export var targetPos: Vector3
@onready var startPosition = position

var movingTowards = true
var paused = true

var time = 0
@export var waitTime = 4
@export var timeToTarget = 3


@onready var waitTimer = $WaitTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	waitTimer.wait_time = waitTime


func _process(delta):
	if paused:
		return
		
	if movingTowards:
		time += delta
	else:
		time -= delta
	time = clamp(time, 0, timeToTarget)
	position = lerp(startPosition, targetPos, time / timeToTarget)
	if position == targetPos:
		paused = true
		waitTimer.start()
		time -= delta
		movingTowards = false
	if position == startPosition:
		paused = true
		waitTimer.start()
		movingTowards = true
		time += delta


func _on_wait_timer_timeout():
	paused = false
