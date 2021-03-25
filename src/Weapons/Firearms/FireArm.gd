extends Weapon
class_name FireArm

onready var sprite = $Sprite

export(float, 0, 6) var sight_elevation = 0
export(PackedScene) var bullet
export(PackedScene) var fireShot

var init_muzzle_position

func _pointing_state(_delta):
	look_at(get_global_mouse_position() + Vector2(0, sight_elevation))
	if not facing_right:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
