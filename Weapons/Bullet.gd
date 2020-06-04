extends RigidBody2D

const impact_particles = preload("res://Weapons/Impact.tscn")

export(int) var damage
export(float, 0.1, 3) var _range
export(float, 1, 100) var knockback

export(float, 0, 10) var speed = 0
var velocity = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var direction 



# Called when the node enters the scene tree for the first time.
func _ready():
	rotation += get_local_mouse_position().angle()
	show_behind_parent = true
	$Timer.start(_range)
	knockback_vector = direction
	velocity = direction * speed
	#self.global_position.y += -2
	add_force(self.global_position, velocity)

func _process(delta):
	self.angular_velocity = 0




func create_impact():
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.emitting = true
	impact.global_position = self.global_position
	


func _on_Bullet_body_entered(body):
	print("pegue")
