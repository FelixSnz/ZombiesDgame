extends KinematicBody2D


var direction = Vector2.ZERO
export(float, 1, 500) var speed = 500
export(int) var damage = 1
export(float, 1, 100) var knockback = 20
var coll


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_and_collide(direction * speed * delta)
