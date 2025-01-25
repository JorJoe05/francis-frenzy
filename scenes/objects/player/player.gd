extends Entity
class_name Player

@export var curve_test: Curve

@export_group("Nodes")
@export var state_machine: StateMachine
@export var camera: PhantomCamera2D

@export_group("Resources")
@export var physics: PlayerPhysics

var skid: bool = false
var face: int = 1

var yorbs: int = 0

func _ready() -> void:
	Game.player = self
	up_direction = Vector2.from_angle(rotation - (PI/2))

func _physics_process(delta: float) -> void:
	$CameraTarget.position.x = move_toward($CameraTarget.position.x, (abs(0.0) + 64.0) * face, 4)

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

func apply_friction() -> void:
	if ground_on:
		var acc_half = func(): velocity.x -= (min(abs(velocity.x), physics.speed_frc) * sign(velocity.x))
		acc_half.call()
		if velocity.x == 0:
			skid = false
	else:
		velocity.x *= physics.speed_frc_air

#endregion

#region Collision

func collide_floor() -> bool:
	ground_on = ray_collider_bottom.collide()
	if ground_on:
		pass#velocity.y = min(velocity.y, 0)
		#print(velocity)
	return ground_on

func collide_ceiling() -> bool:
	var _collide = ray_collider_top.collide()
	if _collide:
		pass
		#velocity.y = max(velocity.y, 0)
	return _collide

func collide_left_wall() -> bool:
	var _collide = ray_collider_left.collide()
	if _collide:
		pass
		#velocity.x = max(velocity.x, 0)
	return _collide

func collide_right_wall() -> bool:
	var _collide = ray_collider_right.collide()
	if _collide:
		pass
		#velocity.x = min(velocity.x, 0)
	return _collide

func collide_walls() -> bool:
	return ray_collider_left.collide() or ray_collider_right.collide()

func snap_floor() -> bool:
	if ground_on == false:
		return false
	ground_on = ray_collider_bottom.snap()
	if ground_on:
		pass
		#velocity.y = min(velocity.y, 0)
	return ground_on

func gravity_adjust_start() -> void:
	velocity = vector_to_global(velocity)
	normal = vector_to_global(normal)

func gravity_adjust_end() -> void:
	velocity = vector_to_local(velocity)
	normal = vector_to_local(normal)

func set_gravity(new_up_direction) -> void:
	var prev_up_direction = up_direction
	up_direction = new_up_direction
	var rotate_velocity = func():
		velocity = velocity.rotated(angle_difference(new_up_direction.angle(), prev_up_direction.angle()))
		rotation = new_up_direction.angle() + PI/2
	rotate_velocity.call_deferred()

#endregion
