extends TextureProgress

var maximum = 100
var current_health = 0
var values_scalar = 10 

func initialize(max_val):
	hide()
	max_value = max_val * values_scalar
	maximum = max_val * values_scalar

func animate_value(start, end):
	show()
	$Timer.start(3)
	$Tween.interpolate_property(self, "value", start, end, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
#	$Tween.interpolate_method(self, "update_count_text", start, end, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if end < start:
		pass
#		$AnimationPlayer.play("NumberShake")

func update_count_text(value):
	pass
#	$Count/Number.text = str(clamp(round(value / values_scalar), 0, maximum)) + '/' + str(maximum/values_scalar) + "Hp"


func _on_Stats_health_changed(value):
	animate_value(current_health, value * values_scalar)
	update_count_text(value)
	current_health = value * values_scalar


func _on_Timer_timeout():
	hide()
