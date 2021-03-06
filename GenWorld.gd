extends Node
const RECT_WIDTH = round(320/7)
const RECT_HEIGHT = round(180/7)
var borders = Rect2(1, 1, RECT_WIDTH, RECT_HEIGHT )

var Debug_part = preload("res://Effects & Particles/debugParticles.tscn")
var Exit = preload("res://ExitDoor.tscn")
var Player = preload("res://Player/Player.tscn")

onready var tilemap = $TileMap
onready var overtile = $TileMap2

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(RECT_WIDTH/2, RECT_WIDTH/2), borders)
	var maps = walker.walk(200)
	var rooms_map = maps.rooms
	var bridges_map = maps.bridges
	
	var player_initial_pos = walker.get_random_room().position
	create_instance(Player, player_initial_pos * 28)
	
	var exit_position = walker.get_end_room(player_initial_pos).position
	var exit = create_instance(Exit, exit_position * 27.2)
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	
	generate_map(rooms_map)
	generate_map(bridges_map)
	#print((bridges_map.size() + rooms_map.size())/4)

func generate_map(map):
	var walls_counter = 0
	for location in map:
		tilemap.set_cellv(location, 2)
	tilemap.update_bitmask_region(borders.position, borders.end)
	for location in map:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		if tilemap.get_cellv(down) == -1 and tilemap.get_cellv(up) != -1 and tilemap.get_cellv(up) != 5:
			overtile.set_cellv(down, 0)
			walls_counter += 1
			#create_instance(Debug_part, down*28.5)
		if (tilemap.get_cellv(left) == -1 or tilemap.get_cellv(right) == -1) and tilemap.get_cellv(down) == -1:
			overtile.set_cellv(down, 0)
			walls_counter += 1
			#create_instance(Debug_part, down*28.5)
		
		overtile.update_bitmask_region(borders.position, borders.end)
	print(walls_counter)

func create_instance(Obj, pos):
	var obj = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(obj)
	obj.position = pos
	return obj

func reload_level():
	var _err = get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
