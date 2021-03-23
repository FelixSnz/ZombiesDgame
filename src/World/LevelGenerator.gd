extends Node
const RECT_WIDTH = round(320/7)
const RECT_HEIGHT = round(180/7)
const cell_size = 28
var borders = Rect2(1, 1, RECT_WIDTH, RECT_HEIGHT )

const Debug_part = preload("res://src/Effects & Particles/debugParticles.tscn")
const Exit = preload("res://src/ExitDoor.tscn")
const Player = preload("res://src/Player/Player.tscn")
const Zombie = preload("res://src/Zombies/Zombie.tscn")
const ToxicBarrel = preload("res://src/World/ToxicBarrel.tscn")
const WoodBarrel = preload("res://src/World/WoodBarrel.tscn")

onready var tilemap = $TileMap
onready var undertile = $TileMap2
onready var overtile = $TileMap3
onready var player = $YSort/Player

var glob_counter = 0
var individual_rooms
var maps
var player_initial_pos

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	
	var walker_pos = Vector2(RECT_WIDTH/2, RECT_WIDTH/2).ceil()
	var walker = Walker.new(walker_pos, borders)
	
	maps = walker.walk(20)
	
	
	individual_rooms = walker.extract_rooms(maps.rooms) #extracting individual rooms 
	var start_room = walker.get_start_room(individual_rooms)
	
	player_initial_pos = walker.get_room_center(start_room) 
	
	player.global_position = player_initial_pos * cell_size \
	+ Vector2(cell_size/2.0, cell_size/2.0)
	
#	create_instance(Player, player_initial_pos * cell_size \
#	+ Vector2(cell_size/2.0, cell_size/2.0), $YSort)
	
	var end_room = walker.get_end_room(player_initial_pos, individual_rooms)
	var exit_position = walker.get_room_center(end_room)
	var exit = create_instance(Exit, exit_position * cell_size \
	+ Vector2(cell_size/2.0, cell_size/2.0), $YSort)
	exit.connect("leaving_level", self, "reload_level")

	walker.queue_free()

	var down_walls_map

	#placing the rooms
	place_tilemap(tilemap, maps.rooms, 2)
	#placing the walls under the rooms
	down_walls_map = MapTools.direction_map(maps.rooms, Vector2.DOWN)

	#placing the bridges
	place_tilemap(tilemap, maps.bridges, 2)

	#placing down walls under the room tiles created by the bridge map
	down_walls_map += MapTools.sub_map(maps.all, 1, Vector2.DOWN)
	place_tilemap(undertile, down_walls_map, 0)


	generate_zombies(individual_rooms, .15)
	generate_entities(ToxicBarrel, individual_rooms, .08)
	generate_entities(WoodBarrel, individual_rooms, .02)

	#loop for placing decoration tiles
	for room in individual_rooms:
		var outer_bricks = MapTools.neighbors_map(room, [2,3]) 
		var inner_bricks = MapTools.neighbors_map(room, 4)

		outer_bricks.shuffle()
		inner_bricks.shuffle()
		down_walls_map.shuffle()
		outer_bricks = MapTools.random_items(outer_bricks, round(outer_bricks.size() * 0.25))
		inner_bricks = MapTools.random_items(inner_bricks, round(inner_bricks.size() * .2))
		down_walls_map = MapTools.random_items(down_walls_map, round(down_walls_map.size() * .5))

		for location in outer_bricks:
			overtile.set_cellv(location, randi()%2 + 2)
		overtile.update_bitmask_region(borders.position, borders.end)

		for location in inner_bricks:
			var shuf_arr = [randi()%2, randi() %3 +6]
			shuf_arr.shuffle()
			overtile.set_cellv(location, shuf_arr.front())
		overtile.update_bitmask_region(borders.position, borders.end)

		for location in down_walls_map:
			if not location in maps.bridges:
				overtile.set_cellv(location, randi() % 2+ 4)

func generate_zombies(ind_rooms, porcentage):
	for room in ind_rooms:
		if player_initial_pos in room:
			continue
		var n_zombies = round(room.size() * porcentage)
		room.shuffle()
		var positions = MapTools.random_items(room, n_zombies)
		for position in positions:
			create_instance(Zombie, position * cell_size \
			+ Vector2(cell_size/2.0, cell_size/2.0), $YSort/Zombies)

func generate_entities(entity, ind_rooms, porcentage):
	var can_generate = false
	for room in ind_rooms:
		var n_barrels = round(room.size() * porcentage)
		room.shuffle()
		var positions = MapTools.random_items(room, n_barrels)
		for position in positions:
			var neighbors = MapTools.get_neighbors(position)
			for neighbor in neighbors.values():
				if not neighbor in maps.bridges:
					can_generate = true
				else:
					can_generate = false
					break
			if can_generate:
				var instance = entity.instance()
				var parent = get_node("YSort/%s" %instance.name + "s")
				parent.add_child(instance)
				instance.position = position * cell_size \
				+ Vector2(cell_size/2.0, cell_size/2.0)

func place_tilemap(tiles, map, t_index):
	if t_index is Array:
		t_index.shuffle()
		t_index = t_index.front()
	for location in map:
		tiles.set_cellv(location, t_index)
	tiles.update_bitmask_region(borders.position, borders.end)

func create_instance(Obj, pos, parent = null):
	var obj = Obj.instance()
	if parent == null:
		parent = get_tree().current_scene
	parent.add_child(obj)
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
			var walls_map = MapTools.direction_map(maps.rooms, Vector2.DOWN)
			place_tilemap(undertile, walls_map, 0)
		if event.scancode == KEY_3:
			place_tilemap(tilemap, maps.bridges, 2)
		if event.scancode == KEY_4:
			var walls_map = MapTools.sub_map(maps.all, 1, Vector2.DOWN)
			place_tilemap(undertile, walls_map, 0)
		if event.scancode == KEY_5:
			tilemap.hide()
		if event.scancode == KEY_6:
			tilemap.show()
		if event.scancode == KEY_7:
			if glob_counter < individual_rooms.size():
				place_tilemap(tilemap, individual_rooms[glob_counter], 2)
				glob_counter += 1
