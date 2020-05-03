extends Sprite


var pointing_dir
var dir = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var angle

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
	var angle = dir.angle() + (PI/2)
	update_rotation(angle)
	
	if Input.is_action_just_pressed("click"):
		state = ATTACK
	if Input.is_action_just_released("click"):
		pass

func attack_state():
	$AnimationPlayer.play("Hit")

func update_rotation(angul):
	rotation += angul

func attack_finished():
	state = POINTING
