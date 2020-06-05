extends Sprite

const Bullet = preload("res://Weapons/Bullett.tscn")

var pointing_dir
var can_shot = true
var dir = Vector2.ZERO
var angle


func _process(delta):
	dir = get_local_mouse_position()
	dir.y += 2
	var angle = dir.angle()
	rotation += angle
	var global_dir = get_global_mouse_position()
	global_dir.y += 2
	var pointing_dirr = (global_dir - global_position).normalized()
	#print(pointing_dirr)
	
	pointing_dir = Vector2(cos(rotation), sin(rotation))
	
	
	if pointing_dirr.x < 0:
		pointing_dir.x = pointing_dir.x * -1

	if Input.is_action_just_pressed("click") and can_shot:
		can_shot = false
		shot_bullet()

func shot_bullet():
	
	var bullet = Bullet.instance()
	bullet.direction = pointing_dir
	var world = get_tree().current_scene
	world.add_child(bullet)
	bullet.global_position = $Nuzzle.global_position
	$AnimationPlayer.play("knockback")
	yield($AnimationPlayer, "animation_finished")
	can_shot = true
	
