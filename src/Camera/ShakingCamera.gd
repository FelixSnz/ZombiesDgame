extends Camera2D

onready var shaker = $Shaker

func _ready():
	connect_to_shakers()

func connect_to_shakers() -> void:
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		var already_connected = false
		if camera_shaker.get_signal_connection_list("camera_shake_requested").size() > 0:
			already_connected = true
		if not already_connected:
			camera_shaker.connect("camera_shake_requested", shaker, "_on_shake_requested")

func _on_Player_weapon_changued():
	connect_to_shakers()
