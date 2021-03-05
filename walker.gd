extends Node
class_name Walker


const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps):
	place_room(position)
	var room_map = []
	var hall_map = []
	for step in steps:
		if steps_since_turn >= 7:
			changue_direction()
		if step():
			step_history.append(position)
		else:
			changue_direction()
	for location in step_history:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		if (up in step_history or down in step_history) and (right in step_history or left in step_history):
			room_map.append(location)
		else:
			hall_map.append(location)
	return [room_map, hall_map, step_history]

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func changue_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(pos):
	var size = Vector2(randi() % 3 + 3, randi() % 3 + 3)
	var top_left_corner = (pos - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room(starting_pos):
	var end_room = rooms.pop_front()
	for room in rooms:
		if starting_pos.distance_to(room.position) > starting_pos.distance_to(end_room.position):
			end_room = room
	return end_room

