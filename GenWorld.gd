extends Node
const RECT_WIDTH = round(320/7)
const RECT_HEIGHT = round(180/7)
var borders = Rect2(1, 1, RECT_WIDTH, RECT_HEIGHT )

var Debug_part = preload("res://Effects & Particles/debugParticles.tscn")
var Exit = preload("res://ExitDoor.tscn")
var Player = preload("res://Player/Player.tscn")

onready var tilemap = $TileMap
onready var overtile = $TileMap2
var maps

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker_pos = Vector2(RECT_WIDTH/2, RECT_WIDTH/2).ceil()
	var walker = Walker.new(walker_pos, borders)
	maps = walker.walk(150)
	var rooms_map = maps.rooms
	var bridges_map = maps.bridges
	
	var count = 0
	for room in walker.rooms:
		count += 1
		var debug_part = create_instance(Debug_part, room.position * 28)
	print(count)
	var player_initial_pos = walker.get_random_room().position
	create_instance(Player, player_initial_pos * 28.5)
	
	var exit_position = walker.get_end_room(player_initial_pos).position
	var exit = create_instance(Exit, exit_position * 27.2)
	exit.connect("leaving_level", self, "reload_level")

	walker.queue_free()
	
	place_tilemap(tilemap, maps.rooms, 2, "room")
	var walls_map = walls_afer_rooms(maps.rooms)
	place_tilemap(overtile, walls_map, 0, "first wall")
	
	place_tilemap(tilemap, maps.bridges, 2, "bridge")
	walls_map = walls_after_bridges(maps.all)
	place_tilemap(overtile, walls_map, 0, "second wall")
	
	

func walls_afer_rooms(map):
	var walls_map = []
	var walls_counter = 0
	for location in map:
		var down = location + Vector2.DOWN
		if (not down in map):
			walls_counter += 1
			walls_map.append(down)
	return walls_map

func walls_after_bridges(map):
	var walls_map = []
	var counter = 0
	for cell in map:
		var surround = [
			cell + Vector2.DOWN, 
			cell + Vector2.UP, 
			cell + Vector2.LEFT, 
			cell + Vector2.RIGHT
		]
		for dir in surround:
			if map.has(dir):
				counter += 1
		if counter <= 1:
			walls_map.append(surround[0])
		counter = 0
	return walls_map
	
func place_tilemap(tiles, map, t_index, name):
	#var counter = 0
	for location in map:
		tiles.set_cellv(location, t_index)
		#counter += 1
	#print(counter," ", name, " tiles placed and the map size is: ", map.size())
	tiles.update_bitmask_region(borders.position, borders.end)

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
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			place_tilemap(tilemap, maps.rooms, 2, "room")
		if event.scancode == KEY_2:
			var walls_map = walls_afer_rooms(maps.rooms)
			place_tilemap(overtile, walls_map, 0, "first wall")
		if event.scancode == KEY_3:
			place_tilemap(tilemap, maps.bridges, 2, "bridge")
		if event.scancode == KEY_4:
			var walls_map = walls_after_bridges(maps.all)
			place_tilemap(overtile, walls_map, 0, "second wall")
		if event.scancode == KEY_5:
			tilemap.hide()
		if event.scancode == KEY_6:
			tilemap.show()
