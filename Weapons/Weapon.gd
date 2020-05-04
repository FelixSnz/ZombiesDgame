extends Sprite

const Bullet = preload("res://bullet2.tscn")

var pointing_dir
var can_shot = true
var dir = Vector2.ZERO
var angle


func _process(delta):
	dir = get_local_mouse_position()
	
	pointing_dir = (get_global_mouse_position() - global_position).normalized()
	
	var angle = dir.angle()
	
	rotation += angle
	
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
	
