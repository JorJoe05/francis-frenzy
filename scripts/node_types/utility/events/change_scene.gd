extends Node
class_name ChangeScene

@export_file("*.tscn") var scene: String
@export var spawn_point: StringName

@export var fade_in: PackedScene
@export var fade_in_start_method: StringName

@export var fade_out: PackedScene
@export var fade_out_start_method: StringName

func trigger() -> void:
	Game.player.process_mode - PROCESS_MODE_DISABLED
	if fade_in:
		SceneManager.set_fade_in_scene(fade_in, fade_in_start_method)
	if fade_out:
		SceneManager.set_fade_out_scene(fade_out, fade_out_start_method)
	
	SceneManager.set_spawn_point(spawn_point)
	SceneManager.change_scene_to_file(scene)
