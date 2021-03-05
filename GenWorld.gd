extends Node
const RECTX = 320/7
const RECTY = 180/7
var borders = Rect2(1, 1, RECTX, RECTY)
var maps = []

var Debug_part = preload("res://Effects & Particles/debugParticles.tscn")
var Exit = preload("res://ExitDoor.tscn")
var Barrel = preload("res://World/ToxicBarrel.tscn")
var Player = preload("res://Player/Player.tscn")
onready var tilemap = $TileMap
onready var overtile = $TileMap2

func _ready():
	randomize()
	generate_level()
	
func create_instance(Obj, pos):
	var obj = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(obj)
	obj.position = pos


func generate_level():
	var walker = Walker.new(Vector2(RECTX/2, RECTY/2), borders)
	maps = walker.walk(200)
	var rooms_map = maps[0]
	var halls_map = maps[1]
	var all_map = maps[2]
	
	#var player = $PlayerS
	#player.position = map.front() * 28.6
	var rooms = walker.rooms
	var player_initial_pos = rooms[randi() % rooms.size()].position
	#var player_initial_pos = map.front()
	player_initial_pos  *= 28
	player_initial_pos.x += 14
	player_initial_pos.y += 14
	create_instance(Player, player_initial_pos)
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room(player_initial_pos).position * 28
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	
	#locationg rooms
	for location in rooms_map:
		tilemap.set_cellv(location, 2)
	
	#locating down walls
	for location in rooms_map:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		if (tilemap.get_cellv(left) == -1 or tilemap.get_cellv(right) == -1) and tilemap.get_cellv(down) == -1:
			overtile.set_cellv(down, 0)
		if tilemap.get_cellv(down) == -1 and tilemap.get_cellv(up) != -1 and tilemap.get_cellv(up) != 5:
			overtile.set_cellv(down, 0)
	
	
	#locating hall ways
	for location in halls_map:
		tilemap.set_cellv(location, 2)
	for location in halls_map:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		if (tilemap.get_cellv(left) == -1 or tilemap.get_cellv(right) == -1) and tilemap.get_cellv(down) == -1:
			overtile.set_cellv(down, 0)
	overtile.update_bitmask_region(borders.position, borders.end)
	tilemap.update_bitmask_region(borders.position, borders.end)

	

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()

func check_kk(rooms_map):
	for location in rooms_map:
		tilemap.set_cellv(location, 2)
	tilemap.update_bitmask_region(borders.position, borders.end)
	for location in rooms_map:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		
		if tilemap.get_cellv(down) == -1 and tilemap.get_cellv(up) != -1 and tilemap.get_cellv(up) != 5:
			overtile.set_cellv(down, 5)
			
		if (tilemap.get_cellv(left) == -1 or tilemap.get_cellv(right) == -1) and tilemap.get_cellv(down) == -1:
			overtile.set_cellv(down, 5)
	
	
	for location in maps:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		
		if tilemap.get_cellv(down) == -1 and tilemap.get_cellv(up) != -1 and tilemap.get_cellv(up) != 5:
			tilemap.set_cellv(down, 5)
			
		if (tilemap.get_cellv(left) == -1 or tilemap.get_cellv(right) == -1) and tilemap.get_cellv(down) == -1:
			tilemap.set_cellv(down, 5)
		
		
		if (tilemap.get_cellv(left) == 5 or tilemap.get_cellv(right) == 5) and tilemap.get_cellv(down) == 2:
			overtile.set_cellv(location, 1)
			var range_x = rand_range(-1.2, 1.2)
			var range_y = rand_range(-1.2, 1.2)
			var pos = Vector2.ZERO
			pos.x = location.x + range_x
			pos.y = location.y + range_y
			create_instance(Debug_part, pos * 28.5)
	tilemap.update_bitmask_region(borders.position, borders.end)
