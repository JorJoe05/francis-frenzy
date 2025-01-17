@tool
extends Marker2D
class_name LineCrossTrigger

signal triggered

var _prev_player_pos: Vector2
var _player_pos: Vector2

var _pairs = []

func _draw() -> void:
	if true:#Engine.is_editor_hint():
		draw_line(Vector2(0, -65536), Vector2(0, 65536), Color.RED)
	for f in range(0, _pairs.size()):
		draw_line(_pairs[f][0].rotated(-rotation), _pairs[f][1].rotated(-rotation), Color.from_hsv(float(f) / PI, 1, 1, 1), 0.5)

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
			_pairs.append([_prev_player_pos, _player_pos])
			queue_redraw()
			print("TRIGGERED >:(")
	
	check.call_deferred()
