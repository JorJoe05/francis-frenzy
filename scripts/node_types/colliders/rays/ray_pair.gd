@tool
class_name RayPair
extends RayCollider

@export var disabled: bool = false
@export var ledge_ray_offset_left: float = -6.0:
	set(value):
		ledge_ray_offset_left = value
		_update_detector(ledge_ray_left, value, false)
		queue_redraw()
@export var ledge_ray_offset_right: float = 6.0:
	set(value):
		ledge_ray_offset_right = value
		_update_detector(ledge_ray_right, value, false)
		queue_redraw()
@export var slope_ray_offset_left: float = 0.0:
	set(value):
		slope_ray_offset_left = value
		_update_detector(slope_ray_left, value, true)
		queue_redraw()
@export var slope_ray_offset_right: float = 0.0:
	set(value):
		slope_ray_offset_right = value
		_update_detector(slope_ray_right, value, true)
		queue_redraw()
@export var one_way: bool = false:
	set(value):
		one_way = value
		_update_detector(ledge_ray_left, value, false)
		_update_detector(ledge_ray_right, value, false)
		_update_detector(slope_ray_left, value, true)
		_update_detector(slope_ray_right, value, true)
		queue_redraw()

var ledge_ray_left: RayUnit
var ledge_ray_right: RayUnit
var slope_ray_left: RayUnit
var slope_ray_right: RayUnit

func _ready() -> void:
	if not Engine.is_editor_hint():
		ledge_ray_left = _create_detector(ledge_ray_offset_left, false)
		ledge_ray_right = _create_detector(ledge_ray_offset_right, false)
		slope_ray_left = _create_detector(slope_ray_offset_left, true)
		slope_ray_right = _create_detector(slope_ray_offset_right, true)

func _create_detector(offset: float, slope: bool):
	if not Engine.is_editor_hint():
		var detector: RayUnit = RayUnit.new()
		detector.position = Vector2.UP * offset
		detector.slope = slope
		detector.one_way = one_way
		add_child(detector, false, Node.INTERNAL_MODE_FRONT)
		detector.owner = owner
		return detector

func _update_detector(detector: RayUnit, offset: float, slope: bool):
	if not Engine.is_editor_hint():
		if detector is not RayUnit:
			return
		detector.position = Vector2.UP * offset
		detector.slope = slope
		detector.one_way = one_way

func get_collision() -> RayCollision:
	var max_collision = null
	var detectors = [ledge_ray_left, ledge_ray_right, slope_ray_left, slope_ray_right]
	for detector in detectors:
		var collision = detector.get_collision()
		if max_collision == null:
			if collision.is_ray_colliding():
				max_collision = collision
		else:
			if collision.get_relative_snap_delta() < max_collision.get_relative_snap_delta() and collision.is_ray_colliding():
				max_collision = collision
	if max_collision == null:
		max_collision = detectors[0].get_collision()
	return max_collision

func _draw() -> void:
	if true:#zEngine.is_editor_hint():
		for offset in [[ledge_ray_offset_left, false], [ledge_ray_offset_right, false], [slope_ray_offset_left, true], [slope_ray_offset_right, true]]:
			var arrow_points: PackedVector2Array = [
				Vector2(-1, 0.5) + (Vector2.UP * offset[0]),
				Vector2(-1, -0.5) + (Vector2.UP * offset[0]),
				Vector2(0, 0) + (Vector2.UP * offset[0])
			]
			var colors: PackedColorArray = [
				Color.WHITE, Color.WHITE, Color.WHITE
			]
			if offset[1]:
				colors.fill(Color.GREEN)
			draw_polygon(arrow_points, colors)
