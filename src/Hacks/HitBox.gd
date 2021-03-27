extends Area2D

signal hit_something

var direction = Vector2.ZERO
export(float, 1, 100) var knockback
export(int) var damage = 1
var default_damage

func _ready():
	default_damage = damage
	

func has_hit_something():
	emit_signal("hit_something")
	

