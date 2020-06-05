extends StaticBody2D

const DestroyedEffect = preload("res://DestroyedBarrelEffect.tscn")
const impact_particles = preload("res://Weapons/Impact.tscn")

export(Array, Color) var colors

func _on_HitBox_body_entered(body):
	queue_free()
	create_destroyed_effect()


func create_destroyed_effect():
	var destroyedEffect = DestroyedEffect.instance()
	var world = get_tree().current_scene.get_node("YSort")
	destroyedEffect.global_position = global_position
	world.add_child(destroyedEffect)

func create_impact(amount:int = 5, color:Color = Color.white, scale:float =3):
	var impact = impact_particles.instance()
	var world = get_tree().current_scene
	world.add_child(impact)
	impact.process_material.color = color
	impact.amount = amount
	impact.process_material.scale = scale
	impact.emitting = true
	impact.global_position = self.global_position


func _on_HurtBox_area_entered(area):
	queue_free()
	create_destroyed_effect()
	create_impact(3, Color(0.384314, 0.231373, 0.160784, 1), 3)
	create_impact(3, Color("#533127"), 3)
	create_impact(3, Color("#3b2533"), 3)

