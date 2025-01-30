@tool
extends Node2D
class_name Chain

enum MoveType {
	ROTATE,
	SWING
}

@export var chain_texture: Texture2D = preload("res://sprites/common/spr_chain_16.png")
@export var movement_type: MoveType = 0
@export var segment_count: int = 5:
	set(value):
		segment_count = max(value, 2)
@export var chain_amount: int = 1:
	set(value):
		chain_amount = max(value, 1)
@export var period: float = 4.0
@export var frequency: float = 0.25:
	set(value):
		period = 1.0 / value
	get:
		return 1.0 / period
@export_range(0.0, 360.0) var arc: float = 180.0
@export_range(0.0, 360.0) var starting_offset: float = 0.0

var _rotation: float = wrapf((PI/2.0) + deg_to_rad(starting_offset), 0, (PI*2.0)):
	set(value):
		_rotation = wrapf(value, 0, PI*2.0)
var _previous_rotation: float =  wrapf((PI/2.0) + deg_to_rad(starting_offset), 0, (PI*2.0))
var _swing_rotation: float:
	get:
		return cos(_rotation) * deg_to_rad(arc/2.0) + (PI/2.0)
var _previous_swing_rotation: float = (PI/2.0)
var _chain_offset_increment: float:
	get:
		return (PI*2.0) / chain_amount
var _segment_size: float:
	get:
		return min(chain_texture.get_size().x, chain_texture.get_size().y)

var _debug_rotation: float =  wrapf((PI/2.0) + deg_to_rad(starting_offset), 0, (PI*2.0)):
	set(value):
		_debug_rotation = wrapf(value, 0, PI*2.0)
var _debug_swing_rotation: float:
	get:
		return cos(_debug_rotation + deg_to_rad(starting_offset)) * deg_to_rad(arc/2.0) + (PI/2.0)

func _process(delta: float) -> void:
	if not period == 0 and Engine.is_editor_hint():
		_debug_rotation += (delta * (PI*2.0)) / period
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not period == 0 and not Engine.is_editor_hint():
		_previous_rotation = _rotation
		_previous_swing_rotation = _swing_rotation
		_rotation += (delta * (PI*2.0)) / period
	
	match movement_type:
		MoveType.ROTATE:
			for _chain in range(0, chain_amount):
				if get_child_count() < _chain + 1:
					break
				var _child = get_child(_chain)
				var _previous_child_position = _child.position
				_child.position = Vector2.RIGHT.rotated(_rotation + (_chain_offset_increment * _chain)) * ((segment_count - 1) * _segment_size)
				if _child is Entity:
					_child.velocity = (_child.position - _previous_child_position) * ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
		MoveType.SWING:
			if get_child_count() < 1:
				return
			var _child = get_child(0)
			var _previous_child_position = _child.position
			_child.position = Vector2.RIGHT.rotated(_swing_rotation) * ((segment_count - 1) * _segment_size)
			if _child is Entity:
				_child.velocity = (_child.position - _previous_child_position) * ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

func _draw() -> void:
	if Engine.is_editor_hint():
		match movement_type:
			MoveType.ROTATE:
				draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(_debug_rotation + deg_to_rad(starting_offset)) * (segment_count - 1) * _segment_size, Color.BLUE)
				draw_circle(Vector2.ZERO, (segment_count - 1) * _segment_size, Color.RED, false)
			MoveType.SWING:
				draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(_debug_swing_rotation) * (segment_count - 1) * _segment_size, Color.BLUE)
				draw_line(Vector2.ZERO, Vector2.DOWN.rotated(-deg_to_rad(arc)/2.0) * (segment_count - 1) * _segment_size, Color.RED)
				draw_line(Vector2.ZERO, Vector2.DOWN.rotated(deg_to_rad(arc)/2.0) * (segment_count - 1) * _segment_size, Color.RED)
				draw_arc(Vector2.ZERO, (segment_count - 1) * _segment_size, (-deg_to_rad(arc)/2.0) + (PI/2.0), (deg_to_rad(arc)/2.0) + (PI/2.0), max(int(arc), 2), Color.RED)
	
	match movement_type:
		MoveType.ROTATE:
			for _chain in range(0, chain_amount):
				for _segment in range(0, segment_count):
					var _previous_position: Vector2 = Vector2.RIGHT.rotated(_previous_rotation + (_chain_offset_increment * _chain)) * (_segment * _segment_size)
					var _position: Vector2 = Vector2.RIGHT.rotated(_rotation + (_chain_offset_increment * _chain)) * (_segment * _segment_size)
					draw_texture(chain_texture, _previous_position.lerp(_position, Engine.get_physics_interpolation_fraction()) - (Vector2.ONE * _segment_size / 2.0))
		MoveType.SWING:
			for _segment in range(0, segment_count):
				var _previous_position: Vector2 = Vector2.RIGHT.rotated(_previous_swing_rotation) * (_segment * _segment_size)
				var _position: Vector2 = Vector2.RIGHT.rotated(_swing_rotation) * (_segment * _segment_size)
				draw_texture(chain_texture, _previous_position.lerp(_position, Engine.get_physics_interpolation_fraction()) - (Vector2.ONE * _segment_size / 2.0))
