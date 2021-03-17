extends Node2D


const Point = preload("res://point.tscn")
var counter = 0
var point
var center_p


func create_instance(Obj, pos):
	var instance = Obj.instance()
	var world = get_tree().current_scene
	world.add_child(instance)
	instance.global_position = pos
	return instance
	
	
func _ready():
	point = create_instance(Point, Vector2.ZERO)
	create_instance(Point, Vector2(500, 300))

func is_in_circle(circle_position, radius, vector):
	return pow(vector.x - circle_position.x, 2) + \
	pow(vector.y - circle_position.y, 2) < pow(radius, 2)

func is_in_ellipse(ellipse_position, x_axis, y_axis, vector):
	var term1 = pow(vector.x - ellipse_position.x, 2)/pow(x_axis, 2)
	var term2 = pow(vector.y - ellipse_position.y, 2)/pow(y_axis, 2)
	return term1 + term2 <= 1
func get_ellipse_radius(a, b, angle):
	var r = a*b/sqrt(pow(a, 2) * pow(sin(angle), 2) + pow(b, 2) * pow(cos(angle), 2) )
	return r

 
func _process(delta):
	var center = Vector2(500, 300)
	var pointing_direction = (get_global_mouse_position() - center).normalized()
#	print(pointing_direction)

		
	var pos = point.global_position

	if is_in_ellipse(center, 100, 30, pos.linear_interpolate(get_global_mouse_position(), delta * 2)):
		point.global_position = pos.linear_interpolate(get_global_mouse_position(), delta * .3)
	else:
		var ellip_radius = get_ellipse_radius(100, 30, pointing_direction.angle())
		print(ellip_radius)
		var diff = center + pointing_direction * ellip_radius
		point.global_position = point.global_position.linear_interpolate(diff, delta * 2)
	
#	point.global_position = point.global_position.linear_interpolate(get_global_mouse_position(), delta * .8)
#	counter += delta
#
#	if counter % 1:
#		var pos = 
#		create_instance(Point,)
	
