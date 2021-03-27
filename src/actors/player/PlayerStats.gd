extends Node

export(int) var max_health setget set_max_health
var health = 0 setget set_health
var health_full = false

export(int) var max_energy setget set_max_energy
var energy = 0 setget set_energy
var energy_full = false

signal no_health
signal health_changed(value)
signal max_health_changed(value)

signal no_energy
signal energy_changed(value)
signal max_energy_changed(value)

func _ready():
	self.health = max_health
	self.energy = max_energy

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	if health != max_health:
		health_full = false
	else:
		health_full = true

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed")

func set_energy(value):
	var initial_energy = energy
	energy = clamp(value, 0, max_energy)
	if initial_energy != energy:
		emit_signal("energy_changed", energy)
	if energy <= 0:
		emit_signal("no_energy")


func set_max_energy(value):
	max_energy = value
	self.energy = min(energy, max_energy)
	emit_signal("max_energy_changed")
