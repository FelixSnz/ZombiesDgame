extends Sprite

var pointing_dir = Vector2.ZERO
var dir = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var init_degrees

export(float) var test_var

onready var animationPlayer = $AnimationPlayer

enum {
	POINTING,
	ATTACK
}

var state = POINTING

func _process(_delta):
	$HitBox.direction = pointing_dir
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
	
	if Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept"):
		create_attack("anim")
		state = ATTACK
	if Input.is_action_just_released("click"):
		pass

func attack_state():
	animationPlayer.play("anim")

func update_rotation(angle_to_add):
	var new_rotation = rotation + angle_to_add
	if new_rotation > 2*PI or new_rotation < (2*PI)*-1:
		rotation = 0
	else:
		rotation = new_rotation

func attack_finished():
	state = POINTING
	animationPlayer.remove_animation("anim")

func create_attack(animName):
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
	animashion.track_insert_key(rot_track_index, 0.1, init_degrees - 100)
	animashion.track_insert_key(rot_track_index, .20, rotation_degrees + 180)
	animashion.track_insert_key(rot_track_index, .40, init_degrees)

	animashion.track_insert_key(mtd_track_index, 0.4,
	 {"method": "attack_finished", "args": []})
	
	animashion = animationPlayer.add_animation(animName, animashion)
