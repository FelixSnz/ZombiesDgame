extends Weapon

const Slash = preload("res://Effects & Particles/SlashEffect.tscn")

onready var strikeAxis = $StrikeAxis
onready var hitBox = $StrikeAxis/Sprite/HitBox
var extra_rotation = 0
var just_attacked


func _ready():
	sprite = $StrikeAxis/Sprite
	if $TweenCrow != null:
		tween = $TweenCrow
	animationPlayer = $AnimationPlayer


func _pointing_state():
	hitBox.direction = pointing_direction
	rotation_degrees = mouse_angle - extra_rotation
#	print(pointing_direction)
	
	if not tween.is_active():
		if facing_right:
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(-2, -2)
		else:
			global_position = get_parent().get_parent().rightHand.global_position + Vector2(2, -2)

func attack_state():
		
	tween.stop_all()
	if facing_right:
		if just_attacked:
			animationPlayer.play_backwards("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
#			print("shouldnt return")
				
		else:
			animationPlayer.play("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
			reset_rotation(360, -45, false)
	else:
		if not just_attacked:
			animationPlayer.play_backwards("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
			reset_rotation(-180, 45, true)
				
		else:
			animationPlayer.play("attack")
			state = POINTING
			yield(animationPlayer, "animation_finished")
			just_attacked = not just_attacked
			can_attack = true
#			print("shouldnt return")

func reset_rotation(final1, final2, side:bool, \
vec:Vector2 = position, duration:float = 0.8):
	print("reseting and ", randf())
	
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(strikeAxis, "rotation_degrees", \
	strikeAxis.rotation_degrees, final1, duration, Tween.TRANS_EXPO)
	
	tween.interpolate_property(sprite, "rotation_degrees", \
	sprite.rotation_degrees, final2, duration, Tween.TRANS_EXPO)
	
	tween.interpolate_property(self, "position", \
	position, vec, duration, Tween.TRANS_EXPO)
	
	tween.start()
	yield(tween, "tween_completed")
	tween.stop_all()
	just_attacked = false
	tween_behind(true)
	flip(side)

func facing_side_changued(side):
	print("la cara cambio")
	if side == -1:
		just_attacked = not just_attacked
		if pointing_direction.y < 0:
			reset_rotation(180, 45, true, Vector2(-6, -2))
		else:
			reset_rotation(-180, 45, true, Vector2(-6, -2))
	elif side == 1:
		if pointing_direction.y > 0:
			reset_rotation(0, -45, false, Vector2(0, -2))
		else:
			reset_rotation(360, -45, false, Vector2(0, -2))

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
	print("behindeando ")
	print("parentname: ", get_parent().name)
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

