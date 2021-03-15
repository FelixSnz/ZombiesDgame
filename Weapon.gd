extends Node2D
class_name Weapon

var glob_mouse_position = Vector2.ZERO
var pointing_direction = Vector2.ZERO
var facing_right = true
var can_attack = true
var can_tween = true
var sprite
var tween
var animationPlayer
var tween_counter = 0
var prev_positions = []
enum {
	POINTING,
	ATTACK,
	RESET
}

var state = POINTING

func _ready():
	if $Tween != null:
		tween = $Tween

func _process(delta):
#	if is_in_group("Melee"):
#		print(animationPlayer.is_playing())
	match state:
		POINTING:
			pointing_state()
		ATTACK:
			attack_state()

func pointing_state():
	
	glob_mouse_position = get_global_mouse_position()
	pointing_direction = (glob_mouse_position - global_position).normalized()
	var mouse_angle = pointing_direction.angle()
	rotation = mouse_angle
	
	var parent_scale_x = get_parent().get_parent().get_node("Sprite").scale.x
	if parent_scale_x == -1:
		facing_right = false
		if is_in_group("FireArm"):
			sprite.flip_v = true
		if not tween.is_active() and not position == Vector2(-6, -2) and can_tween:
#			if is_in_group("Melee"):
#				if animationPlayer.is_playing():
#					animationPlayer.stop()
#					can_attack = true
#					tween.stop_all()
			can_tween = not can_tween
			move_hand(Vector2(-6, -2))
	elif parent_scale_x == 1:
		facing_right = true
		if is_in_group("FireArm"):
			sprite.flip_v = false
		if not tween.is_active() and not position == Vector2(0, -2) and not can_tween:
#			if is_in_group("Melee"):
#				if animationPlayer.is_playing():
#					animationPlayer.stop()
#					tween.stop_all()
#					can_attack = true
			move_hand(Vector2(0, -2))
			can_tween = not can_tween
	if not tween.is_active():
		if is_pointing_right():
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
		else:
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)
	_pointing_state()

func move_hand(final_pos):
	if is_in_group("Melee"):
		if animationPlayer.is_playing():
			animationPlayer.stop()
			can_attack = true
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(self, "position", \
	position, final_pos, .3, Tween.TRANS_CUBIC)
	tween.start()

func is_pointing_right():
	return rotation_degrees < 90 and rotation_degrees > -90

func _input(event):
	if event.is_action_pressed("click") and can_attack:
		can_attack = false
#		print("moving to attack state")
		state = ATTACK

func get_inverse_degrees(degrees):
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return rad2deg(inverse_vector.angle()) + 90

func get_mouse_direction():
	return (glob_mouse_position - global_position).normalized()

func attack_state():
	pass

func _pointing_state():
	pass
