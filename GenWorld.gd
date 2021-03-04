extends Node

var borders = Rect2(1, 1, 260, 210)
var map = []

var Exit = preload("res://ExitDoor.tscn")
onready var tilemap = $TileMap

func _ready():
	randomize()
	generate_level()
	

func generate_level():
	var walker = Walker.new(Vector2(26, 21), borders)
	map = walker.walk(100)
	
	var player = $Player
	player.position = map.front() * 28.6

	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position * 28
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	
	for location in map:
		tilemap.set_cellv(location, 2)
		var under_cell = location + Vector2.DOWN
		var upper_cell = location + Vector2.UP
		if tilemap.get_cellv(under_cell) == -1 and tilemap.get_cellv(upper_cell) != -1:
			tilemap.set_cellv(under_cell, 5)
	tilemap.update_bitmask_region(borders.position, borders.end)

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
