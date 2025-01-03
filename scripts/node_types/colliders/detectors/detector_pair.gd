@tool
class_name DetectorPair
extends Detector

enum dir {
	right,
	down,
	left,
	up
}

@export_enum("Right", "Down", "Left", "Up") var down_direction: int = dir.down:
	set(value):
		down_direction = value
		_update_detector(ledge_detector_left, down_direction, direction, ledge_detector_offset_left, false)
		_update_detector(ledge_detector_right, down_direction, direction, ledge_detector_offset_right, false)
		_update_detector(slope_detector_left, down_direction, direction, slope_detector_offset_left, true)
		_update_detector(slope_detector_right, down_direction, direction, slope_detector_offset_right, true)
		queue_redraw()
@export_enum("Right", "Down", "Left", "Up") var direction: int = dir.down:
	set(value):
		direction = value
		_update_detector(ledge_detector_left, down_direction, direction, ledge_detector_offset_left, false)
		_update_detector(ledge_detector_right, down_direction, direction, ledge_detector_offset_right, false)
		_update_detector(slope_detector_left, down_direction, direction, slope_detector_offset_left, true)
		_update_detector(slope_detector_right, down_direction, direction, slope_detector_offset_right, true)
		queue_redraw()
@export var disabled: bool = false
@export var ledge_detector_offset_left: float = -6.0:
	set(value):
		ledge_detector_offset_left = value
		_update_detector(ledge_detector_left, down_direction, direction, value, false)
		queue_redraw()
@export var ledge_detector_offset_right: float = 6.0:
	set(value):
		ledge_detector_offset_right = value
		_update_detector(ledge_detector_right, down_direction, direction, value, false)
		queue_redraw()
@export var slope_detector_offset_left: float = 0.0:
	set(value):
		slope_detector_offset_left = value
		_update_detector(slope_detector_left, down_direction, direction, value, true)
		queue_redraw()
@export var slope_detector_offset_right: float = 0.0:
	set(value):
		slope_detector_offset_right = value
		_update_detector(slope_detector_right, down_direction, direction, value, true)
		queue_redraw()

var ledge_detector_left: DetectorUnit
var ledge_detector_right: DetectorUnit
var slope_detector_left: DetectorUnit
var slope_detector_right: DetectorUnit

func _ready() -> void:
	if not Engine.is_editor_hint():
		ledge_detector_left = _create_detector(down_direction, direction, ledge_detector_offset_left, false)
		ledge_detector_right = _create_detector(down_direction, direction, ledge_detector_offset_right, false)
		slope_detector_left = _create_detector(down_direction, direction, slope_detector_offset_left, true)
		slope_detector_right = _create_detector(down_direction, direction, slope_detector_offset_right, true)

func _create_detector(down_direction: int, direction: int, offset: float, slope: bool):
	if not Engine.is_editor_hint():
		var detector: DetectorUnit = DetectorUnit.new()
		detector.down_direction = down_direction
		detector.direction = direction
		detector.position = Vector2.UP.rotated(direction * (PI/2)) * offset
		detector.slope = slope
		add_child(detector, false, Node.INTERNAL_MODE_FRONT)
		detector.owner = owner
		return detector

func _update_detector(detector: DetectorUnit, down_direction: int, direction: int, offset: float, slope: bool):
	if not Engine.is_editor_hint():
		if detector is not DetectorUnit:
			return
		detector.down_direction = down_direction
		detector.direction = direction
		detector.position = Vector2.UP.rotated(direction * (PI/2)) * offset
		detector.slope = slope

func get_collision() -> DetectorCollision:
	var max_collision = null
	var detectors = [ledge_detector_left, ledge_detector_right, slope_detector_left, slope_detector_right]
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
		for offset in [[ledge_detector_offset_left, false], [ledge_detector_offset_right, false], [slope_detector_offset_left, true], [slope_detector_offset_right, true]]:
			var arrow_points: PackedVector2Array = [
				Vector2(-1, 0.5).rotated(direction * (PI/2)) + (Vector2.UP.rotated(direction * (PI/2)) * offset[0]),
				Vector2(-1, -0.5).rotated(direction * (PI/2)) + (Vector2.UP.rotated(direction * (PI/2)) * offset[0]),
				Vector2(0, 0).rotated(direction * (PI/2)) + (Vector2.UP.rotated(direction * (PI/2)) * offset[0])
			]
			var colors: PackedColorArray = [
				Color.WHITE, Color.WHITE, Color.WHITE
			]
			if offset[1]:
				colors.fill(Color.GREEN)
			draw_polygon(arrow_points, colors)
