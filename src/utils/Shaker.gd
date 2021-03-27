extends Node

onready var timer : Timer = $Timer

export(String) var parent_property
export var amplitude : = 6.0
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration

func _process(_delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	get_parent().set_indexed(parent_property, 
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
	get_parent().set_indexed(parent_property, Vector2.ZERO)
	if shake:
		$Timer.start()

func _on_shake_requested(values):
	if values != null:
		self.amplitude = values.amplitude
		self.duration = values.duration
		self.DAMP_EASING = values.damp_easing
	self.shake = true
