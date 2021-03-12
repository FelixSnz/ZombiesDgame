extends Area2D
class_name Bullet

const ImpactParticles = preload("res://Effects & Particles/ImpactParticles.tscn")
const ImpactEffect = preload("res://Effects & Particles/ImpactAnimation.tscn")

export(float, 1, 500) var speed = 500
export(float, 1, 100) var knockback = 20
export(int) var damage = 1

var direction

func create_impact(color:Color = Color("#ffda4d")):
	var impactParticles = create_instance(ImpactParticles)
	impactParticles.process_material.color = color
	impactParticles.emitting = true

	var impactEffect = create_instance(ImpactEffect)
	impactEffect.modulate = color + Color(.4,.4,.4,0)
	queue_free()

func create_instance(Obj):
	var instance = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = global_position
	return instance

func set_pointing_direction():
	direction = Vector2(cos(rotation), sin(rotation))
	return direction

func _process(delta):
	position += set_pointing_direction() * speed * delta
	pass
