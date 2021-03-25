extends Node

onready var timer : Timer = $Timer

export(NodePath) var node_path
export(String) var node_property
export var amplitude : = 6.0
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake
var node_to_shake

func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration
	node_to_shake = get_node_or_null(node_path)

func _process(_delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	
	if node_to_shake != null:
		node_to_shake.set_indexed(node_property, 
		Vector2 (
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)
		)

func _on_ShakeTimer_timeout() -> void:
	self.shake = false

func set_duration(value: float) -> void:
	duration = value
	if timer != null:
		timer.wait_time = duration

func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	if node_to_shake != null:
		node_to_shake.set_indexed(node_property, Vector2.ZERO)
	if shake:
		timer.start()

func _on_shake_requested():
	self.shake = true
