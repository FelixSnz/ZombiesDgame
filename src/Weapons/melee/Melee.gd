extends Weapon

const Slash = preload("res://src/Effects & Particles/SlashEffect.tscn")

onready var strikeAxis = $StrikeAxis
onready var hitBox = $StrikeAxis/Sprite/HitBox
var extra_rotation = 0
var just_attacked

func _ready():
	sprite = $StrikeAxis/Sprite
	if $TweenCrow != null:
		tween = $TweenCrow
	animationPlayer = $AnimationPlayer

func _pointing_state(delta):
	hitBox.direction = pointing_direction
	
#	if not tween.is_active():
#		if facing_right:
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
#		else:
#			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)

func attack_state():
	if facing_right:
		if round(strikeAxis.rotation_degrees) >= 180 \
		and round(strikeAxis.rotation_degrees) < 360:
			tween.stop_all()
			animationPlayer.play_backwards("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
		elif round(strikeAxis.rotation_degrees) == 0:
			tween.stop_all()
			animationPlayer.play("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
	else:
		if round(strikeAxis.rotation_degrees) == 180:
			tween.stop_all()
			animationPlayer.play_backwards("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true

		elif round(strikeAxis.rotation_degrees) == 0 \
		or round(strikeAxis.rotation_degrees) < 0 :
			tween.stop_all()
			animationPlayer.play("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true

func slash(boolean):
	var slash = Slash.instance()
	slash.scale = get_parent().get_parent().scale
	if not animationPlayer.get_playing_speed() < 0:
		if boolean:
			add_slash(slash, 180)
	else:
		if not boolean:
			slash.flip_v = true
			add_slash(slash, 180, 45)

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
	if not animationPlayer.get_playing_speed() < 0:
		sprite.flip_h = boolean
	else:
		sprite.flip_h = boolean

func tween_behind(boolean:bool):
	get_parent().show_behind_parent = boolean

func behind(boolean:bool):
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

func _facing_side_changued(side):
	pass
