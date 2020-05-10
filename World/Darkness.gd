extends Sprite


# Declare member variables here. Examples:
# var a = 2
var world 


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent()
	
	

func _process(delta):
	self.global_position = world.get_node("YSort").get_node("Player").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
