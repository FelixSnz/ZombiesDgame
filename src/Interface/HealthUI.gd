extends Control

var energy_bar

func _ready():
	energy_bar = get_node_or_null("EnergyBar")
	if energy_bar != null:
		$EnergyBar.initialize(Global.player.stats.max_energy)
	
	$HealthBar.initialize(Global.player.stats.max_health)
	

func _on_PlayerStats_health_changed(value):
	$HealthBar._on_Interface_health_updated(value)


func _on_PlayerStats_energy_changed(value):
	$EnergyBar.update_value(value)
