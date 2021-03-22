extends Node
class_name MathTools

static func is_in_circle(circle_position, radius, vector):
	return pow(vector.x - circle_position.x, 2) + \
	pow(vector.y - circle_position.y, 2) < pow(radius, 2)

static func is_in_ellipse(ellipse_position, x_axis, y_axis, vector):
	var term1 = pow(vector.x - ellipse_position.x, 2)/pow(x_axis, 2)
	var term2 = pow(vector.y - ellipse_position.y, 2)/pow(y_axis, 2)
	return term1 + term2 <= 1
	
static func get_ellipse_radius(a, b, angle):
	var r = a*b/sqrt(pow(a, 2) * pow(sin(angle), 2) + pow(b, 2) * pow(cos(angle), 2) )
	return r
