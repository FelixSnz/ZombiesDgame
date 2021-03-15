extends Weapon

const Slash = preload("res://Effects & Particles/SlashEffect.tscn")



onready var attackAxis = $AttackAxis
onready var hitBox = $AttackAxis/Sprite/HitBox
var just_attacked = false

func _ready():
	sprite = $AttackAxis/Sprite
	tween = $Tween
	animationPlayer = $AnimationPlayer
	
func _process(_delta):
#	print(state)
#	print(tween.is_active())
	hitBox.direction = pointing_direction


func get_inverse_degrees(degrees):
	var radians = deg2rad(degrees)
	var inverse_vector = Vector2(sin(radians), cos(radians))
	return rad2deg(inverse_vector.angle()) + 90

func attack_state():
	tween.stop_all()
	if just_attacked:
		animationPlayer.play_backwards("attack")
		state = POINTING
		yield(animationPlayer, "animation_finished")
		just_attacked = false
		can_attack = true
	else:
		animationPlayer.play("attack")
		state = POINTING
		yield(animationPlayer, "animation_finished")
		just_attacked = true
		can_attack = true
#		reset_position()



func reset_position():
	print("reseting crowbar pos")
	tween.interpolate_property(attackAxis, "rotation_degrees", 180, 360, 0.8, Tween.TRANS_EXPO)
	tween.interpolate_property(sprite, "rotation_degrees", 45, -45, 0.8, Tween.TRANS_EXPO)
	tween.start()
#	print("tween started")
	yield(tween, "tween_completed")
#	print("tween ended")
	tween.stop_all()
	just_attacked = false
	behind(true)
	flip(false)
	pass

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

func flip(boolean):
	if not animationPlayer.playback_speed < 0:
		sprite.flip_h = boolean
	else:
		sprite.flip_h = boolean

func behind(boolean:bool):
	get_parent().show_behind_parent = boolean
	show_behind_parent = boolean


func _on_Tween_tween_started(object, key):
	pass
#	print(object.name)
#	print("on: ", key)
