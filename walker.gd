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
	var rooms_map = []
	var bridges_map = []
	for step in steps:
		if steps_since_turn >= 7:
			changue_direction()
		if can_step():
			step_history.append(position)
		else:
			changue_direction()
	for location in step_history:
		var up = location + Vector2.UP
		var down = location + Vector2.DOWN
		var right = location + Vector2.RIGHT
		var left = location + Vector2.LEFT
		if (up in step_history or down in step_history) and (right in step_history or left in step_history):
			rooms_map.append(location)
		else:
			bridges_map.append(location)
	rooms = clean_rooms()
	return {
		rooms = remove_duplicates(rooms_map),
		bridges = remove_duplicates(bridges_map),
		all = remove_duplicates(step_history)
	}

func can_step():
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

func place_room(pos):
	var size = Vector2(randi() % 4 + 3, randi() % 4 + 3)
	var top_left_corner = (pos - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.grow(1).has_point(new_step):
				step_history.append(new_step)

func clean_rooms():
	var new_rooms =[]
	var positions = []
	var sizes = []
	for room in rooms:
		positions.append(room.position)
		sizes.append(room.size)
	new_rooms = doble_remove(positions, sizes)
	var new_pos = remove_duplicates(positions)
	return new_rooms

func doble_remove(arr1, arr2):
	var new_arr1 = []
	var new_rooms = []
	for i in arr1.size():
		if not arr1[i] in new_arr1:
			new_arr1.append(arr1[i])
			new_rooms.append(create_room(arr1[i], arr2[i]))
	return new_rooms

func remove_duplicates(arr):
	var new_arr = []
	for i in arr:
		if not i in new_arr:
			new_arr.append(i)
	return new_arr

func create_room(pos, size):
	return {position = pos, size = size}

func get_end_room(starting_pos):
	var end_room = rooms.front()
	for room in rooms:
		if starting_pos.distance_to(room.position) > starting_pos.distance_to(end_room.position):
			end_room = room
	#print("end room distance: ", starting_pos.distance_to(end_room.position))
	return end_room

func get_random_room():
	return rooms[randi() % rooms.size()]

