extends Weapon
class_name FireArm

export(PackedScene) var bullet
export(PackedScene) var fireShot

var init_nuzzle_position

func _pointing_state(_delta):
	if not facing_right:
		sprite.flip_v = true
	else:
		sprite.flip_v = false

#	if not tween.is_active():
#		if is_pointing_right():
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
#		else:
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)
