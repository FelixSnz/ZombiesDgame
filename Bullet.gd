extends RigidBody2D

const impact_particles = preload("res://Impact.tscn")

export(int) var damage
export(float, 0.1, 2) var _range
export(float, 1, 100) var knockback

export(float, 0, 1) var speed = 0
var velocity = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var bullet_dir



# Called when the node enters the scene tree for the first time.
func _ready():
	show_behind_parent = true
	$Timer.start(_range)
	var wpn_dir = get_parent().get_parent().pointing_dir
	knockback_vector = wpn_dir
	velocity = wpn_dir * speed
	#self.global_position.y += -2
	add_force(self.global_position, velocity)
	pass


		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Timer_timeout():
	queue_free()

func create_impact():
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.emitting = true
	impact.global_position = self.global_position
	
