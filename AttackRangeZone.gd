extends Node2D

var player = null
var can_attack = true

onready var timer = $Timer

func has_player():
	return player != null

func get_cooldown_left():
	return timer.time_left

func start_cooldown(duration):
	can_attack = false
	timer.start(duration)

func _on_EnabledZone_body_entered(body):
	player = body

func _on_EnabledZone_body_exited(_body):
	player = null

func _on_DisabledZone_body_entered(_body):
	player = null

func _on_DisabledZone_body_exited(body):
	player = body

func _on_Timer_timeout():
	can_attack = true
