extends KinematicBody2D

var velocity = Vector2.ZERO
export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var stats = PlayerStats

enum {
	MOVE,
	INV
}
var state = MOVE
var direction

func _ready():
	stats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	direction = (get_global_mouse_position() - global_position).normalized()
	
	match state:
		MOVE:
			move_state(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 600
		move()

func move_state(delta):
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vec = input_vec.normalized()
	if input_vec != Vector2.ZERO:
		update_facing()
		velocity = velocity.move_toward(input_vec * MAX_SPEED, ACCELERATION * delta)
		animationPlayer.play("Run")

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		update_facing()
		animationPlayer.play("Idle")
	move()

func move():
	velocity = move_and_slide(velocity)

func update_facing():
	
	if direction.x < 0:
		sprite.scale.x = -1
	elif direction.x > 0:
		sprite.scale.x = 1

func _process(_delta):
	$Label.text = str(position /28)

func _on_HurtBox_area_entered(_area):
	hurtBox.start_invincivility(1)
	$AnimationPlayer2.play("inv")
