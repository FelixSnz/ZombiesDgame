extends Node2D


var noise = OpenSimplexNoise.new()

func _ready():
	noise.seed = randi()
	noise.persistence = 0.8
	noise.period = 20
	noise.octaves = 4
	print(noise.get_noise_1d(12))
