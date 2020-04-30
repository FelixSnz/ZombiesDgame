extends Area2D


var player = null
var can_attack = true
onready var timer = $Timer

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	player = null


func _on_Timer_timeout():
	can_attack = true

func start_timer(duration):
	self.can_attack = false
	timer.start(duration)
	
