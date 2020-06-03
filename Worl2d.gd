extends Node2D

var noise
var map_size = Vector2(100, 100)
var road_caps = Vector2(0.2, 0.02)


func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	noise.persistence = 0.7
	#make_road_map()
	#rand_bridge(10)
	test_noise(Vector2(round(rand_range(0, 4)), round(rand_range(0, 4))))
	#test_noise(Vector2.ZERO)
	
func rand_bridge(size):
	var init_pos = Vector2(rand_range(0, map_size.x), rand_range(0, map_size.y))
	var val = round(rand_range(0,3))
	
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
	
	print(directions[val])
	for i in range(1, size + 1):
		$Roads.set_cellv(init_pos + directions[val] * i, 2)
	
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(init_pos.x + map_size.x, init_pos.y + map_size.y))
	
	
func test_noise(init_pos):
	
	var x_pos = init_pos.x
	var init_y = init_pos.y
	var y_pos
	var stride = 0
	$Roads.set_cell(x_pos, init_y, 2)
	for i in range(0,15):
		x_pos = x_pos + 1
		y_pos = init_y + round(noise.get_noise_1d(i) * 5)
		$Roads.set_cell(x_pos, y_pos, 2)
		if y_pos >= 0:
			stride = 1
		else:
			stride = -1
		print(stride, ": ", y_pos)
		for i in range(0, y_pos, stride):
			$Roads.set_cell(x_pos, i, 2)
			
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(init_pos.x + map_size.x, init_pos.y + map_size.y))

	
	
func make_road_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < road_caps.x and a > road_caps.y:
				print("kk")
				$Roads.set_cell(x,y,2)
				
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	

				
				

