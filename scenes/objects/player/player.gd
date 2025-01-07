extends Entity
class_name Player

@export var state_machine: StateMachine

@export var physics: PlayerPhysics

@export var ray_pair_top: RayCollider
@export var ray_pair_bottom: RayCollider
@export var ray_pair_left: RayCollider
@export var ray_pair_right: RayCollider

var skid: bool = false
var face: int = 1

func _ready() -> void:
	Game.player = self
	up_direction = Vector2.from_angle(rotation - (PI/2))

#region Physics

func apply_friction(delta: float) -> void:
	if ground_on:
		var acc_half = func(): velocity.x -= (min(abs(velocity.x), physics.speed_frc) * sign(velocity.x))
		acc_half.call()
		if velocity.x == 0:
			skid = false
	else:
		velocity.x = velocity.x * physics.speed_frc_air
		#velocity.x *= physics.speed_frc_air
		#TODO fix delta time

func accelerate(delta: float, sign: int) -> void:
	var _speed_acc = physics.speed_acc if ground_on else physics.speed_acc_air
	var _min_max = func(val1, val2): return max(val1, val2) if sign == -1 else min(val1, val2)
	var acc_half = func(): velocity.x = _min_max.call(velocity.x + _speed_acc * sign, physics.speed_run * sign)
	acc_half.call()

func decelerate(delta: float, sign: int) -> void:
	var _speed_dec = physics.speed_dec if ground_on else physics.speed_dec_air
	var dec_half = func(): velocity.x -= _speed_dec * sign
	dec_half.call()

#endregion

#region Collision

func _collide(detector: RayCollider) -> bool:
	var collision = detector.get_collision()
	if collision.is_point_colliding():
		position += collision.get_snap_delta()
		velocity = velocity.project(Vector2.UP.rotated(collision.direction * (PI/2)))
		return true
	return false

func _snap(detector: RayCollider) -> bool:
	var collision = detector.get_collision()
	if collision.is_ray_colliding():
		position += collision.get_snap_delta()
		velocity = velocity.project(Vector2.UP.rotated(collision.direction * (PI/2)))
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			var adjust = func(): position += collider.velocity / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
			adjust.call_deferred()
		if collider is StaticBody2D:
			var adjust = func(): position += collider.constant_linear_velocity / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
			adjust.call_deferred()

		if collider is TileMapLayer:
			var collision_point = Vector2i(collision.position)
			var collision_direction = collision.direction
			var offset = Vector2i(0,0)
			match(collision_direction):
				RayCollider.dir.right:
					offset.x += 16
				RayCollider.dir.down:
					offset.y += 16
				RayCollider.dir.left:
					offset.x -= 16
				RayCollider.dir.up:
					offset.y -= 16
			var cell = collider.local_to_map(collision_point)
			var tile_data = collider.get_cell_tile_data(cell)
			
			if !tile_data:
				cell = collider.local_to_map(collision_point+offset)
				tile_data = collider.get_cell_tile_data(cell)
			# Assume right = 0, down = 1, etc, and make sure tiles that collide with the
			# x detector have a physics layer and approriate velocity on layer x + 1
			# where x is right,down,left,up. physics layer 0 is the tile's "body"
			if tile_data:
				var tile_velocity = tile_data.get_constant_linear_velocity(collision_direction + 1)
				if tile_velocity:
					var adjust = func(): position += tile_velocity / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
					adjust.call_deferred()
		return true
	return false

func collide_floor() -> bool:
	if velocity.y < 0:
		ground_on = false
		return ground_on
	ground_on = _collide(ray_pair_bottom)
	if ground_on:
		velocity.y = min(velocity.y, 0)
		print(velocity)
	return ground_on

func collide_ceiling() -> bool:
	var _collide = _collide(ray_pair_top)
	if _collide:
		velocity.y = max(velocity.y, 0)
	return _collide

func collide_left_wall() -> bool:
	var _collide = _collide(ray_pair_left)
	if _collide:
		velocity.x = max(velocity.x, 0)
	return _collide

func collide_right_wall() -> bool:
	var _collide = _collide(ray_pair_right)
	if _collide:
		velocity.x = min(velocity.x, 0)
	return _collide

func collide_walls() -> bool:
	return _collide(ray_pair_left) or _collide(ray_pair_right)

func snap_floor() -> bool:
	if ground_on == false:
		return false
	ground_on = _snap(ray_pair_bottom)
	if ground_on:
		velocity.y = min(velocity.y, 0)
	return ground_on

func set_collider_up_direction() -> void:
	var test = RayCollider.dir.up
	var directions = [
		[RayCollider.dir.up, RayCollider.dir.down, RayCollider.dir.left, RayCollider.dir.right],
		[RayCollider.dir.down, RayCollider.dir.up, RayCollider.dir.right, RayCollider.dir.left],
		[RayCollider.dir.right, RayCollider.dir.left, RayCollider.dir.down, RayCollider.dir.up],
		[RayCollider.dir.left, RayCollider.dir.right, RayCollider.dir.up, RayCollider.dir.down]
	]

#endregion
