extends Node2D

const Slash = preload("res://Effects & Particles/SlashEffect.tscn")

var pointing_dir = Vector2.ZERO
var dir = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var init_degrees

export(float) var test_var

onready var animationPlayer = $AnimationPlayer
onready var hitBox = $AttackAxis/HandlePosition/HitBox
onready var handlePosition = $AttackAxis/HandlePosition
onready var sprite = $AttackAxis/HandlePosition/Sprite
onready var attackAxis = $AttackAxis

enum {
	POINTING,
	ATTACK,
	RESET
}

var state = POINTING

func _ready():
	#print(handPosition.name)
	pass

func _process(delta):
	hitBox.direction = pointing_dir
	match state:
		POINTING:
			pointing_state()
#			print(sprite.rotation_degrees)
#			if sprite.rotation_degrees >= 250:
#				sprite.rotation_degrees += 70 * delta
#				if sprite.rotation_degrees > 320:
#					behind(true)
#					sprite.flip_h = false
#				if sprite.rotation_degrees >= 360:
#					sprite.rotation_degrees = 0
		ATTACK:
			attack_state()

func pointing_state():
	dir = get_local_mouse_position()
	pointing_dir = (get_global_mouse_position() - global_position).normalized()
	var angle = dir.angle() 
	update_rotation(angle)
	
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
	if Input.is_action_just_released("click"):
		pass

func attack_state():
	if attackAxis.rotation_degrees == 0:
		add_child(Slash.instance())
		animationPlayer.play("attack")
		yield(animationPlayer, "animation_finished")
	elif attackAxis.rotation_degrees == 250:
		var slash = Slash.instance()
		slash.flip_v = true
		add_child(slash)
		animationPlayer.play_backwards("attack")
		yield(animationPlayer, "animation_finished")
	
	state = POINTING

func behind(boolean:bool):
	get_parent().show_behind_parent = boolean
	show_behind_parent = boolean

func update_rotation(angle_to_add):
	var new_rotation = rotation + angle_to_add
	if new_rotation > 2*PI or new_rotation < (2*PI)*-1:
		rotation = 0
	else:
		rotation = new_rotation
