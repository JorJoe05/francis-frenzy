#PauseManager
extends Node

var _pause_condition: StringName

func set_condition(condition: StringName = "") -> Node:
	var set_condition = func(): _pause_condition = condition
	set_condition.call_deferred()
	get_tree().call_group.call_deferred(&"PauseManager", &"update")
	return self

func get_condition() -> StringName:
	return _pause_condition

func set_paused(paused: bool = true) -> Node:
	var pause = func(): get_tree().paused = paused
	pause.call_deferred()
	get_tree().call_group.call_deferred(&"PauseManager", &"update")
	return self

func get_paused() -> bool:
	return get_tree().paused
