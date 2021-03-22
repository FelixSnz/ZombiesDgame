extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $Insider
onready var heartUIEmpty = $Cointainer

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
#	print(hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 10

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 10

func _ready():
	# warning-ignore:return_value_discarded
	Global.player.stats.connect("health_changed", self, "set_hearts")
	# warning-ignore:return_value_discarded
	Global.player.stats.connect("max_health_changed", self, "set_max_hearts")
	self.max_hearts = Global.player.stats.max_health
	self.hearts = Global.player.stats.health
