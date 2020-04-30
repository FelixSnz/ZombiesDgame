extends Area2D


var player = null
var can_attack = true
var distance = null
var prev_distance = null
var is_approaching = false
onready var timer = $Timer

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	player = null


func _on_Timer_timeout():
	can_attack = true

func _process(delta):
	if can_see_player():
		distance = self.global_position.distance_to(player.global_position)
		
		prev_distance = distance
		
		

func start_timer(duration):
	self.can_attack = false
	timer.start(duration)
	
