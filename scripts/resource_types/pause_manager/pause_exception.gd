class_name PauseException
extends Resource

@export var enabled: bool = true
@export var condition: StringName
@export_enum(
	"Inherit", "Pausable", "When Paused", "Always", "Disabled"
) var mode: int = 0
