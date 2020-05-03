extends TextureRect

const Bullet = preload("res://Weapons/Bullet.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _process(delta):
	if Input.is_action_just_pressed("click"):
		var world = self
		var bullet = Bullet.instance()
		bullet.angular_velocity = 0
		bullet.direction = (get_global_mouse_position() - rect_global_position).normalized()
		world.add_child(bullet)
		
		
