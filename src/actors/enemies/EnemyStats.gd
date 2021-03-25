extends Node

signal camera_shake_requested

export(int) var max_health setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	if value < health:
		emit_signal("camera_shake_requested")
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed")

func _ready():
	self.health = max_health
