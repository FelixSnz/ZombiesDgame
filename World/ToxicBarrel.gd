extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Particles2D.emitting = false
	var rnd_idx = int(rand_range(0, 4))
	$Sprite.frame = rnd_idx
	if rnd_idx < 2:
		$Particles2D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
