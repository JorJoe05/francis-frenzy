@tool
class_name RayUnit
extends RayCollider

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

var space: PhysicsDirectSpaceState2D

func _ready() -> void:
	if not Engine.is_editor_hint():
		var space_rid = get_world_2d().space
		space = PhysicsServer2D.space_get_direct_state(space_rid)
		_update()

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
		draw_polygon(arrow_points, colors)

func _get_point_intersections(max_results: int = 32) -> Array:
	if disabled:
		return []
	var params = PhysicsPointQueryParameters2D.new()
	params.collision_mask = collision_mask
	params.position = global_position# + Vector2(1, 0).rotated(global_rotation)
	params.exclude = [owner.get_rid()]
	return space.intersect_point(params, max_results)

func _get_ray_intersection() -> Dictionary:
	if disabled:
		return {}
	var params = PhysicsRayQueryParameters2D.new()
	params.collision_mask = collision_mask
	params.from = (Vector2.LEFT * 8).rotated(global_rotation) + global_position
	params.to = (Vector2.RIGHT * 8).rotated(global_rotation) + global_position
	params.hit_from_inside = true
	params.exclude = [owner.get_rid()]
	return space.intersect_ray(params)

func get_collision() -> RayCollision:
	return RayCollision.new(global_position, _get_point_intersections(), _get_ray_intersection(), global_rotation)
