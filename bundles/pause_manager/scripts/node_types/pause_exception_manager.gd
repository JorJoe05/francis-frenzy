class_name PauseExceptionManager
extends Node

@export_enum(
	"Inherit", "Pausable", "When Paused", "Always", "Disabled"
) var default_process_mode: int = 0
@export var exceptions: Array[PauseException]

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	add_to_group(&"PauseManager")

func update() -> void:
	get_parent().process_mode = default_process_mode
	for exception in exceptions:
		if PauseManager.pause_condition == exception.condition and exception.enabled:
			get_parent().process_mode = exception.mode
