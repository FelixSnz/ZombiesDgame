extends Node2D


onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
var interpolation = .01

func _ready():
	pass # Replace with function body.

func _process(delta):
	if playerDetectionZone.can_see_player():
		interpolation += 0.4
		animationPlayer.stop()
		var player = playerDetectionZone.player
		global_position = global_position.linear_interpolate(player.global_position, interpolation * delta)
		if MathTools.is_in_circle(player.global_position, 3, global_position):
			player.stats.energy += 20
			queue_free()
