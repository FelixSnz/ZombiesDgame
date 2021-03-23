extends Control

func _ready():
	$ProgressBar.initialize(Global.player.stats.max_health)

func _on_player_health_changued(new_health):
	$ProgressBar._on_Interface_health_updated(new_health)
