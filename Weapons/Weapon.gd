extends Sprite

const bullet_ = preload("res://Weapons/Firearms/ammo/Bullet.tscn")
const fire_shot = preload("res://Effects & Particles/FireShot_Effect.tscn")

var pointing_dir
var can_shot = true
var dir = Vector2.ZERO


func _process(_delta):
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
	var bullet = bullet_.instance()
	var fire = fire_shot.instance()
	bullet.direction = pointing_dir
	bullet.rotation = pointing_dir.angle()
	var world = get_tree().current_scene
	world.add_child(bullet)
	self.add_child(fire)
	fire.rotation = get_local_mouse_position().angle()
	bullet.global_position = $Nuzzle.global_position
	fire.global_position = $Nuzzle.global_position 
	$AnimationPlayer.play("knockback")
	yield($AnimationPlayer, "animation_finished")
	can_shot = true
	
