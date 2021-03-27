extends FireArm

onready var muzzle = $Sprite/Muzzle
onready var animationPlayer = $AnimationPlayer
onready var cameraShaker = $CameraShaker

export(int) var energy_cost = 10

func _ready():
	get_parent().show_behind_parent = false
	init_muzzle_position = muzzle.position
	

func attack_state():
	if Global.player.stats.energy > energy_cost:
		if not facing_right:
			muzzle.position.y = init_muzzle_position.y * -1
		else:
			muzzle.position.y = init_muzzle_position.y
		var bullt = create_instance(bullet)
		bullt.connect("destroyed", self, "_on_Bullet_destroyed")
		create_instance(fireShot)
		Global.player.stats.energy -= energy_cost
		animationPlayer.play("knockback_push")
		state = POINTING
		yield(animationPlayer, "animation_finished")
	can_attack = true

func create_instance(Obj):
	var instance = Obj.instance()
	instance.rotation = rotation
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = muzzle.global_position
	return instance

func _on_Bullet_destroyed():
	cameraShaker.send_shake_request(cameraShaker.shake_types.SHORT_NARROW)

func _facing_side_changued(_side):
	pass
