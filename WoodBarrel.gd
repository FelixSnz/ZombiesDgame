extends StaticBody2D

const DestroyedEffect = preload("res://DestroyedBarrelEffect.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_body_entered(body):
	$Sprite.offset = Vector2.ZERO
	position.y += -4
	$CollisionShape2D.queue_free()
	$Sprite.frame = 1
	$HitBox.queue_free()
	create_destroyed_effect()


func create_destroyed_effect():
	var destroyedEffect = DestroyedEffect.instance()
	var world = get_tree().current_scene
	destroyedEffect.global_position = global_position
	world.add_child(destroyedEffect)


func _on_HurtBox_area_entered(area):
	$Sprite.offset = Vector2.ZERO
	position.y += -4
	$CollisionShape2D.queue_free()
	$Sprite.frame = 1
	$HurtBox.queue_free()
	create_destroyed_effect()
