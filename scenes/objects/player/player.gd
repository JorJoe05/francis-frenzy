extends Entity
class_name Player

@export_group("Nodes")
@export var state_machine: StateMachine
@export var camera: PhantomCamera2D
@export var camera_target: Node2D
@export var scream_emitter: Node2D
@export var health: HealthComponent

@export_group("Resources")
@export var physics: PlayerPhysics

@onready var _scream_wave = preload("res://scenes/objects/player/shared/scream_wave.tscn")

var skid: bool = false
var pepsi: bool = false:
	set(value):
		pepsi = value
		hitbox.types[1] = &"pepsi" if pepsi else &""
var coyote_time: float
var jump_buffer: float
var invincibility: float

var yorbs: int = 0:
	set(value):
		yorbs = value
		if yorbs >= 100:
			health.heal()
			%Heal.play()
			yorbs -= 100

func _ready() -> void:
	add_to_group(&"Player")
	up_direction = Vector2.from_angle(rotation - (PI/2))
	await get_tree().create_timer(1.0/60.0).timeout
	camera.follow_damping = true

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	$CameraTargetRoot.global_position = global_position
	camera_target.position = camera_target.position.move_toward(-up_direction.orthogonal() * face * 64, 4)
	scream_emitter.position.x = 16 * face
	
	if ground_on:
		coyote_time = physics.coyote_time
		pepsi = false
	else:
		coyote_time = max(coyote_time - delta, 0.0)
	
	if not state_machine.get_state() == &"Hurt":
		invincibility = max(invincibility - delta, 0.0)
		if invincibility > 0: sprite_root.visible = !sprite_root.visible
	else: sprite_root.visible = true
	
	jump_buffer = max(jump_buffer - delta, 0.0)
	if not ground_on and Input.is_action_just_pressed("jump"):
		jump_buffer = physics.jump_buffer
	elif not Input.is_action_pressed("jump"):
		jump_buffer = 0.0

func _animate() -> void:
	match state_machine.get_state():
		&"Normal":
			if ground_on:
				if abs(round(up_velocity.x)) == 0:
					animation_state_machine.travel(&"idle")
				else:
					animation_state_machine.travel(&"walk")
			else:
				if pepsi:
					animation_state_machine.travel(&"jump")
		&"Launch":
			animation_state_machine.travel(&"jump")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().set_auto_accept_quit(false)
		$Troll.play()
		#await get_tree().create_timer(1.9).timeout
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		var tween2 = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		tween.tween_property(sprite_root, "scale", Vector2.ONE * 40.0, 0.2)
		tween2.tween_property(sprite_root, "global_position", get_tree().root.get_camera_2d().get_screen_center_position(), 0.2)
		await get_tree().create_timer(0.2).timeout
		get_tree().quit()

#region Physics

func get_input_vector() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func get_rotated_input_vector() -> Vector2:
	return get_input_vector().rotated(-(up_direction.angle() + (PI/2)))

func can_jump() -> bool:
	var _can_jump = (coyote_time > 0.0 and Input.is_action_just_pressed("jump")) or (jump_buffer > 0.0 and ground_on)
	if _can_jump:
		coyote_time = 0.0
		jump_buffer = 0.0
	return _can_jump

func friction_ground() -> void:
	local_velocity.x -= min(abs(local_velocity.x), physics.speed_frc) * sign(local_velocity.x)
	if local_velocity.x == 0:
		skid = false

func friction_air() -> void:
	up_velocity.x *= physics.speed_frc_air

func apply_friction() -> void:
	if ground_on:
		var acc_half = func(): local_velocity.x -= (min(abs(local_velocity.x), physics.speed_frc) * sign(local_velocity.x))
		acc_half.call()
		if local_velocity.x == 0:
			skid = false
	else:
		velocity.x *= physics.speed_frc_air

#endregion

func scream() -> void:
	if animation_state_machine.get_current_node() == &"scream": return
	var _scream_0 = _scream_wave.instantiate()
	_scream_0.sprite.rotation = Vector2(face, 0.2).angle() + (up_direction.angle() + (PI/2))
	_scream_0.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_0)
	var _scream_1 = _scream_wave.instantiate()
	_scream_1.sprite.rotation = Vector2(face, 0.1).angle() + (up_direction.angle() + (PI/2))
	_scream_1.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_1)
	var _scream_2 = _scream_wave.instantiate()
	_scream_2.sprite.rotation = Vector2(face, 0.0).angle() + (up_direction.angle() + (PI/2))
	_scream_2.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_2)
	var _scream_3 = _scream_wave.instantiate()
	_scream_3.sprite.rotation = Vector2(face, -0.1).angle() + (up_direction.angle() + (PI/2))
	_scream_3.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_3)
	var _scream_4 = _scream_wave.instantiate()
	_scream_4.sprite.rotation = Vector2(face, -0.2).angle() + (up_direction.angle() + (PI/2))
	_scream_4.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_4)
	pepsi = false
	animation_state_machine.travel(&"scream")

func hurt(_hitbox: Hitbox2D) -> void:
	if state_machine.get_state() == &"Dead": return
	
	var _can_be_hurt = not state_machine.get_state() == &"Hurt" and invincibility == 0
	var _face = sign((_hitbox.owner.global_position - global_position).dot(-up_direction.orthogonal()))
	
	var _damage = func():
		if _can_be_hurt:
			health.damage()
			if health.is_depleted():
				state_machine.transition_to(&"Dead")
				return
			%Hurt.play()
			invincibility = 2.0
	var _state_enter = func():
		if _can_be_hurt and not state_machine.get_state() == &"Dead":
			state_machine.transition_to(&"Hurt", {"face": _face})
	
	if _hitbox.types.has(&"enemy") and not pepsi:
		_damage.call()
		_state_enter.call()
	
	elif _hitbox.types.has(&"lemonade"):
		_damage.call()
		state_machine.transition_to(&"Normal")
		up_velocity.y = -600.0
