extends KinematicBody2D

#var DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(float, 1, 500) var SPRINT

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var mov_direction = Vector2.RIGHT

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
			#sprite.self_modulate = Color(10,10,10,10)
			animationPlayer.play("Idle")
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				mov_direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(mov_direction * MAX_SPEED, ACCELERATION * delta)
				animationPlayer.play("Run")
				if Input.is_action_just_pressed("ui_accept"):
					
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

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
#	hurtBox.create_hiteffect()

func move():
	velocity = move_and_slide(velocity)

func jump_finished():
	state = IDLE


func _on_Stats_no_health():
	queue_free()
#	var deathEffect = DeathEffect.instance()
#	get_parent().add_child(deathEffect)
#	deathEffect.global_position = global_position
	
