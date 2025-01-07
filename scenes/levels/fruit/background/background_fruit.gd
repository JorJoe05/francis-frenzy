extends Node2D

func _process(delta: float) -> void:
	%Sky.region_rect.position.x += delta * 32
