extends Node2D
class_name Level

@export var music: AudioStream

var spawn_points: Dictionary
var gravity: float = 16.0
var player

func _ready() -> void:
	Music.set_stream(music)
	
	if spawn_points.has(SceneManager.get_spawn_point()):
		Game.player.global_position = spawn_points[SceneManager.get_spawn_point()].global_position
	else:
		Game.player.global_position = spawn_points.values()[0].global_position
