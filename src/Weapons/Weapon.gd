extends Node2D
class_name Weapon



export(int) var semi_major_axis
export(int) var semi_minor_axis

export(Dictionary) var shake_values = {
	"amplitude":0.1,
	"duration":0.1,
	"damp_easing":0.1,
	"override":false
}

var pointing_direction = Vector2.ZERO
var facing_right = true
var can_attack = true

enum {
	POINTING,
	ATTACK,
}

var state = POINTING

func _ready():
	if Global.player.sprite.scale.x == 1:
		facing_right = true
	else:
		facing_right = false

func _process(delta):
	
	pointing_direction = (get_global_mouse_position() - Global.player.center).normalized()
	
	match state:
		POINTING:
			pointing_state(delta)
		ATTACK:
			attack_state()

func _input(event):
	if event.is_action_pressed("click") and can_attack:
		can_attack = false
		state = ATTACK

func pointing_state(delta):
	update_position(delta, get_extra_movement())
	_pointing_state(delta)

func get_extra_movement():
	var player_hand = Global.player.rightHand2
	var extra_movement
	if Global.player.animationPlayer.current_animation == "Idle":
		extra_movement = player_hand.position - Vector2(5, -2)
	elif Global.player.animationPlayer.current_animation == "Run":
		if is_in_group("Melee"):
			if facing_right:
				extra_movement = player_hand.position - Vector2(2.5, -3)
			else:
				extra_movement = (player_hand.position - Vector2(2.5, -3.5)) * -1
		else:
			extra_movement = Vector2.ZERO
	else:
		extra_movement = Vector2.ZERO
	return extra_movement

func update_position(delta, extra_movement:Vector2 = Vector2.ZERO):
	if MathTools.is_in_ellipse(Global.player.center, semi_major_axis, semi_minor_axis, get_global_mouse_position()):
		global_position = global_position.linear_interpolate(get_global_mouse_position(), delta * .5) + extra_movement
	else:
		var ellip_radius = MathTools.get_ellipse_radius(semi_major_axis, semi_minor_axis, pointing_direction.angle())
		var diff = Global.player.center + pointing_direction * ellip_radius
		global_position = global_position.linear_interpolate(diff, delta * 5) + extra_movement

func facing_side_changued(side):
	if side == 1:
		facing_right = true
	else:
		facing_right = false
	_facing_side_changued(side)

func behind(boolean:bool):
	if facing_right:
		get_parent().show_behind_parent = boolean
	else:
		get_parent().show_behind_parent = not boolean

func _pointing_state(_delta):
	pass

func _facing_side_changued(_side):
	pass

func player_anim_changued(_anim_name):
	pass

func attack_state():
	pass
