extends KinematicBody2D

const impact_particles = preload("res://Weapons/Impact.tscn")


var direction = Vector2.ZERO
export(float, 1, 500) var speed = 500
export(int) var damage = 1
export(float, 1, 100) var knockback = 20
var coll




func _physics_process(delta):
	coll = move_and_collide(direction * speed * delta)
	
	if coll:
		create_impact()
		queue_free()

func create_impact():
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.emitting = true
	impact.global_position = self.global_position
