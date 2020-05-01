extends RigidBody2D


export(int) var damage

export(float, 1, 500) var speed = 0
var velocity = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var bullet_dir



# Called when the node enters the scene tree for the first time.
func _ready():
	var wpn_dir = get_parent().get_parent().pointing_dir
	knockback_vector = wpn_dir
	velocity = wpn_dir * speed
	#self.global_position.y += -2
	add_force(self.global_position, velocity)
	pass


		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bullet_body_entered(body):
	queue_free()
