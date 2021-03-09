extends KinematicBody2D

export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(float, 1, 500) var SPRINT

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var mov_direction = Vector2.RIGHT
var canjump = true

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtBox = $HurtBox
onready var sofCollision = $SoftCollision
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var wandercontroller = $WanderController
export(Array, Texture) var styles

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var state = IDLE

func _ready():
	var idx_style = int(round(rand_range(0, styles.size() -1)))
	sprite.texture = styles[idx_style]

func attack():
	velocity = mov_direction * SPRINT
	move()
	


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 *delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animationPlayer.play("Idle")
			seek_player()
			if wandercontroller.get_time_left() == 0:
				state = pick_new_state([IDLE, WANDER])
				wandercontroller.set_wander_timer(rand_range(1,3))
		WANDER:
			seek_player()
			if wandercontroller.get_time_left() == 0:
				state = pick_new_state([IDLE, WANDER])
				wandercontroller.set_wander_timer(rand_range(1,3))
			
			var mov_direction = global_position.direction_to(wandercontroller.target_position)
			velocity = velocity.move_toward(mov_direction * MAX_SPEED, ACCELERATION * delta)
			
			if global_position.distance_to(wandercontroller.target_position) <= 1:
				state = pick_new_state([IDLE, WANDER])
				wandercontroller.set_wander_timer(rand_range(1,3))
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var player_distance = self.global_position.distance_to(player.global_position)
				mov_direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(mov_direction * MAX_SPEED, ACCELERATION * delta)
				animationPlayer.play("Run")
				if 40 <= player_distance and player_distance <= 50 and playerDetectionZone.can_attack:
					playerDetectionZone.start_timer(4)
					SPRINT = player_distance * 1.5

					state = ATTACK
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
		ATTACK:
			attack()
			animationPlayer.play("Jump")

	if sofCollision.is_colliding():
		velocity += sofCollision.get_push_vector() * delta * 400
	move()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func pick_new_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func move():
	velocity = move_and_slide(velocity)

func jump_finished():
	canjump = true
	state = IDLE

func _on_Stats_no_health():
	queue_free()

func _on_HurtBox_area_entered(area):
	if area is Bullet:
		area.create_impact()
	hurtBox.start_invincivility(1)
	$Blink.play("anim")
	stats.health -= area.damage
	knockback = area.direction * area.knockback

func _on_HurtBox_body_entered(_body):
	pass
