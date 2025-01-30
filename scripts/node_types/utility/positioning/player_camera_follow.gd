extends CharacterBody2D
class_name PlayerCameraFollow

@export var x: bool = true
@export var y: bool = true
@export var use_curve: bool = false
@export var curve: Curve
@export var start: Marker2D
@export var end: Marker2D
@export var use_path: bool = false
@export var path: Path2D

func _ready() -> void:
	pass#top_level = true

func _physics_process(delta: float) -> void:
	if use_curve:
		global_position.x = Game.player.camera_target.global_position.x
		var _sample_pos = remap(global_position.x, start.global_position.x, end.global_position.x, 0.0, 1.0)
		global_position.y = lerp(start.global_position.y, end.global_position.y, curve.sample(_sample_pos))
		return
	if use_path:
		global_position = path.curve.get_closest_point(Game.player.camera_target.global_position)
		return
	if x:
		global_position.x = Game.player.camera_target.global_position.x
	if y:
		global_position.y = Game.player.camera_target.global_position.y
