extends Sprite

func _process(_delta):
	var shader_param = Global.player.sprite.material.get_shader_param("active")
	material.set_shader_param("active", shader_param)
