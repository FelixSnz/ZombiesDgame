extends Node
const RECT_WIDTH = round(320/7)
const RECT_HEIGHT = round(180/7)
const cell_size = 28
var borders = Rect2(1, 1, RECT_WIDTH, RECT_HEIGHT )

var Debug_part = preload("res://Effects & Particles/debugParticles.tscn")
var Exit = preload("res://ExitDoor.tscn")
var Player = preload("res://Player/Player.tscn")
var Zombie = preload("res://Zombies/Zombie.tscn")
var ToxicBarrel = preload("res://World/ToxicBarrel.tscn")
var WoodBarrel = preload("res://World/WoodBarrel.tscn")

onready var tilemap = $TileMap
onready var undertile = $TileMap2
onready var overtile = $TileMap3


var glob_counter = 0
var rooms
var maps

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	
	var walker_pos = Vector2(RECT_WIDTH/2, RECT_WIDTH/2).ceil()
	var walker = Walker.new(walker_pos, borders)
	maps = walker.walk(150)

	var player_initial_pos = walker.get_random_room().position
	create_instance(Player, player_initial_pos * cell_size + Vector2(cell_size/2, cell_size/2))
	
	var exit_position = walker.get_end_room(player_initial_pos).position
	var exit = create_instance(Exit, exit_position * cell_size + Vector2(cell_size/2, cell_size/2))
	exit.connect("leaving_level", self, "reload_level")

	walker.queue_free()


	var walls_map

	#placing the rooms
	place_tilemap(tilemap, maps.rooms, 2)

	#placing the walls under the rooms
	walls_map = sub_map(maps.rooms, range(4), Vector2.DOWN)
	place_tilemap(undertile, walls_map, 0)

	#placing the bridges
	place_tilemap(tilemap, maps.bridges, 2)

	#placing down walls under the room tiles created by the bridge map
	walls_map = sub_map(maps.all, 1, Vector2.DOWN)
	place_tilemap(undertile, walls_map, 0)

	rooms = extract_rooms(maps.rooms) #extracting individual rooms 
	
	#loop for placing decoration tiles
	for room in rooms:
		var outer_bricks = sub_map(room, [2,3]) 
		var inner_bricks = sub_map(room, 4)
		var down_bricks = sub_map(maps.rooms, range(4), Vector2.DOWN)
		outer_bricks.shuffle()
		inner_bricks.shuffle()
		down_bricks.shuffle()
		outer_bricks = random_items(outer_bricks, round(outer_bricks.size() * 0.25))
		inner_bricks = random_items(inner_bricks, round(inner_bricks.size() * .2))
		down_bricks = random_items(down_bricks, round(down_bricks.size() * .2))
		
		for location in outer_bricks:
			overtile.set_cellv(location, randi()%2 + 2)
		overtile.update_bitmask_region(borders.position, borders.end)

		for location in inner_bricks:
			var shuf_arr = [randi()%2, randi() %3 +6]
			shuf_arr.shuffle()
			overtile.set_cellv(location, shuf_arr.front())
		overtile.update_bitmask_region(borders.position, borders.end)
		
		for location in down_bricks:
			if not location in maps.bridges:
				overtile.set_cellv(location, randi() % 2+ 4)


		
	

#given an array of positions "all_rooms" returns an array of arrays
#where every array contains the positions of one individual room
func extract_rooms(all_rooms):
	var rooms_copy = all_rooms.duplicate()
	var individual_rooms = []
	var new_room = []
	var found_counter = 0
	var new_room_complete = false
	while not rooms_copy.empty():
		new_room = [rooms_copy.pop_front()]
		new_room_complete = false
		while not new_room_complete:
			for cell in maps.rooms:
				found_counter = 0
				if has_around(new_room, cell):
					if not new_room.has(cell):
						found_counter += 1
						new_room.append(cell)
						rooms_copy.erase(cell)
						break
			if found_counter == 0:
				new_room_complete = true
		individual_rooms.append(new_room)
	return individual_rooms


#given a map "cells" and an individul cell "test_cell" 
#checks if "test_cell" is around of any of the elements in "cells"
func has_around(cells, test_cell):
	var surround_cells = [
		test_cell + Vector2.DOWN, 
		test_cell + Vector2.UP, 
		test_cell + Vector2.LEFT, 
		test_cell + Vector2.RIGHT
		]
	for surr_cell in surround_cells:
		if cells.has(surr_cell):
			return true

#given a map of positions/cells "map" iterates over every cell
#and checks the number of adjacent cells of that cell, if the 
#number of adjacent cells matches with "surround_amount", returns
#the adjacent cell determinated by "dir_to_get"
#NOTE: "surround_amount" can be an array of various permited matches
func sub_map(map:Array, surround_amount, \
 dir_to_get:Vector2 = Vector2.ZERO):

	var new_map = []
	var surrounds_counter = 0
	if surround_amount is int:
		surround_amount = [surround_amount]
	for cell in map:
		var surround_cells = [
			cell + Vector2.DOWN, 
			cell + Vector2.UP, 
			cell + Vector2.LEFT, 
			cell + Vector2.RIGHT
		]
		for surround_cell in surround_cells:
			if map.has(surround_cell):
				surrounds_counter += 1
		if surrounds_counter in surround_amount:
			if not dir_to_get == Vector2.ZERO:
				if not dir_to_get + cell in map:
					new_map.append(cell + dir_to_get)
			else:
				new_map.append(cell)
		surrounds_counter = 0
	return new_map

func random_items(arr, n):
	var new_arr = []
	while new_arr.size() < n:
		var rand_i = randi() % arr.size()
		if not arr[rand_i] in new_arr:
			new_arr.append(arr[rand_i])
	return new_arr

func place_tilemap(tiles, map, t_index):
	if t_index is Array:
		t_index.shuffle()
		t_index = t_index.front()
	for location in map:
		tiles.set_cellv(location, t_index)
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
			place_tilemap(tilemap, maps.rooms, 2)
		if event.scancode == KEY_2:
			var walls_map = sub_map(maps.rooms, 3, Vector2.DOWN)
			place_tilemap(undertile, walls_map, 0)
		if event.scancode == KEY_3:
			place_tilemap(tilemap, maps.bridges, 2)
		if event.scancode == KEY_4:
			var walls_map = sub_map(maps.all, 1, Vector2.DOWN)
			place_tilemap(undertile, walls_map, 0)
		if event.scancode == KEY_5:
			tilemap.hide()
		if event.scancode == KEY_6:
			tilemap.show()
		if event.scancode == KEY_7:
			if glob_counter < rooms.size():
				place_tilemap(tilemap, rooms["room_%d" % glob_counter], 2)
				glob_counter += 1
			

