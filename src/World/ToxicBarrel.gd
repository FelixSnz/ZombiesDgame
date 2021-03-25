extends StaticBody2D

func _ready():
	$Particles2D.emitting = false
	var rnd_idx = int(rand_range(0, 4))
	$Sprite.frame = rnd_idx
	if rnd_idx < 2:
		$Particles2D.emitting = true
