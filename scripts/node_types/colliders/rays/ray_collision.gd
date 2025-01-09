class_name RayCollision
extends Resource

var position: Vector2
var _point_intersections: Array
var _ray_intersection: Dictionary
var rotation: float

func _init(_position, point_intersections: Array, ray_intersection: Dictionary, _rotation: float) -> void:
	position = _position
	_point_intersections = point_intersections
	_ray_intersection = ray_intersection
	rotation = _rotation

func is_point_colliding() -> bool:
	var intersections = _point_intersections
	return intersections.size() > 0

func is_ray_colliding() -> bool:
	var intersection = _ray_intersection
	return not intersection.is_empty()

func is_ray_colliding_from_inside() -> bool:
	var intersection = _ray_intersection
	if not intersection.is_empty():
		return intersection["normal"] == Vector2.ZERO
	return false

func get_snap_delta() -> Vector2:
	var intersection = _ray_intersection
	if not intersection.is_empty():
		return intersection["position"] - position
	return Vector2.ZERO

func get_relative_snap_delta() -> float:
	var intersection = _ray_intersection
	if not intersection.is_empty():
		var snap_delta = get_snap_delta()
		snap_delta = vector_to_local(snap_delta)
		return snap_delta.x
	return 0.0

func get_normal() -> Vector2:
	var intersection = _ray_intersection
	if not intersection.is_empty():
		return intersection["normal"]
	return Vector2.ZERO

func get_properties() -> PackedStringArray:
	var output: Variant
	var intersection = _ray_intersection
	if not intersection.is_empty():
		var collider = intersection["collider"]
		if collider is TileMapLayer:
			var map_position = collider.local_to_map(position)
			var tile_data = collider.get_cell_tile_data(map_position)
			if not tile_data == null:
				output = tile_data.get_custom_data("properties")
		else:
			if collider.has_meta("properties"):
				output = collider.get_meta("properties")
	if output is PackedStringArray:
		return output
	return []

func get_collider() -> Node2D:
	var intersection = _ray_intersection
	return _ray_intersection["collider"]

func vector_to_local(vector: Vector2) -> Vector2:
	return vector.rotated(-rotation)

func vector_to_global(vector: Vector2) -> Vector2:
	return vector.rotated(rotation)
