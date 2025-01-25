@tool
extends Marker2D
class_name LineCrossTrigger

signal triggered

var _prev_player_pos: Vector2
var _player_pos: Vector2

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2(0, -65536), Vector2(0, 65536), Color.RED)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_prev_player_pos = Game.player.previous_position - position
	_player_pos = Game.player.position - position

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var check = func():
		_prev_player_pos = Game.player.previous_position - position
		_player_pos = Game.player.position - position
		
		if sign(Vector2(1, 0).rotated(rotation).dot(_prev_player_pos)) != sign(Vector2(1, 0).rotated(rotation).dot(_player_pos)):
			triggered.emit()
			queue_redraw()
	
	check.call_deferred()
