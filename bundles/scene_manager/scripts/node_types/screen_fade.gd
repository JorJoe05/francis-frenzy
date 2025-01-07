class_name SceneTransition
extends CanvasLayer

var scene : PackedScene
var startpos : StringName
var alpha : float
var color_rect : ColorRect

func _init(_scene : PackedScene, _startpos : StringName) -> void:
	scene = _scene
	startpos = _startpos
	layer = 127

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	color_rect = ColorRect.new()
	color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(color_rect)
	
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "alpha", 1.0, 0.25)
	await tween.finished
	
	SceneManager.set_startpos(startpos)
	get_tree().change_scene_to_packed(scene)
	
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "alpha", 0.0, 0.25)
	await tween.finished
	
	queue_free()

func _process(delta: float) -> void:
	color_rect.color.a = alpha
