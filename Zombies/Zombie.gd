extends KinematicBody2D

export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(float, 1, 500) var SPRINT
export(Array, Texture) var styles

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtBox = $HurtBox
onready var sofCollision = $SoftCollision
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var wanderController = $WanderController
onready var attackRangeZone = $AttackRangeZone

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var state = IDLE

func _ready():
	var style_index = int(round(rand_range(0, styles.size() -1)))
	sprite.texture = styles[style_index]

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationPlayer.play("Idle")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= 1:
				update_wander()
			animationPlayer.play("Run")
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				animationPlayer.play("Run")
				if attackRangeZone.has_player() and attackRangeZone.get_cooldown_left() == 0:
					attackRangeZone.start_cooldown(3)
					state = ATTACK
			else:
				state = IDLE
		ATTACK:
			var player = attackRangeZone.player
			if player != null:
				jump_attack()
				
	if sofCollision.is_colliding():
		velocity += sofCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func jump_attack():
	animationPlayer.play("Jump")
	velocity = move_and_slide(direction * SPRINT)

func jump_finished():
	state = IDLE

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	queue_free()

func _on_HurtBox_area_entered(area):
	if area is Bullet:
		area.create_impact()
	hurtBox.start_invincivility(1)
	$Blink.play("anim")
	print(area.knockback)
	stats.health -= area.damage
	knockback = area.direction * area.knockback

func _on_HurtBox_body_entered(_body):
	pass
