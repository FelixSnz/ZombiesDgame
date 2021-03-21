extends Node2D
class_name Weapon

export(int) var semi_major_axis
export(int) var semi_minor_axis
export(bool) var movement_while_running = false

var pointing_direction = Vector2.ZERO
var mouse_angle
var facing_right = true
var can_attack = true
var can_tween = true
var sprite
var tween
var animationPlayer
var player_center
var player_anim

enum {
	POINTING,
	ATTACK,
	RESET,
}

var state = POINTING


func _process(delta):
	player_center = get_parent().get_parent().global_position - Vector2(0, 4)
	pointing_direction = (get_global_mouse_position() - player_center).normalized()
	
	if facing_right:
		mouse_angle = rad2deg(pointing_direction.angle())
	else:
		mouse_angle = rad2deg(pointing_direction.angle())
		
	match state:
		POINTING:
			pointing_state(delta)
		ATTACK:
			attack_state()

func pointing_state(delta):
	rotation_degrees = mouse_angle
	var player = get_parent().get_parent()
	var player_sprite = player.get_node("Sprite")
	var player_hand = player_sprite.get_node("RightHand2")
	player_anim = player.animationPlayer.current_animation
	var extra_movement
	

	if player_anim == "Idle":
		extra_movement = player_hand.position - Vector2(5, -2)
	elif player_anim == "Run":
		if movement_while_running:
			if facing_right:
				extra_movement = player_hand.position - Vector2(2.5, -3)
			else:
				extra_movement = (player_hand.position - Vector2(2.5, -3.5)) * -1
		else:
			extra_movement = Vector2.ZERO
	else:
		extra_movement = Vector2.ZERO
		
	if is_in_ellipse(player_center, semi_major_axis, semi_minor_axis, get_global_mouse_position()):
		global_position = global_position.linear_interpolate(get_global_mouse_position(), delta * .5) + extra_movement
	else:
		var ellip_radius = get_ellipse_radius(semi_major_axis, semi_minor_axis, pointing_direction.angle())
		var diff = player_center + pointing_direction * ellip_radius
		global_position = global_position.linear_interpolate(diff, delta * 5) + extra_movement
	_pointing_state(delta)
	
	global_position = global_position 

func _input(event):
	if event.is_action_pressed("click") and can_attack:
		can_attack = false
		state = ATTACK

func get_inverse_degrees(degrees) -> int:
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return int(rad2deg(inverse_vector.angle()) + 90)

func get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

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

func facing_side_changued(side):
	if side == 1:
		facing_right = true
	else:
		facing_right = false
	_facing_side_changued(side)

func behind(boolean:bool):
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

func _pointing_state(_delta):
	pass

func _facing_side_changued(_side):
	pass

func attack_state():
	pass
