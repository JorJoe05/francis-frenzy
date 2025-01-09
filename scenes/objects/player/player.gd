extends Entity
class_name Player

@export var state_machine: StateMachine

@export var physics: PlayerPhysics

@export_group("Ray Pairs", "ray")
@export var ray_pair_top: RayCollider
@export var ray_pair_bottom: RayCollider
@export var ray_pair_left: RayCollider
@export var ray_pair_right: RayCollider

var skid: bool = false
var face: int = 1

var yorbs: int = 0

func _ready() -> void:
	Game.player = self
	up_direction = Vector2.from_angle(rotation - (PI/2))

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

func _collide(detector: RayCollider) -> bool:
	var collision = detector.get_collision()
	var out = false
	var limit: int = 8
	
	velocity = collision.vector_to_local(velocity)
	if velocity.x < 0:
		pass
	else:
		while collision.is_point_colliding() and limit > 0:
			position += collision.get_snap_delta()
			velocity.x = min(velocity.x, 0)
			out = true
			limit -= 1
			collision = detector.get_collision()
	
	velocity = collision.vector_to_global(velocity)
	normal = collision.get_normal()
	
	return out

func _snap(detector: RayCollider) -> bool:
	var collision = detector.get_collision()
	if collision.is_ray_colliding():
		position += collision.get_snap_delta()
		velocity = collision.vector_to_local(velocity)
		velocity.x = min(velocity.x, 0)
		velocity = collision.vector_to_global(velocity)
		normal = collision.get_normal()
		return true
	return false

func collide_floor() -> bool:
	ground_on = _collide(ray_pair_bottom)
	if ground_on:
		pass#velocity.y = min(velocity.y, 0)
		#print(velocity)
	return ground_on

func collide_ceiling() -> bool:
	var _collide = _collide(ray_pair_top)
	if _collide:
		pass
		#velocity.y = max(velocity.y, 0)
	return _collide

func collide_left_wall() -> bool:
	var _collide = _collide(ray_pair_left)
	if _collide:
		pass
		#velocity.x = max(velocity.x, 0)
	return _collide

func collide_right_wall() -> bool:
	var _collide = _collide(ray_pair_right)
	if _collide:
		pass
		#velocity.x = min(velocity.x, 0)
	return _collide

func collide_walls() -> bool:
	return _collide(ray_pair_left) or _collide(ray_pair_right)

func snap_floor() -> bool:
	if ground_on == false:
		return false
	ground_on = _snap(ray_pair_bottom)
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
