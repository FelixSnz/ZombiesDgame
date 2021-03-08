extends Particles2D

var start = false
var time = 0

func _process(delta):
	 if emitting and not start:
		  start = true
	 if start:
		  time += delta
	 if time > lifetime:
		  queue_free()
