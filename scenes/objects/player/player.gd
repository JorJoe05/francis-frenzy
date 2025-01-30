extends Entity
class_name Player

@export_group("Nodes")
@export var state_machine: StateMachine
@export var camera: PhantomCamera2D
@export var camera_target: Node2D
@export var scream_emitter: Node2D

@export_group("Resources")
@export var physics: PlayerPhysics

@onready var _scream_wave = preload("res://scenes/objects/player/shared/scream_wave.tscn")

var skid: bool = false
var coyote_time: float
var jump_buffer: float

var yorbs: int = 0

func _ready() -> void:
	Game.player = self
	add_to_group(&"Player")
	up_direction = Vector2.from_angle(rotation - (PI/2))
	await get_tree().create_timer(1.0/60.0).timeout
	camera.set_follow_damping(true)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	camera_target.position.x = move_toward(camera_target.position.x, (abs(0.0) + 64.0) * face, 4)
	scream_emitter.position.x = 16 * face
	
	if ground_on:
		coyote_time = physics.coyote_time
	else:
		coyote_time = max(coyote_time - delta, 0.0)
	
	jump_buffer = max(jump_buffer - delta, 0.0)
	if not ground_on and Input.is_action_just_pressed("jump"):
		jump_buffer = physics.jump_buffer
	elif not Input.is_action_pressed("jump"):
		jump_buffer = 0.0

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
	var _scream_0 = _scream_wave.instantiate()
	_scream_0.sprite.rotation = Vector2(face, 0.2).angle()
	_scream_0.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_0)
	var _scream_1 = _scream_wave.instantiate()
	_scream_1.sprite.rotation = Vector2(face, 0.1).angle()
	_scream_1.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_1)
	var _scream_2 = _scream_wave.instantiate()
	_scream_2.sprite.rotation = Vector2(face, 0.0).angle()
	_scream_2.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_2)
	var _scream_3 = _scream_wave.instantiate()
	_scream_3.sprite.rotation = Vector2(face, -0.1).angle()
	_scream_3.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_3)
	var _scream_4 = _scream_wave.instantiate()
	_scream_4.sprite.rotation = Vector2(face, -0.2).angle()
	_scream_4.global_position = scream_emitter.global_position
	get_tree().current_scene.add_child(_scream_4)
