extends Sprite


var pointing_dir
var dir = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var angle
var init_degrees

onready var animationPlayer = $AnimationPlayer

enum {
	POINTING,
	ATTACK
}

var state = POINTING


func _process(delta):
	$HitBox.knockback_vector = pointing_dir
	match state:
		POINTING:
			pointing_state()
		ATTACK:
			attack_state()
	



func pointing_state():
	dir = get_local_mouse_position()
	pointing_dir = (get_global_mouse_position() - global_position).normalized()
	var angle = dir.angle() + (PI/4)
	update_rotation(angle)
	#print(rotation_degrees)
	
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		state = ATTACK
		create_attack("anim")
	if Input.is_action_just_released("click"):
		pass

func attack_state():
	animationPlayer.play("anim")

func update_rotation(angul):
	var rot_to_add = rotation + angul
	if rot_to_add > 6.28 or rot_to_add < - 6.28:
		rotation = 0
	else:
		rotation = rot_to_add

func attack_finished():
	state = POINTING
	animationPlayer.remove_animation("anim")

func create_attack(animName):
	print("caaaacaaa")
	var animashion = Animation.new()
	var rot_track_index = animashion.add_track(Animation.TYPE_VALUE)
	var dis_track_index = animashion.add_track(Animation.TYPE_VALUE)
	var mtd_track_index = animashion.add_track(Animation.TYPE_METHOD)
	
	animashion.length = 0.4
	animashion.step = 0
	
	animashion.track_set_path(mtd_track_index, ".")
	animashion.track_set_path(rot_track_index, ".:rotation_degrees")
	animashion.track_set_path(dis_track_index, "HitBox/CollisionShape2D:disabled")
	
	animashion.value_track_set_update_mode(rot_track_index,animashion.UPDATE_CONTINUOUS)
	animashion.track_set_interpolation_type(rot_track_index,animashion.INTERPOLATION_LINEAR)
	
	animashion.value_track_set_update_mode(dis_track_index,animashion.UPDATE_DISCRETE)
	animashion.track_set_interpolation_type(dis_track_index,animashion.INTERPOLATION_LINEAR)

	#dis track
	animashion.track_insert_key(dis_track_index, 0.0, true)
	animashion.track_insert_key(dis_track_index, .1, false)
	animashion.track_insert_key(dis_track_index, .2, true)
	
	init_degrees = rotation_degrees

	#position track
	animashion.track_insert_key(rot_track_index, 0.0, init_degrees)
	animashion.track_insert_key(rot_track_index, 0.1, init_degrees - 45)
	animashion.track_insert_key(rot_track_index, .20, rotation_degrees + 150)
	animashion.track_insert_key(rot_track_index, .40, init_degrees)

	animashion.track_insert_key(mtd_track_index, 0.4,
	 {"method": "attack_finished", "args": []})
	
	animashion = animationPlayer.add_animation(animName, animashion)
