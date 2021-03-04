extends Node

var borders = Rect2(1, 1, 200, 260)
var map = []

var Exit = preload("res://ExitDoor.tscn")
onready var tilemap = $TileMap

func _ready():
	randomize()
	generate_level()
	

func generate_level():
	var walker = Walker.new(Vector2(1, 1), borders)
	map = walker.walk(100)
	
	var player = $Player
	player.position = walker.get_end_room().position * 28

	var exit = Exit.instance()
	#add_child(exit)
	#exit.position = walker.get_end_room().position * 28
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	
	for location in map:
		tilemap.set_cellv(location, 2)
	tilemap.update_bitmask_region(borders.position, borders.end)

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
	
func rand_position():
	var x_range = Vector2(1, 200)
	var y_range = Vector2(1, 260)
	var random_x = randi() % int(x_range[1]- x_range[0]) + 1 + x_range[0] 
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(random_x, random_y)
	return random_pos

func spawn_player():
	var rand_pos = rand_position()
	while not rand_pos in map:
		rand_pos = rand_position()
	print(rand_pos)
	var player = $Player
	rand_pos = rand_pos * 28
	rand_pos.x = rand_pos.x - 14
	rand_pos.y = rand_pos.y - 14
	player.global_position = rand_pos


