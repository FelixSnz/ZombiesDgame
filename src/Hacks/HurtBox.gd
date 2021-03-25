extends Area2D


var invincible = false setget set_invincibility

signal invincibility_started
signal invincibility_ended
signal camera_shake_requested
signal frame_freeze_requested

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
	area.hitted(self)
	if area.is_in_group("shake_trigger"):
		emit_signal("camera_shake_requested")
	if area.is_in_group("freeze_trigger"):
		emit_signal("frame_freeze_requested")
