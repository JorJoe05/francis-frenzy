extends Node

#region Scene Change

var _startpos : StringName

func set_startpos(startpos : StringName) -> void:
	_startpos = startpos

func get_startpos() -> StringName:
	return _startpos

func fade_scene_to_file(path : String, startpos : StringName = &"Default") -> void:
	var scene = load(path)
	get_tree().root.add_child(SceneTransition.new(scene, startpos))

func quit_to_title() -> void:
	fade_scene_to_file("res://scenes/menus/dev_menu/dev_menu.tscn")

#endregion
