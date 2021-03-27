extends Node

export(Array, Dictionary) var shaker_dicts = [
	{
		"amplitude" : 6,
		"duration" : 0.8,
		"damp_easing" : 1.0
	},
	{
		"amplitude" : 3,
		"duration" : 0.1,
		"damp_easing" : .5
	},
	{
		"amplitude" : 5,
		"duration" : 0.12,
		"damp_easing" : .5
	},
	{
		"amplitude" : 8,
		"duration" : 0.15,
		"damp_easing" : .5
	},
	{
		"amplitude" : 12,
		"duration" : 0.18,
		"damp_easing" : .5
	},
	{
		"amplitude" : 3,
		"duration" : 0.8,
		"damp_easing" : .5
	},
	{
		"amplitude" : 5,
		"duration" : 0.8,
		"damp_easing" : .5
	},
	{
		"amplitude" : 8,
		"duration" : 0.8,
		"damp_easing" : .5
	}
]

enum shake_types {
	DEFAULT,
	SHORT_NARROW,
	SHORT_NORMAL,
	SHORT_WIDE,
	SHORT_SUPER_WIDE,
	LONG_NARROW,
	LONG_NORMAL,
	LONG_WIDE
}

signal camera_shake_requested(values)
signal frame_freeze_requested


func send_shake_request(shake_type):
	emit_signal("camera_shake_requested", shaker_dicts[shake_type])
	emit_signal("frame_freeze_requested")
