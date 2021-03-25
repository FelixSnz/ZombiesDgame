extends Node

export var delay_mseconds : = 15

var enabled : = true

func _ready() -> void:
	connect_to_freezers()

func _on_frame_freeze_requested() -> void:
	if not enabled:
		return
	OS.delay_msec(delay_mseconds)
	

func connect_to_freezers():
	for frame_freezer in get_tree().get_nodes_in_group("frame_freezer"):
		var already_connected = false
		if frame_freezer.get_signal_connection_list("frame_freeze_requested").size() > 0:
			already_connected = true
		if not already_connected:
#			print(camera_shaker.get_parent().name)
			frame_freezer.connect("frame_freeze_requested", self, "_on_frame_freeze_requested")


func _on_LevelGenerator_level_generated():
	connect_to_freezers()
