extends Area2D


var invincible = false setget set_invincibility

signal invincibility_started
signal invincibility_ended


onready var timer = $Timer

func set_invincibility(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincivility(duration):
	timer.start(duration)
	self.invincible = true

func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable", false)


func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", true)


func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_area_entered(area):
	if area.is_in_group("bullets"):
		area.get_parent().create_impact()
	area.has_hit_something()

