extends TextureProgress

#signal maximum_changed(maximum)

var maximum = 100
var current_health = 0

func initialize(max_val):
	max_value = max_val
	maximum = max_val
#	emit_signal("maximum_changed", maximum)

func _on_Interface_health_updated(new_health):
	print("current: ", current_health)
	print("new: ", new_health)
	animate_value(current_health, new_health)
	update_count_text(new_health)
	current_health = new_health

func animate_value(start, end):
	$Tween.interpolate_property(self, "value", start, end, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_count_text", start, end, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if end < start:
		pass
#		$AnimationPlayer.play("shake")

func update_count_text(value):
	$Count/Number.text = str(clamp(round(value), 0, maximum)) + '/' + str(maximum) + " Hp"
