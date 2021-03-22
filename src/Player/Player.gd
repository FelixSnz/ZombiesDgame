extends KinematicBody2D

export(float, 1, 500) var MAX_SPEED
export(float, 1, 500) var ACCELERATION
export(float, 1, 500) var FRICTION
export(PackedScene) var INITIAL_WEAPON

const Gun = preload("res://src/Weapons/Firearms/gun/Gun.tscn")
const Crowbar = preload("res://src/Weapons/melee/crowbar/Crowbar.tscn")
const RightHand = preload("res://src/Player/RightHand.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rightHand = $Sprite/RightHand
onready var rightHand2 = $Sprite/RightHand2
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var weaponPos = $WeaponPos
onready var twen = $Tween
onready var stats = $PlayerStats
onready var remoteTransform = $RemoteTransform2D

signal face_side_changued(side)
signal anim_started(anim_name)
signal weapon_changued

enum {
	MOVE,
	INV
}
var velocity = Vector2.ZERO
var state = MOVE
var side_toggle = true
var anim_toggle = true
var prev_anim
var direction
var weapon

func _ready():
	var camera = get_tree().current_scene.get_node("Camera2D")
	Global.player = self
# warning-ignore:return_value_discarded
	connect("weapon_changued", camera, "_on_Player_weapon_changued")
	remoteTransform.remote_path = NodePath(camera.get_path())
	sprite.scale = Vector2.ONE
#	stats.connect("no_health", self, "queue_free")
	if INITIAL_WEAPON != null:
		if weaponPos.get_child_count() > 0:
			weaponPos.remove_child(weaponPos.get_child(0))
		weapon = INITIAL_WEAPON.instance()
		weaponPos.add_child(weapon)
		grab_weapon()
	connect_weapon_methods()
	emit_signal("weapon_changued")

func _physics_process(delta):
	direction = (get_global_mouse_position() - global_position).normalized()
	match state:
		MOVE:
			move_state(delta)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 600
		velocity = move_and_slide(velocity)

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
	velocity = move_and_slide(velocity)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_C and event.is_pressed():
			if weapon.name == "Crowbar":
				var wep = weaponPos.get_child(0)
				wep.queue_free()
				weapon = Gun.instance()
				weaponPos.add_child(weapon)
				connect_weapon_methods()
				emit_signal("weapon_changued")
			elif weapon.name == "Gun":
				var wep = weaponPos.get_child(0)
				wep.queue_free()
				weapon = Crowbar.instance()
				weaponPos.add_child(weapon)
				connect_weapon_methods()
				emit_signal("weapon_changued")
			grab_weapon()

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

func update_facing():
	if direction.x < 0 and side_toggle:
		emit_signal("face_side_changued", -1)
		side_toggle = not side_toggle
		sprite.scale.x = -1
	elif direction.x > 0 and not side_toggle:
		emit_signal("face_side_changued", 1)
		side_toggle = not side_toggle
		sprite.scale.x = 1

func has_weapon():
	return weapon != null

func connect_weapon_methods():
# warning-ignore:return_value_discarded
	connect("face_side_changued", weapon, "facing_side_changued")
# warning-ignore:return_value_discarded
	connect("anim_started", weapon, "player_anim_changued")

func _on_HurtBox_area_entered(area):
	hurtBox.start_invincivility(1)
	stats.health -= area.damage
	if stats.health <= 0:
		queue_free()
	$Blink.play("inv")

func _on_AnimationPlayer_animation_started(anim_name):
	if prev_anim != anim_name and anim_toggle:
		emit_signal("anim_started", anim_name)
		anim_toggle = not anim_toggle
	elif prev_anim == anim_name and not anim_toggle:
		anim_toggle = not anim_toggle
	prev_anim = anim_name
