extends FireArm

signal camera_shake_requested
onready var muzzle = $Sprite/Muzzle
onready var animationPlayer = $AnimationPlayer

export(int) var energy_cost = 10

func _ready():
	get_parent().show_behind_parent = false
	init_muzzle_position = muzzle.position
	

func attack_state():
	if not facing_right:
		muzzle.position.y = init_muzzle_position.y * -1
	else:
		muzzle.position.y = init_muzzle_position.y
	var bullt = create_instance(bullet)
	bullt.connect("impacted", self, "_on_Bullet_impacted")
	create_instance(fireShot)
	Global.player.stats.energy -= energy_cost
	animationPlayer.play("knockback_push")
	state = POINTING
	yield(animationPlayer, "animation_finished")
	can_attack = true

func _on_Bullet_impacted():
	emit_signal("camera_shake_requested")

func create_instance(Obj):
	var instance = Obj.instance()
	instance.rotation = rotation
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = muzzle.global_position
	return instance

func _facing_side_changued(_side):
	pass
