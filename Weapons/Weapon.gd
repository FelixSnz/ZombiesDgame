extends Sprite

const bullet = preload("res://Weapons/Firearms/ammo/Bullet.tscn")
const fireShot = preload("res://Effects & Particles/FireShot_Effect.tscn")

var can_shot = true
var glob_mouse_position = Vector2.ZERO

func _process(_delta):
	glob_mouse_position = get_global_mouse_position() + Vector2(0, 2)
	var mouse_direction = (glob_mouse_position - global_position).normalized()
	var mouse_angle = mouse_direction.angle()
	rotation = mouse_angle
	if get_parent().get_parent().scale.x == -1:
		var pointing_dir = Vector2(sin(mouse_angle), cos(mouse_angle))
		rotation = pointing_dir.angle() + deg2rad(90)
	if Input.is_action_just_pressed("click") and can_shot:
		can_shot = false
		shot_bullet()

func shot_bullet():
	create_instance(bullet)
	create_instance(fireShot)
	$AnimationPlayer.play("knockback")
	yield($AnimationPlayer, "animation_finished")
	can_shot = true

func create_instance(Obj):
	var instance = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.rotation = get_mouse_direction().angle()
	instance.global_position = $Nuzzle.global_position

func get_mouse_direction():
	return (glob_mouse_position - global_position).normalized()
