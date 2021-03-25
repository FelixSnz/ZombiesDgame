extends Control

func _ready():
	$HealthBar.initialize(Global.player.stats.max_health)

func _on_PlayerStats_health_changed(value):
	$HealthBar._on_Interface_health_updated(value)
