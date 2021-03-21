extends Area2D

var direction = Vector2.ZERO
export(float, 1, 100) var knockback
signal camera_shake_requested

export(int) var damage = 1 setget set_damage, get_damage

func get_damage():
	emit_signal("camera_shake_requested")
	return damage

func set_damage(value):
	damage = value
