extends Weapon





onready var attackAxis = $AttackAxis
onready var hitBox = $AttackAxis/Sprite/HitBox
var just_attacked = false

func _ready():
	sprite = $AttackAxis/Sprite
	tween = $Tween
	animationPlayer = $AnimationPlayer
	
func _process(_delta):
#	print(state)
#	print(tween.is_active())
	









func flip(boolean):
	if not animationPlayer.playback_speed < 0:
		sprite.flip_h = boolean
	else:
		sprite.flip_h = boolean

func behind(boolean:bool):
	get_parent().show_behind_parent = boolean
	show_behind_parent = boolean


func _on_Tween_tween_started(object, key):
	pass
#	print(object.name)
#	print("on: ", key)
