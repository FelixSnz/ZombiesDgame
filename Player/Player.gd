extends KinematicBody2D

var velocity = Vector2.ZERO
export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(PackedScene) var INITIAL_WEAPON

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var weaponPos = $Sprite/WeaponPos
onready var stats = PlayerStats

const RightHand = preload("res://Player/RightHand.tscn")

var weapon

enum {
	MOVE,
	INV
}
var state = MOVE
var direction

func _ready():
	stats.connect("no_health", self, "queue_free")
	if INITIAL_WEAPON != null:
		if weaponPos.get_child_count() > 0:
			weaponPos.remove_child(weaponPos.get_child(0))
		weapon = INITIAL_WEAPON.instance()
		weaponPos.add_child(weapon)
		grab_weapon()

func running_with_weapon():
	if weapon.is_in_group("Melee"):
		weapon.reset_rotation()

func has_weapon():
	return weapon != null

func grab_weapon():
	if has_weapon():
		var found = false
		for child in weapon.get_children():
			print(child.name)
			if child.name == "Sprite":
				var rightHand = RightHand.instance()
				child.add_child(rightHand)
				break
			for little_child in child.get_children():
				if little_child.name == "Sprite":
					var rightHand = RightHand.instance()
					little_child.add_child(rightHand)
					found = true
					break
			if found:
				break
			
	
func _physics_process(delta):
	direction = (get_global_mouse_position() - global_position).normalized()
	
	match state:
		MOVE:
			move_state(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 600
		move()

func move_state(delta):
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vec = input_vec.normalized()
	if input_vec != Vector2.ZERO:
		update_facing()
		velocity = velocity.move_toward(input_vec * MAX_SPEED, ACCELERATION * delta)
		animationPlayer.play("Run")

	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		update_facing()
		animationPlayer.play("Idle")
	move()

func move():
	velocity = move_and_slide(velocity)

func update_facing():
	if direction.x < 0:
		sprite.scale.x = -1
	elif direction.x > 0:
		sprite.scale.x = 1

func _process(_delta):
	$Label.text = str(position /28)

func _on_HurtBox_area_entered(_area):
	hurtBox.start_invincivility(1)
	$Blink.play("inv")
