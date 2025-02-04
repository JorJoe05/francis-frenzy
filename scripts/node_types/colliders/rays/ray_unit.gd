@tool
class_name RayUnit
extends RayCollider

signal collision_enter
signal collision_exit
signal snap_enter
signal snap_exit

const layer_ledge_solid = 1
const layer_slope_solid = 2
const layer_ledge_semisolid = 4
const layer_slope_semisolid = 8
const layers_ledge = layer_ledge_solid + layer_ledge_semisolid
const layers_slope = layer_slope_solid + layer_slope_semisolid
const layers_solid = layer_ledge_solid + layer_slope_solid
const layers_semisolid = layer_ledge_semisolid + layer_slope_semisolid

@export var disabled: bool = false:
	set(value):
		disabled = value
		_update()
@export var slope: bool = true:
	set(value):
		slope = value
		_update()
		queue_redraw()
@export var one_way: bool = false:
	set(value):
		one_way = value
		_update()
		queue_redraw()

var collision_mask: int

var _has_collided: bool = false
var _collision: RayCollision
var _space: PhysicsDirectSpaceState2D

var _point_intersections: Array
var _ray_intersection: Dictionary

var _is_colliding: bool = false:
	set(value):
		if _is_colliding != value:
			if value == true:
				collision_enter.emit()
			else:
				collision_exit.emit()
		_is_colliding = value
var _is_snapping: bool = false:
	set(value):
		if _is_snapping != value:
			if value == true:
				snap_enter.emit()
			else:
				snap_exit.emit()
		_is_snapping = value

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var space_rid = get_world_2d().space
	_space = PhysicsServer2D.space_get_direct_state(space_rid)
	_update()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	set_deferred(&"_has_collided", false)
	queue_redraw()

func _update() -> void:
	if slope:
		collision_mask = layers_solid
		if one_way:
			collision_mask += layers_semisolid
	else:
		collision_mask = layer_ledge_solid
		if one_way:
			collision_mask += layer_ledge_semisolid

func _draw() -> void:
	if Engine.is_editor_hint():
		var arrow_points: PackedVector2Array = [
			Vector2(-1, 0.5),
			Vector2(-1, -0.5),
			Vector2(0, 0)
		]
		var colors: PackedColorArray = [
			Color.WHITE, Color.WHITE, Color.WHITE
		]
		if slope:
			colors.fill(Color.GREEN)
		if _is_colliding:
			colors.fill(Color.RED)
		draw_polygon(arrow_points, colors)

func _update_intersections():
	if disabled:
		return []
	var params = PhysicsPointQueryParameters2D.new()
	params.collision_mask = collision_mask
	params.position = global_position# + Vector2(1, 0).rotated(global_rotation)
	params.exclude = [owner.get_rid()]
	_point_intersections = _space.intersect_point(params, 32)
	params = PhysicsRayQueryParameters2D.new()
	params.collision_mask = collision_mask
	params.from = (Vector2.LEFT * 8).rotated(global_rotation) + global_position
	params.to = (Vector2.RIGHT * 8).rotated(global_rotation) + global_position
	params.hit_from_inside = true
	params.exclude = [owner.get_rid()]
	_ray_intersection = _space.intersect_ray(params)

func update_collision() -> RayCollision:
	_update_intersections()
	_collision = RayCollision.new(global_position, _point_intersections, _ray_intersection, global_rotation)
	_has_collided = true
	return _collision

func get_collision() -> RayCollision:
	if _has_collided == false:
		update_collision()
	
	return _collision

func detect() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
		_is_colliding = _collision.is_point_colliding()
	
	return _is_colliding

func detect_ext() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
		_is_snapping = _collision.is_point_colliding()
	
	return _collision.is_ray_colliding()

func bounce() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
		_is_colliding = _collision.is_point_colliding()
	
	if _is_colliding:
		owner.position += _collision.get_snap_delta()
		if _collision.get_normal() != Vector2.ZERO:
			owner.set_deferred(&"velocity", owner.velocity.bounce(_collision.get_normal()))
	
	return _is_colliding

func push() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
		_is_colliding = _collision.is_point_colliding()
	
	if _is_colliding:
		owner.position += _collision.get_snap_delta()
	
	return _is_colliding

func collide() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
	
	var _owner_velocity_local = _collision.vector_to_local(owner.velocity)
	var _collider_velocity_local = _collision.vector_to_local(_collision.get_collider_velocity())
	
	if not _collision.is_point_colliding() or round(_owner_velocity_local.x) < round(_collider_velocity_local).x:
		_is_colliding = false
		return false
	
	owner.position += _collision.get_snap_delta()
	
	var post_update = func():
		#update_collision()
		
		_owner_velocity_local.x = min(_owner_velocity_local.x, _collider_velocity_local.x)
		
		owner.velocity = _collision.vector_to_global(_owner_velocity_local)
		
		_collider_velocity_local = _collision.get_collider_velocity()
		owner.position += _collider_velocity_local / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	post_update.call_deferred()
	
	_is_colliding = true
	return true

func snap() -> bool:
	assert(owner is CharacterBody2D)
	
	if _has_collided == false:
		update_collision()
	
	var _owner_velocity_local = _collision.vector_to_local(owner.velocity)
	var _collider_velocity_local = _collision.vector_to_local(_collision.get_collider_velocity())
	
	if not _collision.is_ray_colliding():
		_is_colliding = false
		return false
	
	owner.position += _collision.get_snap_delta()
	
	var post_update = func():
		#update_collision()
		
		_owner_velocity_local.x = min(_owner_velocity_local.x, _collider_velocity_local.x)
		
		owner.velocity = _collision.vector_to_global(_owner_velocity_local)
		
		_collider_velocity_local = _collision.get_collider_velocity()
		owner.position += _collider_velocity_local / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	post_update.call_deferred()
	
	_is_colliding = true
	return true
