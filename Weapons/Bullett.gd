extends Area2D


const impact_particles = preload("res://Weapons/Impact.tscn")

var direction = Vector2.ZERO
export(float, 1, 500) var speed = 500
export(int) var damage = 1
export(float, 1, 100) var knockback = 20


func create_impact(color:Color = Color.white):
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.process_material.color = color
	impact.emitting = true
	impact.global_position = self.global_position


func _process(delta):
	position += direction * speed * delta
	pass


func _on_Bullett_area_entered(area):
	create_impact(Color(1, 0.741176, 0.298039, 1))
	queue_free()
	pass # Replace with function body.
