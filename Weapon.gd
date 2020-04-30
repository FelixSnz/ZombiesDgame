extends Sprite


func _process(delta):
	var mouse_pos = get_local_mouse_position()
	rotation += mouse_pos.angle()
			
