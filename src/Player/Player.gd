extends KinematicBody2D

var velocity = Vector2.ZERO
export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(PackedScene) var INITIAL_WEAPON

const Gun = preload("res://src/Weapons/Firearms/gun/Gun.tscn")
const Crowbar = preload("res://src/Weapons/melee/crowbar/Crowbar.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rightHand = $Sprite/RightHand
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var weaponPos = $WeaponPos
onready var twen = $Tween
onready var stats = PlayerStats

const RightHand = preload("res://src/Player/RightHand.tscn")
signal face_side_changued(side)
var weapon

enum {
	MOVE,
	INV
}
var state = MOVE
var can_toggle = true
var direction

func _ready():
	sprite.scale = Vector2.ONE
	
	stats.connect("no_health", self, "queue_free")
	if INITIAL_WEAPON != null:
		if weaponPos.get_child_count() > 0:
			weaponPos.remove_child(weaponPos.get_child(0))
		weapon = INITIAL_WEAPON.instance()
		weaponPos.add_child(weapon)
		grab_weapon()
# warning-ignore:return_value_discarded
	connect("face_side_changued", weapon, "facing_side_changued")

func running_with_weapon():
	if weapon.is_in_group("Melee"):
		weapon.reset_rotation()

func has_weapon():
	return weapon != null

func grab_weapon():
	if has_weapon():
		if weapon is Sprite:
			weapon.add_child(RightHand.instance())
			return
		var found = false
		for child in weapon.get_children():
			if child.name == "Sprite":
				var rightHand_ = RightHand.instance()
				child.add_child(rightHand_)
				break
			for little_child in child.get_children():
				if little_child.name == "Sprite":
					var rightHand_ = RightHand.instance()
					little_child.add_child(rightHand_)
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
	

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_C and event.is_pressed():
			if weapon.name == "Sword":
				var wep = weaponPos.get_child(0)
				wep.queue_free()
				weapon = Gun.instance()
				weaponPos.add_child(weapon)
# warning-ignore:return_value_discarded
				connect("face_side_changued", weapon, "facing_side_changued")
			elif weapon.name == "Gun":
				var wep = weaponPos.get_child(0)
				wep.queue_free()
				weapon = Crowbar.instance()
				weaponPos.add_child(weapon)
# warning-ignore:return_value_discarded
				connect("face_side_changued", weapon, "facing_side_changued")
			grab_weapon()

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
	if direction.x < 0 and can_toggle:
#		print("facing left")
		emit_signal("face_side_changued", -1)
		can_toggle = not can_toggle
		sprite.scale.x = -1
	elif direction.x > 0 and not can_toggle:
#		print("facing right")
		emit_signal("face_side_changued", 1)
		can_toggle = not can_toggle
		sprite.scale.x = 1


func _process(_delta):
	$Label.text = str(position /28)

func _on_HurtBox_area_entered(_area):
	hurtBox.start_invincivility(1)
	$Blink.play("inv")
