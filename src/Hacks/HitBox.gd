extends Area2D

signal hitted_something(area)

var direction = Vector2.ZERO
export(float, 1, 100) var knockback


export(int) var damage = 1

func hitted(area):
	emit_signal("hitted_something", area)


