extends Control

func _ready():
	$HealthBar.initialize(Global.player.stats.max_health)
	$EnergyBar.initialize(Global.player.stats.max_energy)

func _on_PlayerStats_health_changed(value):
	$HealthBar._on_Interface_health_updated(value)


func _on_PlayerStats_energy_changed(value):
	$EnergyBar.update_value(value)
