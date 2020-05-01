extends KinematicBody2D

#var DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

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
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			
			
			if player != null:
				var player_distance = self.global_position.distance_to(player.global_position)
				mov_direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(mov_direction * MAX_SPEED, ACCELERATION * delta)
				animationPlayer.play("Run")
				if 40 <= player_distance and player_distance <= 50 and playerDetectionZone.can_attack:
					playerDetectionZone.start_timer(4)
					SPRINT = player_distance * 1.6
					print(SPRINT)
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

#func _on_HurtBox_area_entered(area):
#	print("kk")
#	stats.health -= area.damage
#	knockback = area.knockback_vector * 120
#	hurtBox.start_invincivility(.5)
#	hurtBox.create_hiteffect()

func move():
	velocity = move_and_slide(velocity)

func jump_finished():
	canjump = true
	state = IDLE


func _on_Stats_no_health():
	queue_free()
#	var deathEffect = DeathEffect.instance()
#	get_parent().add_child(deathEffect)
#	deathEffect.global_position = global_position
	


func _on_HurtBox_body_entered(body):
	if body.collision_layer == 64:
		body.queue_free()
	print("kks")
	stats.health -= body.damage
	knockback = body.knockback_vector * 120
	pass # Replace with function body.
