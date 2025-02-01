extends ReferenceRect
class_name LoaderRect

var _enabler: VisibleOnScreenEnabler2D

func _ready() -> void:
	_enabler = VisibleOnScreenEnabler2D.new()
	_enabler.enable_node_path = get_path()
	_enabler.rect.size = get_rect().size
	add_child(_enabler)
