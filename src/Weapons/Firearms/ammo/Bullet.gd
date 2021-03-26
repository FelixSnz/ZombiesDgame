extends Sprite

signal destroyed

const ImpactParticles = preload("res://src/Effects & Particles/ImpactParticles.tscn")
const ImpactEffect = preload("res://src/Effects & Particles/ImpactAnimation.tscn")

export(float, 1, 500) var speed = 500

var direction

func _ready():
	direction = Vector2(cos(rotation), sin(rotation))

func create_impact(color:Color = Color("#ffda4d")):
	var impactParticles = create_instance(ImpactParticles)
	impactParticles.process_material.color = color
	impactParticles.emitting = true

	var impactEffect = create_instance(ImpactEffect)
	impactEffect.modulate = color + Color(.4,.4,.4,0)
	emit_signal("destroyed")
	queue_free()

func create_instance(Obj):
	var instance = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = global_position
	return instance

func _process(delta):
	position += direction * speed * delta
