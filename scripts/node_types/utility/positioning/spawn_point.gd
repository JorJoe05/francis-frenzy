@tool
extends Node2D
class_name SpawnPoint

@export var id: StringName = "default":
	set(value):
		id = value
		queue_redraw()
@export var default: bool = false

@onready var _debug_texture = preload("res://sprites/debug/spr_spawnpoint.png")
@onready var _debug_font = preload("res://resources/fonts/pansy_hand/pansyhand.ttf")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if owner is Level:
		owner.spawn_points[id] = self
		if default:
			owner.spawn_point_default = self

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	match what:
		NOTIFICATION_READY:
			if owner is Level:
				pass
		NOTIFICATION_PREDELETE:
			pass

func _draw() -> void:
	if Engine.is_editor_hint():
		var _debug_color = Color.from_hsv((position.x + position.y) / 256, 1, 1, 1)
		draw_texture(_debug_texture, Vector2(-16, -16), _debug_color)
		draw_string(_debug_font, Vector2(-32, -18), id, HORIZONTAL_ALIGNMENT_CENTER, 64, 16, Color.BLACK, TextServer.JUSTIFICATION_KASHIDA)
