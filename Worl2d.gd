extends Node2D

var noise
var map_size = Vector2(10, 10)
var grass_cap = 0.5
var road_caps = Vector2(0.2, 0.03)
var enviroment_caps = Vector3(0.4, 0.3, 0.04)

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	noise.persistence = 0.7
	#make_grass_map()
	#make_road_map()
	#make_enviroment_map()
	#make_background()
	rand_bridge(10)
	
func rand_bridge(size):
	var init_pos = Vector2(rand_range(0, map_size.x), rand_range(0, map_size.y))
	var val = round(rand_range(0,3))
	
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
	
	print(directions[val])
	for i in range(1, size + 1):
		$Roads.set_cellv(init_pos + directions[val] * i, 2)
	
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(init_pos.x + map_size.x, init_pos.y + map_size.y))
	
	
	

	
	
func make_road_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < road_caps.x and a > road_caps.y:
				print("kk")
				$Roads.set_cell(x,y,2)
				
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	

				
				

