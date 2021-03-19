extends Weapon

const Slash = preload("res://src/Effects & Particles/SlashEffect.tscn")

onready var strikeAxis = $StrikeAxis
onready var hitBox = $StrikeAxis/Sprite/HitBox
var extra_rotation = 0
var can_toggle = true
var pointing_up

var initial_strike_rotation
var final_strke_rotation
var initial_sprite_rotation
var final_sprite_rotation

func _ready():
	
	if pointing_direction.y < 0:
		pointing_up = true
	else:
		pointing_up = false
	
	sprite = $StrikeAxis/Sprite
	if $TweenCrow != null:
		tween = $TweenCrow
	animationPlayer = $AnimationPlayer
	set_animation_values()
#	print(initial_strike_rotation)
#	print(final_strke_rotation)
#	print(initial_sprite_rotation)
#	print(final_sprite_rotation)
	get_parent().show_behind_parent = true

func _pointing_state(_delta):
#	print(strikeAxis.rotation_degrees)
#	if pointing_direction.y < 0 and can_toggle:
#		pointing_up = true
#		can_toggle = not can_toggle
#	elif pointing_direction.y > 0 and not can_toggle:
#		pointing_up = true
#		can_toggle = not can_toggle
	hitBox.direction = pointing_direction

func strike(direction):
	tween.stop_all()
	if direction == "up":
		animationPlayer.play_backwards("attack")
	elif direction == "down":
		animationPlayer.play("attack")
	state = POINTING
	yield(animationPlayer, "animation_finished")
	can_attack = true

func attack_state():
	if facing_right:
		if round(strikeAxis.rotation_degrees) >= final_strke_rotation:
			strike("up")
				
		elif round(strikeAxis.rotation_degrees) == initial_strike_rotation:
			strike("down")
#			if not round(strikeAxis.rotation_degrees) == 0 \
#			and facing_right and pointing_direction.y > 0:
#				reset_rotation(360, -45, false)
	else:
		if round(strikeAxis.rotation_degrees) == final_strke_rotation:
			strike("up")
#			if not round(strikeAxis.rotation_degrees) == 180 \
#			and not facing_right and pointing_direction.y > 0:
#				reset_rotation(-180, 45, true)
		elif round(strikeAxis.rotation_degrees) <= initial_strike_rotation:
			strike("down")


func _facing_side_changued(side):
	pass
	get_parent().show_behind_parent = not get_parent().show_behind_parent
#	if side == -1:
##		if get_parent().show_behind_parent:
#		get_parent().show_behind_parent = not get_parent().show_behind_parent
##		else:
##		reset_rotation(-180, 45, true)
##		tween_behind(false)
#	elif side == 1:
##		reset_rotation(360, -45, false)
#		tween_behind(true)

func slash(boolean):
	var slash = Slash.instance()
	slash.scale = get_parent().get_parent().scale
	if not animationPlayer.get_playing_speed() < 0:
		if boolean:
			add_slash(slash, final_strke_rotation)
	else:
		if not boolean:
			slash.flip_v = true
			add_slash(slash, final_strke_rotation, final_sprite_rotation)

func add_slash(slash, initial_degrees, extra:int = 0):
	var world = get_tree().current_scene
	if slash.scale.x == -1:
		slash.rotation_degrees = get_inverse_degrees(rotation_degrees) + initial_degrees
		slash.global_position = global_position
		world.add_child(slash)
	else:
		slash.rotation_degrees = rotation_degrees + extra
		slash.global_position = global_position
		world.add_child(slash)

func flip(boolean:bool): 
	sprite.flip_h = boolean

func tween_behind(boolean:bool):
	get_parent().show_behind_parent = boolean

func behind(boolean:bool):
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

func set_animation_values():
	var attack_anim = animationPlayer.get_animation("attack")
	
	var track_idx = attack_anim.find_track("StrikeAxis:rotation_degrees")
	var track_key_idx = attack_anim.track_find_key(track_idx, 0)
	initial_strike_rotation = attack_anim.track_get_key_value(track_idx, track_key_idx)
	
	track_idx = attack_anim.find_track("StrikeAxis:rotation_degrees")
	track_key_idx = attack_anim.track_find_key(track_idx, 0.5)
	final_strke_rotation = attack_anim.track_get_key_value(track_idx, track_key_idx)
	
	track_idx = attack_anim.find_track("StrikeAxis/Sprite:rotation_degrees")
	track_key_idx = attack_anim.track_find_key(track_idx, 0)
	initial_sprite_rotation = attack_anim.track_get_key_value(track_idx, track_key_idx)
	
	track_idx = attack_anim.find_track("StrikeAxis/Sprite:rotation_degrees")
	track_key_idx = attack_anim.track_find_key(track_idx, 0.5)
	final_sprite_rotation = attack_anim.track_get_key_value(track_idx, track_key_idx)

func reset_rotation(final1, final2, side:bool, duration:float = .8):
	pass
	tween.interpolate_property(strikeAxis, "rotation_degrees", \
	strikeAxis.rotation_degrees, final1, duration, Tween.TRANS_EXPO)

	tween.interpolate_property(sprite, "rotation_degrees", \
	sprite.rotation_degrees, final2, duration, Tween.TRANS_EXPO)

	tween.start()
	yield(tween, "tween_completed")
#	if round(strikeAxis.rotation_degrees) == -final_strke_rotation:
#		strikeAxis.rotation_degrees = final_strke_rotation
#	if round(strikeAxis.rotation_degrees) == 360:
#		strikeAxis.rotation_degrees = 0
	tween.stop_all()
	tween_behind(true)
	flip(side)
