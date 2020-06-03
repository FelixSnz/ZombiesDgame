extends Node2D


onready var line = $Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	noise.persistence = 0.7
	var x_pos = line.points[0].x
	var init_y = line.points[0].y
	var y_pos = init_y
	
	for i in range(0, 100):
		print("kk")
		line.add_point(Vector2(x_pos, y_pos))
		x_pos = x_pos + 2
		y_pos = init_y + round(noise.get_noise_1d(i) * 25)
	
	#print(line.points.size())
	print(x_pos, " ",  y_pos)
	print(line.points)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
