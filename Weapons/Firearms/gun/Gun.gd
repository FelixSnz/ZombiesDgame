extends FireArm

onready var nuzzle = $Sprite/Nuzzle

func _ready():
	init_nuzzle_position = nuzzle.position
	sprite = $Sprite
	tween =  $Tween

func attack_state():
	if not facing_right:
		nuzzle.position.y = init_nuzzle_position.y * -1
	else:
		nuzzle.position.y = init_nuzzle_position.y
	create_instance(bullet)
	create_instance(fireShot)
	knockback_push()
	state = POINTING
	yield(tween, "tween_all_completed")
	can_attack = true

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
	instance.rotation = get_mouse_direction().angle()
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = nuzzle.global_position
