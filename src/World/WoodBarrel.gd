extends StaticBody2D

const DestroyedEffect = preload("res://src/Effects & Particles/DestroyedBarrelEffect.tscn")
const matchwood_particles = preload("res://src/Effects & Particles/WoodParticles.tscn")

export(Array, Color) var colors


func create_destroyed_effect():
	var destroyedEffect = DestroyedEffect.instance()
	var world = get_tree().current_scene.get_node("LevelGenerator/YSort")
	destroyedEffect.global_position = global_position
	world.add_child(destroyedEffect)

func create_matchwood(amount:int = 5, color:Color = Color.white, scale:float =3):
	var matchwood = matchwood_particles.instance()
	var world = get_tree().current_scene
	world.add_child(matchwood)
	matchwood.process_material.color = color
	matchwood.amount = amount
	matchwood.process_material.scale = scale
	matchwood.emitting = true
	matchwood.global_position = self.global_position + Vector2(0, -4)
	
func _on_HurtBox_area_entered(area):
	create_destroyed_effect()
	create_matchwood(3, Color(0.384314, 0.231373, 0.160784, 1), 5)
	create_matchwood(3, Color("#533127"), 5)
	create_matchwood(3, Color("#3b2533"), 5)
	queue_free()
