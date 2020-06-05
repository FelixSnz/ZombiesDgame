extends Area2D


const impact_particles = preload("res://Weapons/Impact.tscn")

var direction = Vector2.ZERO
export(float, 1, 500) var speed = 500
export(int) var damage = 1
export(float, 1, 100) var knockback = 20


func create_impact(color:Color = Color("#ffda4d")):
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.process_material.color = color
	impact.emitting = true
	impact.global_position = self.global_position
	queue_free()


func _process(delta):
	position += direction * speed * delta
	pass
