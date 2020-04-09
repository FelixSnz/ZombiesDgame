extends KinematicBody2D

var velocity = Vector2.ZERO
export(float, 1, 1000) var max_speed
export(float, 1, 1000) var acceleration
export(float, 1, 1000) var friction

onready var animatedSprite = $AnimatedSprite

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vec = input_vec.normalized()
	if input_vec != Vector2.ZERO:
		if input_vec.x < 0:
			animatedSprite.flip_h = true
		elif input_vec.x > 0:
			animatedSprite.flip_h = false
		velocity = velocity.move_toward(input_vec * max_speed, acceleration * delta)
		animatedSprite.play("Run")

	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animatedSprite.play("Idle")
	velocity = move_and_slide(velocity)
	
