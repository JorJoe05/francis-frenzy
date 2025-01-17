extends Node2D
class_name PlayerFollow

@export var x: bool = true
@export var y: bool = true

func _ready() -> void:
	pass#top_level = true

func _physics_process(delta: float) -> void:
	if x:
		global_position.x = Game.player.global_position.x
	if y:
		global_position.y = Game.player.global_position.y
