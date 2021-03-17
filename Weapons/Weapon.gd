extends Node2D
class_name Weapon

var pointing_direction = Vector2.ZERO
var mouse_angle
var facing_right = true
var can_attack = true
var can_tween = true
var sprite
var tween
var animationPlayer

enum {
	POINTING,
	ATTACK,
	RESET,
}

var state = POINTING

func _process(delta):
	var parent_scale_x = get_parent().get_parent().get_node("Sprite").scale.x
	if parent_scale_x == -1:
		facing_right = false
	elif parent_scale_x == 1:
		facing_right = true
		
	pointing_direction = (get_global_mouse_position() - global_position).normalized()
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
	rotation = mouse_angle
	_pointing_state(delta)

func _input(event):
	if event.is_action_pressed("click") and can_attack:
		can_attack = false
		state = ATTACK

func is_pointing_right() -> bool:
	return rotation_degrees < 90 and rotation_degrees > -90

func get_inverse_degrees(degrees) -> int:
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return int(rad2deg(inverse_vector.angle()) + 90)

func get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

func attack_state():
	pass

func _pointing_state(_delta):
	pass
