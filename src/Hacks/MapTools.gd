extends Node
class_name MapTools

func neighbors_map(map, neighbors_per_location):
	var sub_map = []
	var neighbor_count = 0
	if neighbors_per_location is int:
		neighbors_per_location = [neighbors_per_location]
	for location in map:
		var neighbors = get_neighbors(location)
		for neighbor in neighbors.values():
			if map.has(neighbor):
				neighbor_count += 1
		if neighbor_count in neighbors_per_location:
			sub_map.append(location)
		neighbor_count = 0
	return sub_map

func direction_map(map, dir):
	var neighbor_map = []
	for location in map:
		if not location + dir in map:
			neighbor_map.append(location + dir)
	return neighbor_map

#given a map of positions/cells "map" iterates over every cell
#and checks the number of adjacent cells of that cell, if the 
#number of adjacent cells matches with "surround_amount", appends
#the adjacent cell determinated by "dir_to_get" to an array to be returned
#NOTE: "surround_amount" can be an array of various permited matches
func sub_map(map, neighbors_per_location, dir):
	return direction_map(neighbors_map(map, neighbors_per_location), dir)

func random_items(arr, n):
	var new_arr = []
	while new_arr.size() < n:
		var rand_i = randi() % arr.size()
		if not arr[rand_i] in new_arr:
			new_arr.append(arr[rand_i])
	return new_arr

func get_neighbors(location):
	return {
		down = location + Vector2.DOWN, 
		top = location + Vector2.UP, 
		left = location + Vector2.LEFT, 
		right = location + Vector2.RIGHT
	}
