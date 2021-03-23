extends Control

var maximum = 100
var current_health = 0
var values_scalar = 10 

export var amplitude : = 6.0
export var duration : = .35 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

onready var timer = $Timer

var enabled : = true

func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration


func _process(_delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	$Count.rect_position = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _on_camera_shake_requested() -> void:
	if not enabled:
		return
	self.shake = true


func set_duration(value: float) -> void:
	duration = value
	$Timer.wait_time = duration


func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	$Count.rect_position = Vector2.ZERO
	if shake:
		timer.start()
	print(shake)

func initialize(max_val):
	$TextureProgress.max_value = max_val * values_scalar
	maximum = max_val * values_scalar

func _on_Interface_health_updated(new_health):
	animate_value(current_health, new_health * values_scalar)
	update_count_text(new_health)
	current_health = new_health * values_scalar

func animate_value(start, end):
	$Tween.interpolate_property($TextureProgress, "value", start, end, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if end < start:
		pass
		$AnimationPlayer.play("NumberShake")
		_on_camera_shake_requested()
		

func update_count_text(value):
	$Count/Number.text = str(clamp(round(value / values_scalar), 0, maximum)) + '/' + str(maximum/values_scalar) + "Hp"


func _on_Stats_health_changed(value):
	animate_value(current_health, value * values_scalar)
	update_count_text(value)
	current_health = value * values_scalar


func _on_Timer_timeout():
	self.shake = false
