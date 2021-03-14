extends Node2D

const Slash = preload("res://Effects & Particles/SlashEffect.tscn")

var pointing_dir = Vector2.ZERO
var glob_mouse_position

onready var tween = $Tween
onready var attackAxis = $AttackAxis
onready var animationPlayer = $AnimationPlayer
onready var hitBox = $AttackAxis/Sprite/HitBox
onready var sprite = $AttackAxis/Sprite

enum {
	POINTING,
	ATTACK,
	RESET
}

var state = POINTING

func _process(_delta):
	hitBox.direction = pointing_dir
	
	match state:
		POINTING:
			pointing_state()
		ATTACK:
			attack_state()

func pointing_state():
	glob_mouse_position = get_global_mouse_position()
	pointing_dir = (glob_mouse_position - global_position).normalized()
	var mouse_angle = pointing_dir.angle()
	rotation = mouse_angle
	if get_parent().get_parent().scale.x == -1:
		rotation_degrees = get_inverse_degrees(rotation_degrees)
	
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		tween.stop_all()
		state = ATTACK
	if Input.is_action_just_released("click"):
		pass

func get_inverse_degrees(degrees):
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return rad2deg(inverse_vector.angle()) + 90

func attack_state():
	if attackAxis.rotation_degrees == 0 or attackAxis.rotation_degrees >= 350:
		animationPlayer.play("attack")
		yield(animationPlayer, "animation_finished")
		reset_position()
	elif attackAxis.rotation_degrees >= 250:
		animationPlayer.play_backwards("attack")
		yield(animationPlayer, "animation_finished")
		
	state = POINTING

func flip(boolean):
	if not animationPlayer.playback_speed < 0:
		sprite.flip_h = boolean
	else:
		sprite.flip_h = boolean

func reset_position():
	tween.interpolate_property(attackAxis, "rotation_degrees", 250, 360, 0.8, Tween.TRANS_EXPO)
	tween.interpolate_property(sprite, "rotation_degrees", 64, -32, 0.8, Tween.TRANS_EXPO)
	tween.start()
	yield(tween, "tween_completed")
	behind(true)
	flip(false)

func slash(boolean):
	var slash = Slash.instance()
	slash.scale = get_parent().get_parent().scale
	if not animationPlayer.get_playing_speed() < 0:
		if boolean:
			add_slash(slash, 180)
	else:
		if not boolean:
			slash.flip_v = true
			add_slash(slash, 180)

func add_slash(slash, initial_degrees):
	var world = get_tree().current_scene
	if slash.scale.x == -1:
		slash.rotation_degrees = get_inverse_degrees(rotation_degrees) + initial_degrees
		slash.global_position = global_position
		world.add_child(slash)
	else:
		slash.rotation_degrees = rotation_degrees
		slash.global_position = global_position
		world.add_child(slash)

func behind(boolean:bool):
	get_parent().show_behind_parent = boolean
	show_behind_parent = boolean
