extends FireArm

signal camera_shake_requested
onready var nuzzle = $Sprite/Nuzzle
onready var tween = $TweenGun

func _ready():
	get_parent().show_behind_parent = false
	init_nuzzle_position = nuzzle.position
	

func attack_state():
	if not facing_right:
		nuzzle.position.y = init_nuzzle_position.y * -1
	else:
		nuzzle.position.y = init_nuzzle_position.y
	var bullt = create_instance(bullet)
	bullt.connect("made_damage", self, "_on_Bullet_made_damage")
	create_instance(fireShot)
	knockback_push()
	state = POINTING
	yield(tween, "tween_all_completed")
	can_attack = true

func _on_Bullet_made_damage():
	emit_signal("camera_shake_requested")

func knockback_push():
	tween.interpolate_property(sprite, "position", sprite.position, \
	sprite.position + Vector2(-2, 0), .15, Tween.TRANS_CUBIC)
	tween.start()
	yield(tween,"tween_completed")
	tween.interpolate_property(sprite, "position", sprite.position, \
	sprite.position + Vector2(2, 0), .15, Tween.TRANS_CUBIC)
	tween.start()

func create_instance(Obj):
	var instance = Obj.instance()
	instance.rotation = rotation
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = nuzzle.global_position
	return instance

func _facing_side_changued(_side):
	pass
