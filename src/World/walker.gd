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
	for _i in steps:
		if steps_since_turn >= 7:
			changue_direction()
		if can_step():
			step_history.append(position)
		else:
			changue_direction()
	for step in step_history:
		var neighbors = MapTools.get_neighbors(step)
		if (neighbors.top in step_history or neighbors.down in step_history) \
		and (neighbors.right in step_history or neighbors.left in step_history):
			rooms_map.append(step)
		else:
			bridges_map.append(step)
	rooms = clean_rooms()
	return {
		rooms = remove_duplicates(rooms_map),
		bridges = remove_duplicates(bridges_map),
		all = remove_duplicates(step_history)
	}
	
#given an array of positions "all_rooms" returns an array of arrays
#where every array contains the positions of one individual room
func extract_rooms(all_rooms):
	var rooms_copy = all_rooms.duplicate()
	var individual_rooms = []
	var new_room = []
	var new_room_complete = false
	while not rooms_copy.empty():
		new_room = [rooms_copy.pop_front()]
		new_room_complete = false
		while not new_room_complete:
			for cell in all_rooms:
				if has_around(new_room, cell):
					if not new_room.has(cell):
						new_room_complete = false
						new_room.append(cell)
						rooms_copy.erase(cell)
						break
					else:
						new_room_complete = true
		individual_rooms.append(new_room)
	return individual_rooms

#given a map "cells" and an individul cell "test_cell" 
#checks if "test_cell" is around of any of the elements in "cells"
func has_around(map, location):
	var neighbors = MapTools.get_neighbors(location)
	for neighbor in neighbors.values():
		if map.has(neighbor):
			return true

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

func get_room_center(room):
	var x_min = room.front().x
	var x_max = room.front().x
	var y_min = room.front().y
	var y_max = room.front().y
	for vector in room:
		if vector.x < x_min:
			x_min = vector.x
		if vector.x > x_max:
			x_max = vector.x
		if vector.y < y_min:
			y_min = vector.y
		if vector.y > y_max:
			y_max = vector.y
	var center = Vector2(round((x_max - x_min)/2) + x_min, \
	round((y_max - y_min)/2) + y_min)
	
	var neighbors = MapTools.get_neighbors(center)
	for neighbor in neighbors.values():
		if not neighbor in room or not center in room:
			var sub_map = MapTools.neighbors_map(room, 4)
			center = sub_map[randi() % sub_map.size()]
	return center

func get_end_room(starting_pos, ind_rooms):
	var end_room = ind_rooms.front()
	var end_room_position = get_room_center(end_room)
	for room in ind_rooms:
		var room_position = get_room_center(room)
		if starting_pos.distance_to(room_position) \
		> starting_pos.distance_to(end_room_position):
			if room_position in room and room.size():
				end_room = room
				end_room_position = get_room_center(end_room)
	return end_room

func get_start_room(ind_rooms):
	var min_room = ind_rooms.front()
	for room in ind_rooms:
		if room.size() < min_room.size():
			min_room = room
	return min_room
	
func get_random_room():
	return rooms[randi() % rooms.size()]

