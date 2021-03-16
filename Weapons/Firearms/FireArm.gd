extends Weapon
class_name FireArm

export(PackedScene) var bullet
export(PackedScene) var fireShot

var init_nuzzle_position

func _pointing_state():
	rotation_degrees = mouse_angle
	
	if not facing_right:
		facing_right = false
		sprite.flip_v = true
		if not tween.is_active() and not position == Vector2(-6, -2) and can_tween:
			can_tween = not can_tween
			move_hand(Vector2(-6, -2))
	else:
		facing_right = true
		sprite.flip_v = false
		if not tween.is_active() and not position == Vector2(0, -2) and not can_tween:
			move_hand(Vector2(0, -2))
			can_tween = not can_tween

	if not tween.is_active():
		if is_pointing_right():
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
		else:
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)

func move_hand(final_pos):
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(self, "position", \
	position, final_pos, .3, Tween.TRANS_CUBIC)
	tween.start()
