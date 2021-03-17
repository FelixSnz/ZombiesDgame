extends Weapon
class_name FireArm

export(PackedScene) var bullet
export(PackedScene) var fireShot

var init_nuzzle_position

func is_in_circle(circle_position, radius, vector):
	return pow(vector.x - circle_position.x, 2) + \
	pow(vector.y - circle_position.y, 2) < pow(radius, 2)

func is_in_ellipse(ellipse_position, x_axis, y_axis, vector):
	var term1 = pow(vector.x - ellipse_position.x, 2)/pow(x_axis, 2)
	var term2 = pow(vector.y - ellipse_position.y, 2)/pow(y_axis, 2)
	return term1 + term2 <= 1
func get_ellipse_radius(a, b, angle):
	var r = a*b/sqrt(pow(a, 2) * pow(sin(angle), 2) + pow(b, 2) * pow(cos(angle), 2) )
	return r

func _pointing_state(delta):
	rotation_degrees = mouse_angle

	var center
	if facing_right:
		center = get_parent().global_position + Vector2(-6, -3)
	else:
		center = get_parent().global_position + Vector2(0, -3)
	center = get_parent().get_parent().global_position - Vector2(0, 5)

	if is_in_ellipse(center, 5, 2, get_global_mouse_position()):
		global_position = global_position.linear_interpolate(get_global_mouse_position(), delta * .5)
	else:
		var ellip_radius = get_ellipse_radius(5, 2, pointing_direction.angle())
		var diff = center + pointing_direction * ellip_radius
		global_position = global_position.linear_interpolate(diff, delta * 5)
	
	if not facing_right:
		facing_right = false
		sprite.flip_v = true
#		if not tween.is_active() and not position == Vector2(-6, -2) and can_tween:
#			can_tween = not can_tween
#			move_hand(Vector2(-6, -2))
	else:
		facing_right = true
		sprite.flip_v = false
#		if not tween.is_active() and not position == Vector2(0, -2) and not can_tween:
#			move_hand(Vector2(0, -2))
#			can_tween = not can_tween

#	if not tween.is_active():
#		if is_pointing_right():
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
#		else:
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)

#func move_hand(final_pos):
#	if tween.is_active():
#		tween.stop_all()
#	tween.interpolate_property(self, "position", \
#	position, final_pos, .3, Tween.TRANS_CUBIC)
#	tween.start()
