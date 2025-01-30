extends Resource
class_name LevelGroup

@export var levels: Array[PackedScene]

var _memory: Dictionary

func preload_levels() -> void:
	for level in levels:
		_memory[level.get_rid()] = level.instantiate()

func has_rid(rid: RID) -> bool:
	for level in levels:
		if level.get_rid() == rid:
			return true
	return false

func has_level(level: PackedScene) -> bool:
	return has_rid(level.get_rid())
