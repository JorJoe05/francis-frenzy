extends CanvasLayer

var pause_before_fade: bool = true
var resume_after_fade: bool = false

var _spawn_point: StringName

var _fade_in_scene: PackedScene
var _fade_in_start_method: StringName

var _fade_out_scene: PackedScene
var _fade_out_start_method: StringName

func _ready() -> void:
	load_fade_default()

func _pause() -> void:
	PauseManager.set_condition(&"scene_fade")
	PauseManager.set_paused(true)

func _resume() -> void:
	PauseManager.set_paused(false)
	PauseManager.set_condition()

func _fade_in() -> void:
	if pause_before_fade: _pause()
	
	var _fade_in_inst = _fade_in_scene.instantiate()
	add_child(_fade_in_inst)
	await _fade_in_inst.call(_fade_in_start_method)
	_fade_in_inst.queue_free()
	
	if not pause_before_fade: _pause()

func _fade_out() -> void:
	if not resume_after_fade: _resume()
	
	var _fade_out_inst = _fade_out_scene.instantiate()
	add_child(_fade_out_inst)
	await _fade_out_inst.call(_fade_out_start_method)
	_fade_out_inst.queue_free()
	
	if resume_after_fade: _resume()

func load_fade_default() -> void:
	set_fade_in_scene(load("res://scenes/ui/scene_fades/circle_fade/circle_fade.tscn"), &"fade_in")
	set_fade_out_scene(load("res://scenes/ui/scene_fades/circle_fade/circle_fade.tscn"), &"fade_out")

func set_fade_in_scene(packed_scene: PackedScene, start_method: StringName) -> void:
	_fade_in_scene = packed_scene
	_fade_in_start_method = start_method

func set_fade_out_scene(packed_scene: PackedScene, start_method: StringName) -> void:
	_fade_out_scene = packed_scene
	_fade_out_start_method = start_method

func set_spawn_point(spawn_point: StringName) -> void:
	_spawn_point = spawn_point

func get_spawn_point() -> StringName:
	return _spawn_point

func change_scene_to_packed(packed_scene: PackedScene) -> void:
	await _fade_in()
	assert(get_tree().change_scene_to_packed(packed_scene) == OK)
	await _fade_out()

func change_scene_to_file(path: String) -> void:
	await _fade_in()
	#assert(get_tree().change_scene_to_file(path) == OK)
	get_tree().current_scene.queue_free()
	var _load = func():
		ResourceLoader.load_threaded_request(path)
		while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
		var _inst = ResourceLoader.load_threaded_get(path).instantiate()
		get_tree().root.add_child(_inst)
		get_tree().current_scene = _inst
	_load.call_deferred()
	
	await _fade_out()

func change_to_main_scene() -> void:
	change_scene_to_file(ProjectSettings.get_setting("application/run/main_scene"))
