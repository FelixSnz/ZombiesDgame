extends Weapon

const Slash = preload("res://src/Effects & Particles/SlashEffect.tscn")

onready var strikeAxis = $StrikeAxis
onready var hitBox = $StrikeAxis/Sprite/HitBox

var initial_strike_rotation
var final_strke_rotation
var initial_sprite_rotation
var final_sprite_rotation
var vertical_side = 0

func _ready():
	sprite = $StrikeAxis/Sprite
	animationPlayer = $AnimationPlayer
	set_animation_values()
	update_behind_check()

func _pointing_state(_delta):
	hitBox.direction = pointing_direction
	if Global.player.animationPlayer.is_playing():
		if player_anim == "Run" and vertical_side == 1:
			if facing_right:
				behind(true)
			else:
				behind(false)

func attack_state():
		if facing_right:
			if round(strikeAxis.rotation_degrees) >= final_strke_rotation:
				strike("up")
			elif round(strikeAxis.rotation_degrees) == initial_strike_rotation:
				strike("down")
		else:
			if round(strikeAxis.rotation_degrees) == final_strke_rotation:
				strike("up")
			elif round(strikeAxis.rotation_degrees) <= initial_strike_rotation:
				strike("down")

func strike(direction):
	if direction == "up":
		animationPlayer.play_backwards("attack")
	elif direction == "down":
		animationPlayer.play("attack")
	state = POINTING
	yield(animationPlayer, "animation_finished")
	update_behind_check()
	can_attack = true

func slash(boolean):
	var slash = Slash.instance()
	if not animationPlayer.get_playing_speed() < 0:
		if boolean:
			add_slash(slash)
	else:
		if not boolean:
			slash.flip_v = true
			add_slash(slash)

func add_slash(slash):
	var world = get_tree().current_scene
	if not facing_right:
		slash.global_position = global_position
	else:
		slash.global_position = global_position
	slash.rotation_degrees = mouse_angle
	world.add_child(slash)

func flip(boolean:bool): 
	sprite.flip_h = boolean

func update_behind_check(inverted:int = 1, inv_bool:bool = false):
	if facing_right:
		if round(strikeAxis.rotation_degrees) >= final_strke_rotation:
			vertical_side = 1 * inverted
			behind(inv_bool)
		elif round(strikeAxis.rotation_degrees) == initial_strike_rotation:
			vertical_side = -1 * inverted
			behind(not inv_bool)
	else:
		if round(strikeAxis.rotation_degrees) == final_strke_rotation:
			vertical_side = -1 * inverted
			behind(inv_bool)
		elif round(strikeAxis.rotation_degrees) <= initial_strike_rotation:
			vertical_side = 1 * inverted
			behind(not inv_bool)
	if Global.player.animationPlayer.is_playing():
		if vertical_side == 1:
			if facing_right:
				if player_anim == "Run":
					behind(true)
				elif player_anim == "Idle":
					behind(false)
			else:
				if player_anim == "Run":
					behind(false)
				elif player_anim == "Idle":
					behind(true)

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

#Sinal functions connected to the player 

func _facing_side_changued(_side):
	update_behind_check()

func player_anim_changued(anim_name):
	if vertical_side == 1:
		if facing_right:
			if anim_name == "Run":
				behind(true)
			elif anim_name == "Idle":
				behind(false)
		else:
			if anim_name == "Run":
				behind(false)
			elif anim_name == "Idle":
				behind(true)
