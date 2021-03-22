extends Node2D
class_name Weapon

export(int) var semi_major_axis
export(int) var semi_minor_axis

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
var parent_scale_x

enum {
	POINTING,
	ATTACK,
}

var state = POINTING

func _ready():
#	print("weapon started")
	parent_scale_x = Global.player.sprite.scale.x
	if parent_scale_x == 1:
		facing_right = true
	else:
		facing_right = false
	_on_ready()

func _process(delta):
	player_center = Global.player.global_position - Vector2(0, 4)
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

func _input(event):
	if event.is_action_pressed("click") and can_attack:
		can_attack = false
		state = ATTACK

func pointing_state(delta):
	rotation_degrees = mouse_angle
	player_anim = Global.player.animationPlayer.current_animation
	
	var extra_mov = get_extra_movement()
	
	if is_in_group("Melee"):
		update_position(delta, extra_mov)
	else:
		update_position(delta)
		
	_pointing_state(delta)

func get_extra_movement():
	var player_hand = Global.player.rightHand2
	var extra_movement
	if player_anim == "Idle":
		extra_movement = player_hand.position - Vector2(5, -2)
	elif player_anim == "Run":
		if is_in_group("Melee"):
			if facing_right:
				extra_movement = player_hand.position - Vector2(2.5, -3)
			else:
				extra_movement = (player_hand.position - Vector2(2.5, -3.5)) * -1
		else:
			extra_movement = Vector2.ZERO
	else:
		extra_movement = Vector2.ZERO
	return extra_movement

func update_position(delta, extra_movement:Vector2 = Vector2.ZERO):
	if MathTools.is_in_ellipse(player_center, semi_major_axis, semi_minor_axis, get_global_mouse_position()):
		global_position = global_position.linear_interpolate(get_global_mouse_position(), delta * .5) + extra_movement
	else:
		var ellip_radius = MathTools.get_ellipse_radius(semi_major_axis, semi_minor_axis, pointing_direction.angle())
		var diff = player_center + pointing_direction * ellip_radius
		global_position = global_position.linear_interpolate(diff, delta * 5) + extra_movement

func facing_side_changued(side):
	if side == 1:
		facing_right = true
	else:
		facing_right = false
	_facing_side_changued(side)

func get_inverse_degrees(degrees) -> int:
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return int(rad2deg(inverse_vector.angle()) + 90)

func get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()



func behind(boolean:bool):
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

func _pointing_state(_delta):
	pass

func _facing_side_changued(_side):
	pass

func player_anim_changued(_anim_name):
	pass

func attack_state():
	pass

func _on_ready():
	pass
