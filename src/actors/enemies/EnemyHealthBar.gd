extends TextureProgress

var maximum = 100
var maximun_withe = 100
var current_health = 0
var values_scalar = 10 

func initialize(max_val):
	hide()
	max_value = max_val * values_scalar
	$TextureProgress.max_value = max_val * values_scalar
	maximum = max_val * values_scalar
	maximun_withe = max_val * values_scalar

func animate_value(start, end):
	show()
	$Timer.start(3)
	$Tween.interpolate_property(self, "value", start, end, .5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.interpolate_property($TextureProgress, "value", $TextureProgress.value, end, .7, Tween.TRANS_LINEAR)
	$Tween.start()
	if end < start:
		pass

func _on_Stats_health_changed(value):
	animate_value(current_health, value * values_scalar)
	current_health = value * values_scalar

func _on_Timer_timeout():
	hide()
