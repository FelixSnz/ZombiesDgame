extends Particles2D



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	print(process_material.get("color"))
	var rand_r = rand_range(0, 10)
	var rand_g = rand_range(0, 10)
	var rand_b = rand_range(0, 10)
	process_material.set("color", Color(rand_r,rand_g,rand_b))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
