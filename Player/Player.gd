extends KinematicBody2D

var velocity = Vector2.ZERO
export(float, 1, 1000) var max_speed
export(float, 1, 1000) var acceleration
export(float, 1, 1000) var friction

onready var sprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var stats = PlayerStats

enum {
	MOVE,
	INV
}
var state = MOVE
func _ready():
	stats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
	if softCollision.is_colliding():
		print("cacaaaaaa")
		velocity += softCollision.get_push_vector() * delta * 600
		move()

func move_state(delta):
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vec = input_vec.normalized()
	if input_vec != Vector2.ZERO:
		if input_vec.x < 0:
			sprite.flip_h = true
		elif input_vec.x > 0:
			sprite.flip_h = false
		velocity = velocity.move_toward(input_vec * max_speed, acceleration * delta)
		sprite.play("Run")

	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		sprite.play("Idle")
	move()

func move():
	velocity = move_and_slide(velocity)



func _on_HurtBox_area_entered(area):
	hurtBox.start_invincivility(.5)
	animationPlayer.play("inv")
	

