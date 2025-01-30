@tool
class_name RayPair
extends RayCollider

signal collision_enter
signal collision_exit
signal snap_enter
signal snap_exit

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

var _has_collided: bool = false

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

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	set_deferred(&"_has_collided", false)

func _draw() -> void:
	if Engine.is_editor_hint():
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

func _get_max_detector() -> RayUnit:
	var max_collision = null
	var max_ray = null
	var detectors = [ledge_ray_left, ledge_ray_right, slope_ray_left, slope_ray_right]
	for detector in detectors:
		var collision = detector.get_collision()
		if max_collision == null:
			if collision.is_ray_colliding():
				max_collision = collision
				max_ray = detector
		else:
			if collision.get_relative_snap_delta() < max_collision.get_relative_snap_delta() and collision.is_ray_colliding():
				max_collision = collision
				max_ray = detector
	if max_collision == null:
		max_collision = detectors[0].get_collision()
		max_ray = detectors[0]
	return max_ray

func update_collision() -> RayCollision:
	var colliders = [ledge_ray_left, ledge_ray_right, slope_ray_left, slope_ray_right]
	for collider in colliders:
		pass
		#collider.update_collision()
	_has_collided = true
	return get_collision()

func get_collision() -> RayCollision:
	if _has_collided == false:
		update_collision()
	
	return _get_max_detector().get_collision()

func detect() -> bool:
	if _has_collided == false:
		update_collision()
		_is_colliding = _get_max_detector().detect()
	
	return _is_colliding

func detect_ext() -> bool:
	if _has_collided == false:
		update_collision()
		_is_snapping = _get_max_detector().detect_ext()
	
	return _is_snapping

func bounce() -> bool:
	if _has_collided == false:
		update_collision()
		_is_colliding = _get_max_detector().bounce()
	
	return _is_colliding

func collide() -> bool:
	if _has_collided == false:
		update_collision()
		_is_colliding = _get_max_detector().collide()
	
	return _is_colliding

func snap() -> bool:
	if _has_collided == false:
		update_collision()
		_is_snapping = _get_max_detector().snap()
	
	return _is_snapping
