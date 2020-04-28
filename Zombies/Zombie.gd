extends KinematicBody2D

#var DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtBox = $HurtBox
onready var sofCollision = $SoftCollision
onready var animatedSprite = $AnimatedSprite

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 *delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animatedSprite.play("Idle")
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				animatedSprite.play("Run")
			else:
				state = IDLE
			$AnimatedSprite.flip_h = velocity.x < 0
			
	if sofCollision.is_colliding():
		velocity += sofCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
#	hurtBox.create_hiteffect()


func _on_Stats_no_health():
	queue_free()
#	var deathEffect = DeathEffect.instance()
#	get_parent().add_child(deathEffect)
#	deathEffect.global_position = global_position
	
